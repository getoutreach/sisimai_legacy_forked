require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'Facebook'
isexpected = [
  { 'n' => '03', 's' => /\A5[.]1[.]1\z/, 'r' => /filtered/,    'b' => /\A1\z/ },
  { 'n' => '04', 's' => /\A5[.]1[.]1\z/, 'r' => /userunknown/, 'b' => /\A0\z/ },
]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected)

