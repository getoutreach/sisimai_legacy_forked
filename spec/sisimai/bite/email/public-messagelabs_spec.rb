require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'MessageLabs'
isexpected = [
    { 'n' => '01', 's' => /\A5[.]0[.]0\z/, 'r' => /securityerror/, 'b' => /\A1\z/ },
    { 'n' => '02', 's' => /\A5[.]0[.]0\z/, 'r' => /userunknown/, 'b' => /\A0\z/ },
    { 'n' => '03', 's' => /\A5[.]0[.]0\z/, 'r' => /userunknown/, 'b' => /\A0\z/ },
]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected)

