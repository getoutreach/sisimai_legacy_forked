require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'Courier'
isexpected = [
  { 'n' => '01001', 'r' => /filtered/ },
  { 'n' => '01002', 'r' => /filtered/ },
  { 'n' => '01003', 'r' => /blocked/ },
  { 'n' => '01004', 'r' => /userunknown/ },
  { 'n' => '01005', 'r' => /userunknown/ },
  { 'n' => '01006', 'r' => /userunknown/ },
  { 'n' => '01007', 'r' => /userunknown/ },
  { 'n' => '01008', 'r' => /userunknown/ },
  { 'n' => '01009', 'r' => /filtered/ },
  { 'n' => '01010', 'r' => /blocked/ },
  { 'n' => '01011', 'r' => /hostunknown/ },
  { 'n' => '01012', 'r' => /hostunknown/ },
]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected, true)

