require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'MFILTER'
isexpected = [
  { 'n' => '01', 's' => /\A5[.]0[.]\d+\z/, 'r' => /filtered/,    'b' => /\A1\z/ },
  { 'n' => '02', 's' => /\A5[.]1[.]1\z/,   'r' => /userunknown/, 'b' => /\A0\z/ },
  { 'n' => '03', 's' => /\A5[.]0[.]\d+\z/, 'r' => /filtered/,    'b' => /\A1\z/ },
]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected)

