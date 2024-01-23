module SisimaiLegacy
  module Reason
    # Sisimai::Reason::UserUnknown checks the bounce reason is "userunknown" or
    # not. This class is called only Sisimai::Reason class.
    #
    # This is the error that a local part (Left hand side of @ sign) of a recipient's
    # email address does not exist. In many case, a user has changed internet service
    # provider, or has quit company, or the local part is misspelled. Sisimai will
    # set "userunknown" to the reason of email bounce if the value of Status: field
    # in a bounce email is "5.1.1", or connection was refused at SMTP RCPT command,
    # or the contents of Diagnostic-Code: field represents that it is unknown user.
    #
    #   <kijitora@example.co.jp>: host mx01.example.co.jp[192.0.2.8] said:
    #   550 5.1.1 Address rejected kijitora@example.co.jp (in reply to
    #   RCPT TO command)
    module UserUnknown
      # Imported from p5-Sisimail/lib/Sisimai/Reason/UserUnknown.pm
      class << self
        def text; return 'userunknown'; end
        def description; return "Email rejected due to a local part of a recipient's email address does not exist"; end

        # Try to match that the given text and regular expressions
        # @param    [String] argv1  String to be matched with regular expressions
        # @return   [True,False]    false: Did not match
        #                           true: Matched
        def match(argv1)
          return nil unless argv1
          regex = %r{(?>
             .+[ ]user[ ]unknown
            |[#]5[.]1[.]1[ ]bad[ ]address
            |[<].+[>][ ]not[ ]found
            |[<].+[@].+[>][.][.][.][ ]blocked[ ]by[ ]
            |5[.]0[.]0[.][ ]mail[ ]rejected[.]
            |5[.]1[.]0[ ]address[ ]rejected[.]
            |adresse[ ]d[ ]au[ ]moins[ ]un[ ]destinataire[ ]invalide.+[a-z]{3}.+(?:416|418)
            |address[ ](?:does[ ]not[ ]exist|unknown)
            |archived[ ]recipient
            |bad[-_ ]recipient
            |can[']t[ ]accept[ ]user
            |destination[ ](?:
               addresses[ ]were[ ]unknown
              |server[ ]rejected[ ]recipients
              )
            |email[ ]address[ ](?:does[ ]not[ ]exist|could[ ]not[ ]be[ ]found)
            |invalid[ ](?:
               address
              |mailbox:
              |mailbox[ ]path
              |recipient
              )
            |is[ ]not[ ](?:
               a[ ]known[ ]user
              |a[ ]valid[ ]mailbox
              |an[ ]active[ ]address[ ]at[ ]this[ ]host
              )
            |mailbox[ ](?:
               .+[ ]does[ ]not[ ]exist
              |.+[@].+[ ]unavailable
              |invalid
              |is[ ](?:inactive|unavailable)
              |not[ ](?:present|found)
              |unavailable
              )
            |no[ ](?:
               [ ].+[ ]in[ ]name[ ]directory
              |account[ ]by[ ]that[ ]name[ ]here
              |existe[ ](?:dicha[ ]persona|ese[ ]usuario[ ])
              |mail[ ]box[ ]available[ ]for[ ]this[ ]user
              |mailbox[ ](?:
                 by[ ]that[ ]name[ ]is[ ]currently[ ]available
                |found
                )
              |matches[ ]to[ ]nameserver[ ]query
              |such[ ](?:
                 address[ ]here
                |mailbox
                |person[ ]at[ ]this[ ]address
                |recipient
                |user(?:[ ]here)?
                )
              |thank[ ]you[ ]rejected:[ ]account[ ]unavailable:
              |valid[ ]recipients[,][ ]bye    # Microsoft
              )
            |non[- ]?existent[ ]user
            |not[ ](?:
               a[ ]valid[ ]user[ ]here
              |a[ ]local[ ]address
              |email[ ]addresses
              )
            |rcpt[ ][<].+[>][ ]does[ ]not[ ]exist
            |rece?ipient[ ](?:
               .+[ ]was[ ]not[ ]found[ ]in
              |address[ ]rejected:[ ](?:
                 access[ ]denied
                |invalid[ ]user
                |user[ ].+[ ]does[ ]not[ ]exist
                |user[ ]unknown[ ]in[ ].+[ ]table
                |unknown[ ]user
                )
              |does[ ]not[ ]exist(?:[ ]on[ ]this[ ]system)?
              |is[ ]not[ ]local
              |not[ ](?:exist|found|ok)
              |unknown
              )
            |requested[ ]action[ ]not[ ]taken:[ ]mailbox[ ]unavailable
            |resolver[.]adr[.]recip(?:ient)notfound
            |said:[ ]550[-[ ]]5[.]1[.]1[ ].+[ ]user[ ]unknown[ ]
            |smtp[ ]error[ ]from[ ]remote[ ]mail[ ]server[ ]after[ ]end[ ]of[ ]data:[ ]553.+does[ ]not[ ]exist
            |sorry,[ ](?:
               user[ ]unknown
              |badrcptto
              |no[ ]mailbox[ ]here[ ]by[ ]that[ ]name
              )
            |the[ ](?:
               email[ ]account[ ]that[ ]you[ ]tried[ ]to[ ]reach[ ]does[ ]not[ ]exist
              |following[ ]recipients[ ]was[ ]undeliverable
              |user[']s[ ]email[ ]name[ ]is[ ]not[ ]found
              )
            |there[ ]is[ ]no[ ]one[ ]at[ ]this[ ]address
            |this[ ](?:
               address[ ]no[ ]longer[ ]accepts[ ]mail
              |email[ ]address[ ]is[ ]wrong[ ]or[ ]no[ ]longer[ ]valid
              |spectator[ ]does[ ]not[ ]exist
              |user[ ]doesn[']?t[ ]have[ ]a[ ].+[ ]account
              )
            |unknown[ ](?:
               e[-]?mail[ ]address
              |local[- ]part
              |mailbox
              |recipient
              |user
              )
            |user[ ](?:
               .+[ ]was[ ]not[ ]found
              |.+[ ]does[ ]not[ ]exist
              |does[ ]not[ ]exist
              |missing[ ]home[ ]directory
              |not[ ](?:active|found|known)
              |unknown
              )
            |vdeliver:[ ]invalid[ ]or[ ]unknown[ ]virtual[ ]user
            |your[ ]envelope[ ]recipient[ ]is[ ]in[ ]my[ ]badrcptto[ ]list
            )
          }x

          return true if argv1 =~ regex
          return false
        end

        # Whether the address is "userunknown" or not
        # @param    [Sisimai::Data] argvs   Object to be detected the reason
        # @return   [True,False]            true: is unknown user
        #                                   false: is not unknown user.
        # @see http://www.ietf.org/rfc/rfc2822.txt
        def true(argvs)
          return true if argvs.reason == 'userunknown'

          diagnostic = argvs.diagnosticcode.downcase;
          tempreason = Sisimai::SMTP::Status.name(argvs.deliverystatus)
          return false if tempreason == 'suspend'

          if tempreason == 'userunknown'
            # *.1.1 = 'Bad destination mailbox address'
            #   Status: 5.1.1
            #   Diagnostic-Code: SMTP; 550 5.1.1 <***@example.jp>:
            #     Recipient address rejected: User unknown in local recipient table
            prematches = %w[NoRelaying Blocked MailboxFull HasMoved Blocked Rejected]
            matchother = false

            while e = prematches.shift do
              # Check the value of "Diagnostic-Code" with other error patterns.
              p = 'Sisimai::Reason::' << e
              r = nil
              begin
                require p.downcase.gsub('::', '/')
                r = Module.const_get(p)
              rescue
                warn '***warning: Failed to load ' << p
                next
              end

              next unless r.match(diagnostic)
              # Match with reason defined in Sisimai::Reason::* except UserUnknown.
              matchother = true
              break
            end
            return true unless matchother # Did not match with other message patterns

          elsif argvs.smtpcommand == 'RCPT'
            # When the SMTP command is not "RCPT", the session rejected by other
            # reason, maybe.
            return true if match(diagnostic)
          end

          return false
        end

      end
    end
  end
end



