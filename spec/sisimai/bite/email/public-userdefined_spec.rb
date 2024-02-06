require 'spec_helper'
require './spec/sisimai/bite/email/code'
enginename = 'UserDefined'
isexpected = []
SisimaiLegacy::Bite::Email::Code.maketest(enginename, isexpected)

