module SisimaiLegacy
  module Rhost
    # SisimaiLegacy::Rhost detects the bounce reason from the content of SisimaiLegacy::Data
    # object as an argument of get() method when the value of "rhost" of the object
    # is "lsean.ezweb.ne.jp" or "msmx.au.com".
    # This class is called only SisimaiLegacy::Data class.
    module KDDI
      class << self
        # Imported from p5-Sisimail/lib/Sisimai/Rhost/KDDI.pm
        MessagesOf = {
          filtered:    '550 : User unknown',  # The response was: 550 : User unknown
          userunknown: '>: User unknown',     # The response was: 550 <...>: User unknown
        }.freeze

        # Detect bounce reason from au (KDDI)
        # @param    [SisimaiLegacy::Data] argvs   Parsed email object
        # @return   [String]                The bounce reason for au.com or ezweb.ne.jp
        def get(argvs)
          statusmesg = argvs.diagnosticcode
          reasontext = ''

          MessagesOf.each_key do |e|
            # Try to match the error message with message patterns defined in $MessagesOf
            next unless statusmesg.end_with?(MessagesOf[e])
            reasontext = e.to_s
            break
          end

          return reasontext
        end

      end
    end
  end
end


