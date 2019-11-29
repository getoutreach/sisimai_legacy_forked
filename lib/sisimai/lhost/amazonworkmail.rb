module Sisimai::Lhost
  # Sisimai::Lhost::AmazonWorkMail parses a bounce email which created by
  # Amazon WorkMail. Methods in the module are called from only Sisimai::Message.
  module AmazonWorkMail
    class << self
      # Imported from p5-Sisimail/lib/Sisimai/Lhost/AmazonWorkMail.pm
      require 'sisimai/lhost'

      # https://aws.amazon.com/workmail/
      Indicators = Sisimai::Lhost.INDICATORS
      StartingOf = {
        message: ['Technical report:'],
        rfc822:  ['content-type: message/rfc822'],
      }.freeze

      def description; return 'Amazon WorkMail: https://aws.amazon.com/workmail/'; end
      def smtpagent;   return Sisimai::Lhost.smtpagent(self); end

      # X-Mailer: Amazon WorkMail
      # X-Original-Mailer: Amazon WorkMail
      # X-Ses-Outgoing: 2016.01.14-54.240.27.159
      def headerlist;  return %w[x-ses-outgoing x-original-mailer]; end

      # Parse bounce messages from Amazon WorkMail
      # @param         [Hash] mhead       Message headers of a bounce email
      # @options mhead [String] from      From header
      # @options mhead [String] date      Date header
      # @options mhead [String] subject   Subject header
      # @options mhead [Array]  received  Received headers
      # @options mhead [String] others    Other required headers
      # @param         [String] mbody     Message body of a bounce email
      # @return        [Hash, Nil]        Bounce data list and message/rfc822
      #                                   part or nil if it failed to parse or
      #                                   the arguments are missing
      def make(mhead, mbody)
        # :'subject'  => %r/Delivery[_ ]Status[_ ]Notification[_ ].+Failure/,
        # :'received' => %r/.+[.]smtp-out[.].+[.]amazonses[.]com\b/,
        # :'x-mailer' => %r/\AAmazon WorkMail\z/,
        match = 0
        xmail = mhead['x-original-mailer'] || mhead['x-mailer'] || ''

        match += 1 if mhead['x-ses-outgoing']
        unless xmail.empty?
          # X-Mailer: Amazon WorkMail
          # X-Original-Mailer: Amazon WorkMail
          match += 1 if xmail == 'Amazon WorkMail'
        end
        return nil if match < 2

        require 'sisimai/rfc1894'
        fieldtable = Sisimai::RFC1894.FIELDTABLE
        permessage = {}     # (Hash) Store values of each Per-Message field

        dscontents = [Sisimai::Lhost.DELIVERYSTATUS]
        hasdivided = mbody.split("\n")
        rfc822list = []     # (Array) Each line in message/rfc822 part string
        blanklines = 0      # (Integer) The number of blank lines
        readcursor = 0      # (Integer) Points the current cursor position
        recipients = 0      # (Integer) The number of 'Final-Recipient' header
        v = nil

        while e = hasdivided.shift do
          if readcursor == 0
            # Beginning of the bounce message or message/delivery-status part
            if e == StartingOf[:message][0]
              readcursor |= Indicators[:deliverystatus]
              next
            end
          end

          if (readcursor & Indicators[:'message-rfc822']) == 0
            # Beginning of the original message part(message/rfc822)
            if e == StartingOf[:rfc822][0]
              readcursor |= Indicators[:'message-rfc822']
              next
            end
          end

          if readcursor & Indicators[:'message-rfc822'] > 0
            # message/rfc822 OR text/rfc822-headers part
            if e.empty?
              blanklines += 1
              break if blanklines > 1
              next
            end
            rfc822list << e
          else
            # message/delivery-status part
            next if (readcursor & Indicators[:deliverystatus]) == 0
            next if e.empty?

            if f = Sisimai::RFC1894.match(e)
              # "e" matched with any field defined in RFC3464
              o = Sisimai::RFC1894.field(e) || next
              v = dscontents[-1]

              if o[-1] == 'addr'
                # Final-Recipient: rfc822; kijitora@example.jp
                # X-Actual-Recipient: rfc822; kijitora@example.co.jp
                if o[0] == 'final-recipient'
                  # Final-Recipient: rfc822; kijitora@example.jp
                  if v['recipient']
                    # There are multiple recipient addresses in the message body.
                    dscontents << Sisimai::Lhost.DELIVERYSTATUS
                    v = dscontents[-1]
                  end
                  v['recipient'] = o[2]
                  recipients += 1
                else
                  # X-Actual-Recipient: rfc822; kijitora@example.co.jp
                  v['alias'] = o[2]
                end
              elsif o[-1] == 'code'
                # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                v['spec'] = o[1]
                v['diagnosis'] = o[2]
              else
                # Other DSN fields defined in RFC3464
                next unless fieldtable.key?(o[0])
                v[fieldtable[o[0]]] = o[2]

                next unless f == 1
                permessage[fieldtable[o[0]]] = o[2]
              end
            end

            # <!DOCTYPE HTML><html>
            # <head>
            # <meta name="Generator" content="Amazon WorkMail v3.0-2023.77">
            # <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
            break if e.start_with?('<!DOCTYPE HTML><html>')
          end # End of message/delivery-status
        end
        return nil unless recipients > 0

        dscontents.each do |e|
          # Set default values if each value is empty.
          e['lhost'] ||= permessage['rhost']
          permessage.each_key { |a| e[a] ||= permessage[a] || '' }

          e['diagnosis'] = Sisimai::String.sweep(e['diagnosis'])
          if e['status'].to_s.start_with?('5.0.0', '5.1.0', '4.0.0', '4.1.0')
            # Get other D.S.N. value from the error message
            errormessage = e['diagnosis']

            if cv = e['diagnosis'].match(/["'](\d[.]\d[.]\d.+)['"]/)
              # 5.1.0 - Unknown address error 550-'5.7.1 ...
              errormessage = cv[1]
            end
            e['status'] = Sisimai::SMTP::Status.find(errormessage) || e['status']
          end

          if cv = e['diagnosis'].match(/[<]([245]\d\d)[ ].+[>]/)
            # 554 4.4.7 Message expired: unable to deliver in 840 minutes.
            # <421 4.4.2 Connection timed out>
            e['replycode'] = cv[1]
          end

          e['reason'] ||= Sisimai::SMTP::Status.name(e['status']) || ''
          e['agent']    = self.smtpagent
        end

        rfc822part = Sisimai::RFC5322.weedout(rfc822list)
        return { 'ds' => dscontents, 'rfc822' => rfc822part }
      end

    end
  end
end
