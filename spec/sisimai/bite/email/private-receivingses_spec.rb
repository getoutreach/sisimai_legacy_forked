require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'ReceivingSES'
isexpected = []
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected, true)

