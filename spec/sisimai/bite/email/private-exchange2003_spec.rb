require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'Exchange2003'
isexpected = [
  { 'n' => '01001', 'r' => /userunknown/ },
  { 'n' => '01002', 'r' => /userunknown/ },
  { 'n' => '01003', 'r' => /userunknown/ },
  { 'n' => '01004', 'r' => /userunknown/ },
  { 'n' => '01005', 'r' => /userunknown/ },
  { 'n' => '01006', 'r' => /userunknown/ },
  { 'n' => '01007', 'r' => /userunknown/ },
  { 'n' => '01008', 'r' => /userunknown/ },
  { 'n' => '01009', 'r' => /userunknown/ },
  { 'n' => '01010', 'r' => /userunknown/ },
  { 'n' => '01011', 'r' => /userunknown/ },
  { 'n' => '01012', 'r' => /userunknown/ },
  { 'n' => '01013', 'r' => /userunknown/ },
  { 'n' => '01015', 'r' => /userunknown/ },
  { 'n' => '01016', 'r' => /userunknown/ },
  { 'n' => '01017', 'r' => /filtered/ },
  { 'n' => '01018', 'r' => /userunknown/ },
  { 'n' => '01019', 'r' => /userunknown/ },
  { 'n' => '01020', 'r' => /userunknown/ },
  { 'n' => '01021', 'r' => /userunknown/ },
  { 'n' => '01022', 'r' => /userunknown/ },
  { 'n' => '01023', 'r' => /filtered/ },
  { 'n' => '01024', 'r' => /userunknown/ },
  { 'n' => '01025', 'r' => /userunknown/ },
  { 'n' => '01026', 'r' => /userunknown/ },
  { 'n' => '01027', 'r' => /userunknown/ },
  { 'n' => '01028', 'r' => /userunknown/ },
  { 'n' => '01029', 'r' => /userunknown/ },
  { 'n' => '01030', 'r' => /userunknown/ },
  { 'n' => '01031', 'r' => /userunknown/ },
  { 'n' => '01032', 'r' => /userunknown/ },
  { 'n' => '01033', 'r' => /userunknown/ },
]
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected, true)

