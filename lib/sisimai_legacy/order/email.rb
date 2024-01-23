module SisimaiLegacy
  module Order
    # SisimaiLegacy::Order::Email makes optimized order list which include MTA modules
    # to be loaded on first from MTA specific headers in the bounce mail headers
    # such as X-Failed-Recipients.
    # This module are called from only SisimaiLegacy::Message::Email.
    module Email
      # Imported from p5-Sisimail/lib/Sisimai/Order/Email.pm
      class << self
        require 'sisimai/bite/email'

        EngineOrder1 = [
          # These modules have many subject patterns or have MIME encoded subjects
          # which is hard to code as regular expression
          'SisimaiLegacy::Bite::Email::Exim',
          'SisimaiLegacy::Bite::Email::Exchange2003',
        ].freeze
        EngineOrder2 = [
          # These modules have no MTA specific header and did not listed in the
          # following subject header based regular expressions.
          'SisimaiLegacy::Bite::Email::Exchange2007',
          'SisimaiLegacy::Bite::Email::Facebook',
          'SisimaiLegacy::Bite::Email::KDDI',
        ].freeze
        EngineOrder3 = [
          # These modules have no MTA specific header but listed in the following
          # subject header based regular expressions.
          'SisimaiLegacy::Bite::Email::Qmail',
          'SisimaiLegacy::Bite::Email::Notes',
          'SisimaiLegacy::Bite::Email::MessagingServer',
          'SisimaiLegacy::Bite::Email::Domino',
          'SisimaiLegacy::Bite::Email::EinsUndEins',
          'SisimaiLegacy::Bite::Email::OpenSMTPD',
          'SisimaiLegacy::Bite::Email::MXLogic',
          'SisimaiLegacy::Bite::Email::Postfix',
          'SisimaiLegacy::Bite::Email::Sendmail',
          'SisimaiLegacy::Bite::Email::Courier',
          'SisimaiLegacy::Bite::Email::IMailServer',
          'SisimaiLegacy::Bite::Email::SendGrid',
          'SisimaiLegacy::Bite::Email::Bigfoot',
          'SisimaiLegacy::Bite::Email::X4',
        ].freeze
        EngineOrder4 = [
          # These modules have no MTA specific headers and there are few samples or
          # too old MTA
          'SisimaiLegacy::Bite::Email::Verizon',
          'SisimaiLegacy::Bite::Email::InterScanMSS',
          'SisimaiLegacy::Bite::Email::MailFoundry',
          'SisimaiLegacy::Bite::Email::ApacheJames',
          'SisimaiLegacy::Bite::Email::Biglobe',
          'SisimaiLegacy::Bite::Email::EZweb',
          'SisimaiLegacy::Bite::Email::X5',
          'SisimaiLegacy::Bite::Email::X3',
          'SisimaiLegacy::Bite::Email::X2',
          'SisimaiLegacy::Bite::Email::X1',
          'SisimaiLegacy::Bite::Email::V5sendmail',
        ].freeze
        EngineOrder5 = [
          # These modules have one or more MTA specific headers but other headers
          # also required for detecting MTA name
          'SisimaiLegacy::Bite::Email::Google',
          'SisimaiLegacy::Bite::Email::Outlook',
          'SisimaiLegacy::Bite::Email::MailRu',
          'SisimaiLegacy::Bite::Email::MessageLabs',
          'SisimaiLegacy::Bite::Email::MailMarshalSMTP',
          'SisimaiLegacy::Bite::Email::MFILTER',
        ].freeze
        EngineOrder9 = [
          # These modules have one or more MTA specific headers
          'SisimaiLegacy::Bite::Email::Aol',
          'SisimaiLegacy::Bite::Email::Yahoo',
          'SisimaiLegacy::Bite::Email::AmazonSES',
          'SisimaiLegacy::Bite::Email::GMX',
          'SisimaiLegacy::Bite::Email::Yandex',
          'SisimaiLegacy::Bite::Email::ReceivingSES',
          'SisimaiLegacy::Bite::Email::Office365',
          'SisimaiLegacy::Bite::Email::AmazonWorkMail',
          'SisimaiLegacy::Bite::Email::Zoho',
          'SisimaiLegacy::Bite::Email::McAfee',
          'SisimaiLegacy::Bite::Email::Activehunter',
          'SisimaiLegacy::Bite::Email::SurfControl',
        ].freeze

        # This variable don't hold MTA name which have one or more MTA specific
        # header such as X-AWS-Outgoing, X-Yandex-Uniq.
        PatternTable = {
          'subject' => {
            'delivery' => [
              'SisimaiLegacy::Bite::Email::Exim',
              'SisimaiLegacy::Bite::Email::Courier',
              'SisimaiLegacy::Bite::Email::Google',
              'SisimaiLegacy::Bite::Email::Outlook',
              'SisimaiLegacy::Bite::Email::Domino',
              'SisimaiLegacy::Bite::Email::OpenSMTPD',
              'SisimaiLegacy::Bite::Email::EinsUndEins',
              'SisimaiLegacy::Bite::Email::InterScanMSS',
              'SisimaiLegacy::Bite::Email::MailFoundry',
              'SisimaiLegacy::Bite::Email::X4',
              'SisimaiLegacy::Bite::Email::X3',
              'SisimaiLegacy::Bite::Email::X2',
            ],
            'noti' => [
              'SisimaiLegacy::Bite::Email::Qmail',
              'SisimaiLegacy::Bite::Email::Sendmail',
              'SisimaiLegacy::Bite::Email::Google',
              'SisimaiLegacy::Bite::Email::Outlook',
              'SisimaiLegacy::Bite::Email::Courier',
              'SisimaiLegacy::Bite::Email::MessagingServer',
              'SisimaiLegacy::Bite::Email::OpenSMTPD',
              'SisimaiLegacy::Bite::Email::X4',
              'SisimaiLegacy::Bite::Email::X3',
              'SisimaiLegacy::Bite::Email::MFILTER',
            ],
            'return' => [
              'SisimaiLegacy::Bite::Email::Postfix',
              'SisimaiLegacy::Bite::Email::Sendmail',
              'SisimaiLegacy::Bite::Email::SendGrid',
              'SisimaiLegacy::Bite::Email::Bigfoot',
              'SisimaiLegacy::Bite::Email::X1',
              'SisimaiLegacy::Bite::Email::EinsUndEins',
              'SisimaiLegacy::Bite::Email::Biglobe',
              'SisimaiLegacy::Bite::Email::V5sendmail',
            ],
            'undeliver' => [
              'SisimaiLegacy::Bite::Email::Postfix',
              'SisimaiLegacy::Bite::Email::Exchange2007',
              'SisimaiLegacy::Bite::Email::Exchange2003',
              'SisimaiLegacy::Bite::Email::Notes',
              'SisimaiLegacy::Bite::Email::Office365',
              'SisimaiLegacy::Bite::Email::Verizon',
              'SisimaiLegacy::Bite::Email::SendGrid',
              'SisimaiLegacy::Bite::Email::IMailServer',
              'SisimaiLegacy::Bite::Email::MailMarshalSMTP',
            ],
            'failure' => [
              'SisimaiLegacy::Bite::Email::Qmail',
              'SisimaiLegacy::Bite::Email::Domino',
              'SisimaiLegacy::Bite::Email::Google',
              'SisimaiLegacy::Bite::Email::Outlook',
              'SisimaiLegacy::Bite::Email::MailRu',
              'SisimaiLegacy::Bite::Email::X4',
              'SisimaiLegacy::Bite::Email::X2',
              'SisimaiLegacy::Bite::Email::MFILTER',
            ],
            'warning' => [
              'SisimaiLegacy::Bite::Email::Postfix',
              'SisimaiLegacy::Bite::Email::Sendmail',
              'SisimaiLegacy::Bite::Email::Exim',
            ],
          },
        }.freeze

        # @abstract Make default order of MTA modules to be loaded
        # @return   [Array] Default order list of MTA modules
        def default
          return SisimaiLegacy::Bite::Email.index.map { |e| 'SisimaiLegacy::Bite::Email::' << e }
        end

        # @abstract Get regular expression patterns for specified field
        # @param    [String] group  Group name for "ORDER BY"
        # @return   [Hash]          Pattern table for the group
        def by(group = '')
          return {} if group.empty?
          return PatternTable[group] if PatternTable.key?(group)
          return {}
        end

        # @abstract Make MTA module list as a spare
        # @return   [Array] Ordered module list
        def another
          rv = []
          [EngineOrder1, EngineOrder2, EngineOrder3, EngineOrder4, EngineOrder5, EngineOrder9].each do |e|
            rv += e
          end
          return rv
        end

        # @abstract Make email header list in each MTA module
        # @return   [Hash] Header list to be parsed
        def headers
          order = SisimaiLegacy::Bite::Email.heads.map { |e| 'SisimaiLegacy::Bite::Email::' << e }
          table = {}
          skips = { 'return-path' => 1, 'x-mailer' => 1 }

          while e = order.shift do
            # Load email headers from each MTA module
            require e.gsub('::', '/').downcase

            Module.const_get(e).headerlist.each do |v|
              # Get header name which required each MTA module
              q = v.downcase
              next if skips.key?(q)
              table[q]  ||= {}
              table[q][e] = 1
            end
          end
          return table
        end

      end
    end
  end
end

