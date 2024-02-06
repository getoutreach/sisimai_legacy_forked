require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'Yahoo'
isexpected = [
  { 'n' => '01', 's' => /\A5[.]1[.]1\z/, 'r' => /userunknown/, 'b' => /\A0\z/ },
  { 'n' => '02', 's' => /\A5[.]2[.]2\z/, 'r' => /mailboxfull/, 'b' => /\A1\z/ },
  { 'n' => '03', 's' => /\A5[.]1[.]1\z/, 'r' => /userunknown/, 'b' => /\A0\z/ },
  { 'n' => '04', 's' => /\A5[.]2[.]2\z/, 'r' => /mailboxfull/, 'b' => /\A1\z/ },
  { 'n' => '05', 's' => /\A5[.]2[.]1\z/, 'r' => /userunknown/, 'b' => /\A0\z/ },
  { 'n' => '06', 's' => /\A5[.]0[.]\d+\z/, 'r' => /filtered/,  'b' => /\A1\z/ },
  { 'n' => '07', 's' => /\A5[.]0[.]\d+\z/, 'r' => /userunknown/, 'b' => /\A0\z/ },
  { 'n' => '08', 's' => /\A5[.]2[.]2\z/, 'r' => /mailboxfull/, 'b' => /\A1\z/ },
  { 'n' => '09', 's' => /\A5[.]0[.]\d+\z/, 'r' => /notaccept/, 'b' => /\A0\z/ },
  { 'n' => '10', 's' => /\A5[.]1[.]1\z/, 'r' => /userunknown/, 'b' => /\A0\z/ },
  { 'n' => '11', 's' => /\A5[.]1[.]8\z/, 'r' => /rejected/,    'b' => /\A1\z/ },
  { 'n' => '12', 's' => /\A5[.]1[.]8\z/, 'r' => /rejected/,    'b' => /\A1\z/ },
  { 'n' => '13', 's' => /\A5[.]0[.]\d+\z/, 'r' => /expired/,   'b' => /\A1\z/ },
  { 'n' => '14', 's' => /\A5[.]0[.]\d+\z/, 'r' => /blocked/,   'b' => /\A1\z/ },
]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected)

