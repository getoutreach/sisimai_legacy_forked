require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'InterScanMSS'
isexpected = [
  { 'n' => '01', 's' => /\A5[.]1[.]1\z/, 'r' => /userunknown/, 'b' => /\A0\z/ },
]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected)

