module SisimaiLegacy
  # SisimaiLegacy::Rhost detects the bounce reason from the content of SisimaiLegacy::Data
  # object as an argument of get() method when the value of rhost of the object
  # is listed in the results of SisimaiLegacy::Rhost->list method.
  # This class is called only SisimaiLegacy::Data class.
  module Rhost
    class << self
      # Imported from p5-Sisimail/lib/Sisimai/Rhost.pm
      RhostClass = {
        'aspmx.l.google.com'          => 'GoogleApps',
        '.prod.outlook.com'           => 'ExchangeOnline',
        '.protection.outlook.com'     => 'ExchangeOnline',
        'smtp.secureserver.net'       => 'GoDaddy',
        'mailstore1.secureserver.net' => 'GoDaddy',
        'laposte.net'                 => 'FrancePTT',
        'orange.fr'                   => 'FrancePTT',
        'lsean.ezweb.ne.jp'           => 'KDDI',
        'msmx.au.com'                 => 'KDDI',
      }.freeze

      # Retrun the list of remote hosts Sisimai support
      # @return   [Array] Remote host list
      def list
        return RhostClass.keys
      end

      # The value of "rhost" is listed in RhostClass or not
      # @param    [String] argvs  Remote host name
      # @return   [True,False]    True: matched
      #                           False: did not match
      def match(rhost)
        return false if rhost.empty?

        host0 = rhost.downcase
        match = false

        RhostClass.each_key do |e|
          # Try to match with each key of RhostClass
          next unless host0.end_with?(e)
          match = true
          break
        end
        return match
      end

      # Detect the bounce reason from certain remote hosts
      # @param    [SisimaiLegacy::Data] argvs   Parsed email object
      # @return   [String]                The value of bounce reason
      def get(argvs)
        remotehost = argvs.rhost.downcase
        rhostclass = ''
        modulename = ''

        RhostClass.each_key do |e|
          # Try to match with each key of RhostClass
          next unless remotehost.end_with?(e)
          modulename = 'SisimaiLegacy::Rhost::' << RhostClass[e]
          rhostclass = modulename.gsub('::', '/').downcase.gsub('sisimailegacy', 'sisimai_legacy')
          break
        end

        require rhostclass
        reasontext = Module.const_get(modulename).get(argvs)
        return reasontext
      end
    end
  end
end
