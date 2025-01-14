require 'spec_helper'
require './spec/sisimai/lhost/code'
enginename = 'EZweb'
isexpected = [
  { 'n' => '01001', 'r' => /userunknown/ },
  { 'n' => '01002', 'r' => /filtered/ },
  { 'n' => '01003', 'r' => /userunknown/ },
  { 'n' => '01004', 'r' => /userunknown/ },
  { 'n' => '01005', 'r' => /suspend/ },
  { 'n' => '01006', 'r' => /filtered/ },
  { 'n' => '01007', 'r' => /suspend/ },
  { 'n' => '01008', 'r' => /filtered/ },
  { 'n' => '01009', 'r' => /filtered/ },
  { 'n' => '01010', 'r' => /filtered/ },
  { 'n' => '01011', 'r' => /filtered/ },
  { 'n' => '01012', 'r' => /filtered/ },
  { 'n' => '01013', 'r' => /expired/ },
  { 'n' => '01014', 'r' => /filtered/ },
  { 'n' => '01015', 'r' => /suspend/ },
  { 'n' => '01016', 'r' => /filtered/ },
  { 'n' => '01017', 'r' => /filtered/ },
  { 'n' => '01018', 'r' => /filtered/ },
  { 'n' => '01019', 'r' => /suspend/ },
  { 'n' => '01020', 'r' => /filtered/ },
  { 'n' => '01021', 'r' => /filtered/ },
  { 'n' => '01022', 'r' => /filtered/ },
  { 'n' => '01023', 'r' => /suspend/ },
  { 'n' => '01024', 'r' => /filtered/ },
  { 'n' => '01025', 'r' => /filtered/ },
  { 'n' => '01026', 'r' => /filtered/ },
  { 'n' => '01027', 'r' => /filtered/ },
  { 'n' => '01028', 'r' => /filtered/ },
  { 'n' => '01029', 'r' => /suspend/ },
  { 'n' => '01030', 'r' => /filtered/ },
  { 'n' => '01031', 'r' => /suspend/ },
  { 'n' => '01032', 'r' => /filtered/ },
  { 'n' => '01033', 'r' => /mailboxfull/ },
  { 'n' => '01034', 'r' => /filtered/ },
  { 'n' => '01035', 'r' => /suspend/ },
  { 'n' => '01036', 'r' => /mailboxfull/ },
  { 'n' => '01037', 'r' => /userunknown/ },
  { 'n' => '01038', 'r' => /suspend/ },
  { 'n' => '01039', 'r' => /suspend/ },
  { 'n' => '01040', 'r' => /suspend/ },
  { 'n' => '01041', 'r' => /suspend/ },
  { 'n' => '01042', 'r' => /suspend/ },
  { 'n' => '01043', 'r' => /suspend/ },
  { 'n' => '01044', 'r' => /userunknown/ },
  { 'n' => '01045', 'r' => /filtered/ },
  { 'n' => '01046', 'r' => /filtered/ },
  { 'n' => '01047', 'r' => /filtered/ },
  { 'n' => '01048', 'r' => /suspend/ },
  { 'n' => '01049', 'r' => /filtered/ },
  { 'n' => '01050', 'r' => /suspend/ },
  { 'n' => '01051', 'r' => /filtered/ },
  { 'n' => '01052', 'r' => /suspend/ },
  { 'n' => '01053', 'r' => /filtered/ },
  { 'n' => '01054', 'r' => /suspend/ },
  { 'n' => '01055', 'r' => /filtered/ },
  { 'n' => '01056', 'r' => /userunknown/ },
  { 'n' => '01057', 'r' => /filtered/ },
  { 'n' => '01058', 'r' => /suspend/ },
  { 'n' => '01059', 'r' => /suspend/ },
  { 'n' => '01060', 'r' => /filtered/ },
  { 'n' => '01061', 'r' => /suspend/ },
  { 'n' => '01062', 'r' => /filtered/ },
  { 'n' => '01063', 'r' => /userunknown/ },
  { 'n' => '01064', 'r' => /filtered/ },
  { 'n' => '01065', 'r' => /suspend/ },
  { 'n' => '01066', 'r' => /filtered/ },
  { 'n' => '01067', 'r' => /filtered/ },
  { 'n' => '01068', 'r' => /suspend/ },
  { 'n' => '01069', 'r' => /suspend/ },
  { 'n' => '01070', 'r' => /suspend/ },
  { 'n' => '01071', 'r' => /filtered/ },
  { 'n' => '01072', 'r' => /suspend/ },
  { 'n' => '01073', 'r' => /filtered/ },
  { 'n' => '01074', 'r' => /filtered/ },
  { 'n' => '01075', 'r' => /suspend/ },
  { 'n' => '01076', 'r' => /filtered/ },
  { 'n' => '01077', 'r' => /expired/ },
  { 'n' => '01078', 'r' => /filtered/ },
  { 'n' => '01079', 'r' => /filtered/ },
  { 'n' => '01080', 'r' => /filtered/ },
  { 'n' => '01081', 'r' => /filtered/ },
  { 'n' => '01082', 'r' => /filtered/ },
  { 'n' => '01083', 'r' => /filtered/ },
  { 'n' => '01084', 'r' => /filtered/ },
  { 'n' => '01085', 'r' => /expired/ },
  { 'n' => '01086', 'r' => /filtered/ },
  { 'n' => '01087', 'r' => /filtered/ },
  { 'n' => '01089', 'r' => /filtered/ },
  { 'n' => '01090', 'r' => /suspend/ },
  { 'n' => '01091', 'r' => /filtered/ },
  { 'n' => '01092', 'r' => /filtered/ },
  { 'n' => '01093', 'r' => /suspend/ },
  { 'n' => '01094', 'r' => /userunknown/ },
  { 'n' => '01095', 'r' => /filtered/ },
  { 'n' => '01096', 'r' => /filtered/ },
  { 'n' => '01097', 'r' => /filtered/ },
  { 'n' => '01098', 'r' => /suspend/ },
  { 'n' => '01099', 'r' => /filtered/ },
  { 'n' => '01100', 'r' => /filtered/ },
  { 'n' => '01101', 'r' => /filtered/ },
  { 'n' => '01102', 'r' => /suspend/ },
  { 'n' => '01103', 'r' => /userunknown/ },
  { 'n' => '01104', 'r' => /filtered/ },
  { 'n' => '01105', 'r' => /filtered/ },
  { 'n' => '01106', 'r' => /userunknown/ },
  { 'n' => '01107', 'r' => /filtered/ },
  { 'n' => '01108', 'r' => /norelaying/ },
  { 'n' => '01109', 'r' => /userunknown/ },
  { 'n' => '01110', 'r' => /filtered/ },
  { 'n' => '01111', 'r' => /suspend/ },
  { 'n' => '01112', 'r' => /suspend/ },
  { 'n' => '01113', 'r' => /suspend/ },
  { 'n' => '01114', 'r' => /filtered/ },
  { 'n' => '01115', 'r' => /suspend/ },
  { 'n' => '01116', 'r' => /filtered/ },
  { 'n' => '01118', 'r' => /suspend/ },
  { 'n' => '01119', 'r' => /filtered/ },
  { 'n' => '01120', 'r' => /userunknown/ },
  { 'n' => '01121', 'r' => /blocked/ },
]
Sisimai::Lhost::Code.maketest(enginename, isexpected, true)

