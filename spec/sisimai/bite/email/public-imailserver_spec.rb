require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'IMailServer'
isexpected = [
  { 'n' => '01', 's' => /\A5[.]0[.]\d+\z/, 'r' => /userunknown/, 'b' => /\A0\z/ },
  { 'n' => '02', 's' => /\A5[.]0[.]\d+\z/, 'r' => /mailboxfull/, 'b' => /\A1\z/ },
  { 'n' => '03', 's' => /\A5[.]0[.]\d+\z/, 'r' => /userunknown/, 'b' => /\A0\z/ },
  { 'n' => '04', 's' => /\A5[.]0[.]\d+\z/, 'r' => /expired/,     'b' => /\A1\z/ },
]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected)

