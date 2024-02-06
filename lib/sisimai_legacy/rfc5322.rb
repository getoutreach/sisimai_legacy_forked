module SisimaiLegacy
  # SisimaiLegacy::RFC5322 provide methods for checking email address.
  module RFC5322
    # Imported from p5-Sisimail/lib/Sisimai/RFC5322.pm
    class << self
      HeaderTable = {
        :messageid => ['Message-Id'],
        :subject   => ['Subject'],
        :listid    => ['List-Id'],
        :date      => %w[Date Posted-Date Posted Resent-Date],
        :addresser => %w[From Return-Path Reply-To Errors-To Reverse-Path X-Postfix-Sender Envelope-From X-Envelope-From],
        :recipient => %w[To Delivered-To Forward-Path Envelope-To X-Envelope-To Resent-To Apparently-To],
      }.freeze

      build_regular_expressions = lambda do
        # See http://www.ietf.org/rfc/rfc5322.txt
        #  or http://www.ex-parrot.com/pdw/Mail-RFC822-Address.html ...
        #   addr-spec       = local-part "@" domain
        #   local-part      = dot-atom / quoted-string / obs-local-part
        #   domain          = dot-atom / domain-literal / obs-domain
        #   domain-literal  = [CFWS] "[" *([FWS] dcontent) [FWS] "]" [CFWS]
        #   dcontent        = dtext / quoted-pair
        #   dtext           = NO-WS-CTL /     ; Non white space controls
        #                     %d33-90 /       ; The rest of the US-ASCII
        #                     %d94-126        ;  characters not including "[",
        #                                     ;  "]", or "\"
        re             = { rfc5322: nil, ignored: nil, domain: nil }
        atom           = %r([a-zA-Z0-9_!#\$\%&'*+/=?\^`{}~|\-]+)o
        quoted_string  = %r/"(?:\\[^\r\n]|[^\\"])*"/o
        domain_literal = %r/\[(?:\\[\x01-\x09\x0B-\x0c\x0e-\x7f]|[\x21-\x5a\x5e-\x7e])*\]/o
        dot_atom       = %r/#{atom}(?:[.]#{atom})*/o
        local_part     = %r/(?:#{dot_atom}|#{quoted_string})/o
        domain         = %r/(?:#{dot_atom}|#{domain_literal})/o

        re[:rfc5322]   = %r/\A#{local_part}[@]#{domain}\z/o
        re[:ignored]   = %r/\A#{local_part}[.]*[@]#{domain}\z/o
        re[:domain]    = %r/\A#{domain}\z/o

        return re
      end

      build_flatten_rfc822header_list = lambda do
        # Convert HEADER: structured hash table to flatten hash table for being
        # called from SisimaiLegacy::Bite::Email::*
        fv = {}
        HeaderTable.each_value do |e|
          e.each { |ee| fv[ee.downcase] = 1 }
        end
        return fv
      end

      Re          = build_regular_expressions.call
      HeaderIndex = build_flatten_rfc822header_list.call

      # Grouped RFC822 headers
      # @param    [Symbol] group  RFC822 Header group name
      # @return   [Array,Hash]    RFC822 Header list
      def HEADERFIELDS(group = '')
        return HeaderIndex if group.empty?
        return HeaderTable[group] if HeaderTable.key?(group)
        return HeaderTable
      end

      # Fields that might be long
      # @return   [Hash] Long filed(email header) list
      def LONGFIELDS
        return { 'to' => 1, 'from' => 1, 'subject' => 1, 'message-id' => 1 }
      end
      LongHeaders = SisimaiLegacy::RFC5322.LONGFIELDS

      # Check that the argument is an email address or not
      # @param    [String] email  Email address string
      # @return   [True,False]    true: is an email address
      #                           false: is not an email address
      def is_emailaddress(email)
        return false unless email.is_a?(::String)
        return false if email =~ %r/(?:[\x00-\x1f]|\x1f)/
        return false if email.size > 254
        return true  if email =~ Re[:ignored]
        return false
      end

      # Check that the argument is an domain part of email address or not
      # @param    [String] dpart  Domain part of the email address
      # @return   [True,False]    true: Valid domain part
      #                           false: Not a valid domain part
      def is_domainpart(dpart)
        return false unless dpart.is_a?(::String)
        return false if dpart =~ /(?:[\x00-\x1f]|\x1f)/
        return false if dpart.include?('@')
        return true  if dpart =~ Re[:domain]
        return false
      end

      # Check that the argument is mailer-daemon or not
      # @param    [String] email  Email address
      # @return   [True,False]    true: mailer-daemon
      #                           false: Not mailer-daemon
      def is_mailerdaemon(email)
        return false unless email.is_a?(::String)

        re = %r/(?:
           (?:mailer-daemon|postmaster)[@]
          |[<(](?:mailer-daemon|postmaster)[)>]
          |\A(?:mailer-daemon|postmaster)\z
          |[ ]?mailer-daemon[ ]
          )
        /x
        return true if email.downcase =~ re
        return false
      end

      # Convert Received headers to a structured data
      # @param    [String] argvs  Received header
      # @return   [Array]         Received header as a structured data
      def received(argvs)
        return [] unless argvs.is_a?(::String)

        hosts = []
        value = { 'from' => '', 'by' => '' }

        # Received: (qmail 10000 invoked by uid 999); 24 Apr 2013 00:00:00 +0900
        return [] if argvs =~ /qmail[ ]+.+invoked[ ]+/

        if cr = argvs.match(/\Afrom[ ]+(.+)[ ]+by[ ]+([^ ]+)/)
          # Received: from localhost (localhost)
          #   by nijo.example.jp (V8/cf) id s1QB5ma0018057;
          #   Wed, 26 Feb 2014 06:05:48 -0500
          value['from'] = cr[1]
          value['by']   = cr[2]

        elsif cr = argvs.match(/\bby[ ]+([^ ]+)(.+)/)
          # Received: by 10.70.22.98 with SMTP id c2mr1838265pdf.3; Fri, 18 Jul 2014
          #   00:31:02 -0700 (PDT)
          value['from'] = cr[1] + cr[2]
          value['by']   = cr[1]
        end

        if value['from'].include?(' ')
          # Received: from [10.22.22.222] (smtp-gateway.kyoto.ocn.ne.jp [192.0.2.222])
          #   (authenticated bits=0)
          #   by nijo.example.jp (V8/cf) with ESMTP id s1QB5ka0018055;
          #   Wed, 26 Feb 2014 06:05:47 -0500
          received = value['from'].split(' ')
          namelist = []
          addrlist = []
          hostname = ''
          hostaddr = ''

          while e = received.shift do
            # Received: from [10.22.22.222] (smtp-gateway.kyoto.ocn.ne.jp [192.0.2.222])
            if e =~ /\A[\[(]\d+[.]\d+[.]\d+[.]\d+[)\]]\z/
              # [192.0.2.1] or (192.0.2.1)
              e = e.delete('[]()')
              addrlist << e
            else
              # hostname
              e = e.delete('()')
              namelist << e
            end
          end

          while e = namelist.shift do
            # 1. Hostname takes priority over all other IP addresses
            next unless e.include?('.')
            hostname = e
            break
          end

          if hostname.empty?
            # 2. Use IP address as a remote host name
            addrlist.each do |e|
              # Skip if the address is a private address
              next if e.start_with?('10.', '127.', '192.168.')
              next if e =~ /\A172[.](?:1[6-9]|2[0-9]|3[0-1])[.]/
              hostaddr = e
              break
            end
          end

          value['from'] = hostname || hostaddr || addrlist[-1]
        end

        %w[from by].each do |e|
          # Copy entries into hosts
          next if value[e].empty?
          value[e] = value[e].delete('[]();?')
          hosts << value[e]
        end
        return hosts
      end

      # Weed out rfc822/message header fields excepct necessary fields
      # @param    [Array] argv1  each line divided message/rc822 part
      # @return   [String]       Selected fields
      def weedout(argv1)
        return nil unless argv1.is_a?(Array)

        rfc822next = { from: false, to: false, subject: false }
        rfc822part = '' # (String) message/rfc822-headers part
        previousfn = '' # (String) Previous field name

        while e = argv1.shift do
          # After "message/rfc822"
          if cv = e.match(/\A([-0-9A-Za-z]+?)[:][ ]*.*\z/)
            # Get required headers
            lhs = cv[1].downcase
            previousfn = ''
            next unless HeaderIndex.key?(lhs)

            previousfn  = lhs
            rfc822part << e + "\n"

          elsif e.start_with?(' ', "\t")
            # Continued line from the previous line
            next if rfc822next[previousfn]
            rfc822part << e + "\n" if LongHeaders.key?(previousfn)
          else
            # Check the end of headers in rfc822 part
            next unless LongHeaders.key?(previousfn)
            next unless e.empty?
            rfc822next[previousfn] = true
          end
        end

        return rfc822part
      end

    end
  end
end

