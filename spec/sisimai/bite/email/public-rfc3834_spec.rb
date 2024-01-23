require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'RFC3834'
isexpected = [
  { 'n' => '01', 's' => /\A\z/, 'r' => /vacation/, 'b' => /\A-1\z/ },
  { 'n' => '02', 's' => /\A\z/, 'r' => /vacation/, 'b' => /\A-1\z/ },
]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected)

