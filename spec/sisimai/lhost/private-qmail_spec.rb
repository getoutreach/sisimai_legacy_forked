require 'spec_helper'
require './spec/sisimai/lhost/code'
enginename = 'Qmail'
isexpected = [
  { 'n' => '01001', 'r' => /filtered/ },
  { 'n' => '01002', 'r' => /undefined/ },
  { 'n' => '01003', 'r' => /hostunknown/ },
  { 'n' => '01004', 'r' => /userunknown/ },
  { 'n' => '01005', 'r' => /hostunknown/ },
  { 'n' => '01006', 'r' => /userunknown/ },
  { 'n' => '01007', 'r' => /hostunknown/ },
  { 'n' => '01008', 'r' => /userunknown/ },
  { 'n' => '01009', 'r' => /userunknown/ },
  { 'n' => '01010', 'r' => /hostunknown/ },
  { 'n' => '01011', 'r' => /hostunknown/ },
  { 'n' => '01012', 'r' => /userunknown/ },
  { 'n' => '01013', 'r' => /userunknown/ },
  { 'n' => '01014', 'r' => /rejected/ },
  { 'n' => '01015', 'r' => /rejected/ },
  { 'n' => '01016', 'r' => /hostunknown/ },
  { 'n' => '01017', 'r' => /userunknown/ },
  { 'n' => '01018', 'r' => /userunknown/ },
  { 'n' => '01019', 'r' => /mailboxfull/ },
  { 'n' => '01020', 'r' => /filtered/ },
  { 'n' => '01021', 'r' => /userunknown/ },
  { 'n' => '01022', 'r' => /userunknown/ },
  { 'n' => '01023', 'r' => /userunknown/ },
  { 'n' => '01024', 'r' => /userunknown/ },
  { 'n' => '01025', 'r' => /(?:userunknown|filtered)/ },
  { 'n' => '01026', 'r' => /mesgtoobig/ },
  { 'n' => '01027', 'r' => /mailboxfull/ },
  { 'n' => '01028', 'r' => /userunknown/ },
  { 'n' => '01029', 'r' => /filtered/ },
  { 'n' => '01030', 'r' => /userunknown/ },
  { 'n' => '01031', 'r' => /userunknown/ },
  { 'n' => '01032', 'r' => /networkerror/ },
  { 'n' => '01033', 'r' => /mailboxfull/ },
  { 'n' => '01034', 'r' => /mailboxfull/ },
  { 'n' => '01035', 'r' => /mailboxfull/ },
  { 'n' => '01036', 'r' => /userunknown/ },
  { 'n' => '01037', 'r' => /hostunknown/ },
  { 'n' => '01038', 'r' => /filtered/ },
  { 'n' => '01039', 'r' => /mailboxfull/ },
  { 'n' => '01040', 'r' => /mailboxfull/ },
  { 'n' => '01041', 'r' => /userunknown/ },
  { 'n' => '01042', 'r' => /(?:userunknown|filtered)/ },
  { 'n' => '01043', 'r' => /rejected/ },
  { 'n' => '01044', 'r' => /blocked/ },
  { 'n' => '01045', 'r' => /systemerror/ },
  { 'n' => '01046', 'r' => /mailboxfull/ },
  { 'n' => '01047', 'r' => /userunknown/ },
  { 'n' => '01048', 'r' => /mailboxfull/ },
  { 'n' => '01049', 'r' => /mailboxfull/ },
  { 'n' => '01050', 'r' => /userunknown/ },
  { 'n' => '01051', 'r' => /undefined/ },
  { 'n' => '01052', 'r' => /suspend/ },
  { 'n' => '01053', 'r' => /filtered/ },
  { 'n' => '01054', 'r' => /userunknown/ },
  { 'n' => '01055', 'r' => /mailboxfull/ },
  { 'n' => '01056', 'r' => /userunknown/ },
  { 'n' => '01057', 'r' => /userunknown/ },
  { 'n' => '01058', 'r' => /userunknown/ },
  { 'n' => '01059', 'r' => /filtered/ },
  { 'n' => '01060', 'r' => /suspend/ },
  { 'n' => '01061', 'r' => /filtered/ },
  { 'n' => '01062', 'r' => /filtered/ },
  { 'n' => '01063', 'r' => /userunknown/ },
  { 'n' => '01064', 'r' => /userunknown/ },
  { 'n' => '01065', 'r' => /mailboxfull/ },
  { 'n' => '01066', 'r' => /userunknown/ },
  { 'n' => '01067', 'r' => /userunknown/ },
  { 'n' => '01068', 'r' => /userunknown/ },
  { 'n' => '01069', 'r' => /filtered/ },
  { 'n' => '01070', 'r' => /hostunknown/ },
  { 'n' => '01071', 'r' => /norelaying/ },
  { 'n' => '01072', 'r' => /hostunknown/ },
  { 'n' => '01073', 'r' => /suspend/ },
]
Sisimai::Lhost::Code.maketest(enginename, isexpected, true)
