module SisimaiLegacy
  module Reason
    # SisimaiLegacy::Reason::Filtered checks the bounce reason is "filtered" or not.
    # This class is called only SisimaiLegacy::Reason class.
    #
    # This is the error that an email has been rejected by a header content after
    # SMTP DATA command.
    # In Japanese cellular phones, the error will incur that a sender's email address
    # or a domain is rejected by recipient's email configuration. Sisimai will
    # set "filtered" to the reason of email bounce if the value of Status: field
    # in a bounce email is "5.2.0" or "5.2.1".
    module Filtered
      # Imported from p5-Sisimail/lib/Sisimai/Reason/Filtered.pm
      class << self
        def text; return 'filtered'; end
        def description; return 'Email rejected due to a header content after SMTP DATA command'; end

        # Try to match that the given text and regular expressions
        # @param    [String] argv1  String to be matched with regular expressions
        # @return   [True,False]    false: Did not match
        #                           true: Matched
        def match(argv1)
          return nil unless argv1
          index = [
            'because the recipient is only accepting mail from specific email addresses',   # AOL Phoenix
            'bounced address',  # SendGrid|a message to an address has previously been Bounced.
            'due to extended inactivity new mail is not currently being accepted for this mailbox',
            'has restricted sms e-mail',    # AT&T
            'is not accepting any mail',
            'refused due to recipient preferences', # Facebook
            'resolver.rst.notauthorized',   # Microsoft Exchange
            'this account is protected by',
            'user not found',   # Filter on MAIL.RU
            'user reject',
            'we failed to deliver mail because the following address recipient id refuse to receive mail',  # Willcom
            'you have been blocked by the recipient',
          ]

          return true if index.any? { |a| argv1.include?(a) }
          return false
        end

        # Rejected by domain or address filter ?
        # @param    [SisimaiLegacy::Data] argvs   Object to be detected the reason
        # @return   [True,False]            true: is filtered
        #                                   false: is not filtered
        # @see http://www.ietf.org/rfc/rfc2822.txt
        def true(argvs)
          return true if argvs.reason == 'filtered'

          require 'sisimai_legacy/reason/userunknown'
          commandtxt = argvs.smtpcommand || ''
          diagnostic = argvs.diagnosticcode.downcase || ''
          tempreason = SisimaiLegacy::SMTP::Status.name(argvs.deliverystatus)
          alterclass = SisimaiLegacy::Reason::UserUnknown

          return false if tempreason == 'suspend'
          if tempreason == 'filtered'
            # Delivery status code points "filtered".
            return true if alterclass.match(diagnostic) || match(diagnostic)

          elsif commandtxt != 'RCPT' && commandtxt != 'MAIL'
            # Check the value of Diagnostic-Code and the last SMTP command
            return true if match(diagnostic)
            return true if alterclass.match(diagnostic)
          end
          return false
        end

      end
    end
  end
end
