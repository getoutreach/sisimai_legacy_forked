require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'Bigfoot'
isexpected = [
  { 'n' => '01001', 'r' => /spamdetected/ },
  { 'n' => '01002', 'r' => /userunknown/ },
]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected, true)

