require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'Exchange2007'
isexpected = [
  { 'n' => '01001', 'r' => /userunknown/ },
  { 'n' => '01002', 'r' => /mesgtoobig/ },
  { 'n' => '01003', 'r' => /undefined/ },
  { 'n' => '01004', 'r' => /userunknown/ },
  { 'n' => '01005', 'r' => /mailboxfull/ },
  { 'n' => '01006', 'r' => /mesgtoobig/ },
  { 'n' => '01007', 'r' => /mailboxfull/ },

]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected, true)

