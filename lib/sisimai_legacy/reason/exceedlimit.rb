module SisimaiLegacy
  module Reason
    # SisimaiLegacy::Reason::ExceedLimit checks the bounce reason is "exceedlimit" or
    # not. This class is called only SisimaiLegacy::Reason class.
    #
    # This is the error that a message was rejected due to an email exceeded the
    # limit. The value of D.S.N. is 5.2.3. This reason is almost the same as
    # "MesgTooBig", we think.
    module ExceedLimit
      # Imported from p5-Sisimail/lib/Sisimai/Reason/ExceedLimit.pm
      class << self
        def text; return 'exceedlimit'; end
        def description; return 'Email rejected due to an email exceeded the limit'; end

        # Try to match that the given text and regular expressions
        # @param    [String] argv1  String to be matched with regular expressions
        # @return   [True,False]    false: Did not match
        #                           true: Matched
        def match(argv1)
          return nil unless argv1
          index = ['message too large']

          return true if index.any? { |a| argv1.include?(a) }
          return false
        end

        # Exceed limit or not
        # @param    [SisimaiLegacy::Data] argvs Object to be detected the reason
        # @return   [True,False]          true: Exceeds the limit
        #                                 false: Did not exceed the limit
        # @see      http://www.ietf.org/rfc/rfc2822.txt
        def true(argvs)
          return nil  if argvs.deliverystatus.empty?
          return true if argvs.reason == 'exceedlimit'

          # Delivery status code points exceedlimit.
          # Status: 5.2.3
          # Diagnostic-Code: SMTP; 552 5.2.3 Message size exceeds fixed maximum message size
          return true if SisimaiLegacy::SMTP::Status.name(argvs.deliverystatus) == 'exceedlimit'

          # Check the value of Diagnosic-Code: header with patterns
          return true if match(argvs.diagnosticcode.downcase)
          return false
        end

      end
    end
  end
end

