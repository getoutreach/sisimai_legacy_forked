module SisimaiLegacy
  module SMTP
    # SisimaiLegacy::SMTP::Error is utilities for checking SMTP Errors from error
    # message text.
    module Error
      # Imported from p5-Sisimail/lib/Sisimai/SMTP/Error.pm
      class << self
        require 'sisimai_legacy/smtp/reply'
        require 'sisimai_legacy/smtp/status'

        SoftOrHard = {
          :soft => %w[
            blocked contenterror exceedlimit expired filtered mailboxfull
            mailererror mesgtoobig networkerror norelaying policyviolation
            rejected securityerror spamdetected suspend syntaxerror systemerror
            systemfull toomanyconn virusdetected],
          :hard => %w[hasmoved hostunknown userunknown]
        }.freeze

        # Permanent error or not
        # @param    [String] argv1  String including SMTP Status code
        # @return   [Boolean]       true:  Permanet error
        #                           false: Temporary error
        #                           nil:   is not an error
        # @since v4.17.3
        def is_permanent(argv1 = '')
          getchecked = nil
          statuscode = SisimaiLegacy::SMTP::Status.find(argv1)
          statuscode = SisimaiLegacy::SMTP::Reply.find(argv1) if statuscode.empty?
          classvalue = statuscode[0, 1].to_i

          if classvalue > 0
            # 2, 4, or 5
            if classvalue == 5
              # Permanent error
              getchecked = true

            elsif classvalue == 4
              # Temporary error
              getchecked = false

            elsif classvalue == 2
              # Succeeded
              getchecked = nil
            end
          else
            # Check with regular expression
            v = argv1.downcase
            getchecked = if v.include?('temporar') || v.include?('persistent')
                           # Temporary failure
                           false
                         elsif v.include?('permanent')
                           # Permanently failure
                           true
                         end
          end

          return getchecked
        end

        # Check softbounce or not
        # @param    [String] argv1  Detected bounce reason
        # @param    [String] argv2  String including SMTP Status code
        # @return   [String]        'soft': Soft bounce
        #                           'hard': Hard bounce
        #                           '':     May not be bounce ?
        # @since v4.17.3
        def soft_or_hard(argv1 = '', argv2 = '')
          return '' if argv1.empty?

          getchecked = nil
          softorhard = nil

          if %w[delivered feedback vacation].include?(argv1)
            # These are not dealt as a bounce reason
            softorhard = ''

          elsif argv1 == 'onhold' || argv1 == 'undefined'
            # It should be "soft" when a reason is "onhold" or "undefined"
            softorhard = 'soft'

          elsif argv1 == 'notaccept'
            # NotAccept: 5xx => hard bounce, 4xx => soft bounce
            if argv2.size > 0
              # Get D.S.N. or SMTP reply code from The 2nd argument string
              statuscode = SisimaiLegacy::SMTP::Status.find(argv2)
              statuscode = SisimaiLegacy::SMTP::Reply.find(argv2) if statuscode.empty?
              classvalue = statuscode[0, 1].to_i

              softorhard = if classvalue == 4
                             # Deal as a "soft bounce"
                             'soft'
                           else
                             # 5 or 0, deal as a "hard bounce"
                             'hard'
                           end
            else
              # "notaccept" is a hard bounce
              softorhard = 'hard'
            end

          else
            # Check all the reasons defined at the above
            catch :SOFT_OR_HARD do
              while true
                [:hard, :soft].each do |e|
                  # Soft or Hard?
                  SoftOrHard[e].each do |f|
                    # Hard bounce?
                    next unless argv1 == f
                    softorhard = e.to_s
                    throw :SOFT_OR_HARD
                  end
                end

                break
              end
            end
          end

          return softorhard
        end

      end
    end
  end
end
