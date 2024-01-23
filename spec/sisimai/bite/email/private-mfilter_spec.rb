require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'MFILTER'
isexpected = [
  { 'n' => '01001', 'r' => /filtered/ },
  { 'n' => '01002', 'r' => /userunknown/ },
  { 'n' => '01003', 'r' => /filtered/ },
  { 'n' => '01004', 'r' => /filtered/ },
  { 'n' => '01005', 'r' => /userunknown/ },
  { 'n' => '01006', 'r' => /filtered/ },
  { 'n' => '01007', 'r' => /filtered/ },
]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected, true)

