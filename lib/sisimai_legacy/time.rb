require 'date'

module SisimaiLegacy
  # SisimaiLegacy::Time is a child class of Date for SisimaiLegacy::Data.
  class Time < DateTime
    # Imported from p5-Sisimail/lib/Sisimai/Time.pm
    def to_json(*)
      return self.to_time.to_i
    end
  end
end
