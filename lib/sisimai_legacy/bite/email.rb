module SisimaiLegacy
  module Bite
    # Sisimai::Bite::Email- Base class for Sisimai::Bite::Email::*
    module Email
      class << self
        # Imported from p5-Sisimail/lib/Sisimai/Bite/Email.pm
        require 'sisimai/bite'

        # @abstract Flags for position variable
        # @return   [Hash] Position flag data
        # @private
        def INDICATORS
          return {
            :'deliverystatus' => (1 << 1),
            :'message-rfc822' => (1 << 2),
          }
        end
        def headerlist; return []; end

        # @abstract MTA list
        # @return   [Array] MTA list with order
        def index
          return %w[
            Sendmail Postfix Qmail Exim Courier OpenSMTPD Exchange2007 Exchange2003
            Google Yahoo GSuite Aol Outlook Office365 SendGrid AmazonSES MailRu
            Yandex MessagingServer Domino Notes ReceivingSES AmazonWorkMail Verizon
            GMX Bigfoot Facebook Zoho EinsUndEins MessageLabs EZweb KDDI Biglobe
            ApacheJames McAfee MXLogic MailFoundry IMailServer
            MFILTER Activehunter InterScanMSS SurfControl MailMarshalSMTP
            X1 X2 X3 X4 X5 V5sendmail FML]
        end

        # @abstract MTA list which have one or more extra headers
        # @return   [Array] MTA list (have extra headers)
        def heads
          return %w[
            Exim Exchange2007 Exchange2003 Google GSuite Office365 Outlook SendGrid
            AmazonSES ReceivingSES AmazonWorkMail Aol GMX MailRu MessageLabs Yahoo
            Yandex Zoho EinsUndEins MXLogic McAfee MFILTER EZweb Activehunter IMailServer
            SurfControl FML
          ]
        end

        # @abstract Parse bounce messages
        # @param         [Hash] mhead       Message header of a bounce email
        # @options mhead [String] from      From header
        # @options mhead [String] date      Date header
        # @options mhead [String] subject   Subject header
        # @options mhead [Array]  received  Received headers
        # @options mhead [String] others    Other required headers
        # @param         [String] mbody     Message body of a bounce email
        # @return        [Hash, Nil]        Bounce data list and message/rfc822
        #                                   part or nil if it failed to parse or
        #                                   the arguments are missing
        def scan; return nil; end

      end
    end
  end
end

