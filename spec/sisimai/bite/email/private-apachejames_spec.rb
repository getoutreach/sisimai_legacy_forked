require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'ApacheJames'
isexpected = [
  { 'n' => '01001', 'r' => /filtered/ },
  { 'n' => '01002', 'r' => /filtered/ },
  { 'n' => '01003', 'r' => /filtered/ },
  { 'n' => '01004', 'r' => /onhold/ },
  { 'n' => '01005', 'r' => /onhold/ },
]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected, true)

