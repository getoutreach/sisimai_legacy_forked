module SisimaiLegacy
  module Bite
    # SisimaiLegacy::Bite::JSON - Base class for SisimaiLegacy::Bite::JSON::*
    module JSON
      class << self
        # Imported from p5-Sisimail/lib/Sisimai/Bite/JSON.pm
        require 'sisimai/bite'

        def headerlist; return []; end

        # MTA list
        # @return   [Array] MTA list with order
        def index
          return %w[SendGrid AmazonSES]
        end

        # Convert from JSON object to SisimaiLegacy::Message
        # @param         [Hash] mhead   Message header of a bounce email
        # @param         [String] mbody Message body of a bounce email(JSON)
        # @return        [Hash, Nil]    Bounce data list and message/rfc822 part
        #                               or nil if it failed to parse or the
        #                               arguments are missing
        def scan; return nil; end

        # @abstract      Adapt bounce object for SisimaiLegacy::Message format
        # @param         [Hash] argvs   bounce object returned from each email cloud
        # @return        [Hash, Nil]    Bounce data list and message/rfc822 part
        #                               or nil if it failed to parse or the
        #                               arguments are missing
        def adapt; return nil; end

      end
    end
  end
end

