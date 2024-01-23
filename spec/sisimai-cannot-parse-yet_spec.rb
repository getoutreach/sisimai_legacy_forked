require 'spec_helper'
require 'sisimai_legacy'
require 'sisimai_legacy/mail/maildir'
require 'sisimai_legacy/message'
require 'json'

cannotparse = './set-of-emails/to-be-debugged-because/sisimai-cannot-parse-yet'
if File.exist?(cannotparse)
  describe Sisimai do
    it 'returns nil' do
      expect(SisimaiLegacy.make(cannotparse)).to be nil
    end
  end

  describe SisimaiLegacy::Mail::Maildir do
    maildir = SisimaiLegacy::Mail::Maildir.new(cannotparse)

    describe 'SisimaiLegacy::Mail::Maildir' do
      it 'is SisimaiLegacy::Mail::Maildir' do
        expect(maildir).to be_a SisimaiLegacy::Mail::Maildir
      end

      describe 'each method' do
        example '#dir returns directory name' do
          expect(maildir.dir).to be == cannotparse
        end
        example '#file retuns nil' do
          expect(maildir.file).to be nil
        end
        example '#inodes is Hash' do
          expect(maildir.inodes).to be_a Hash
        end
        example '#handle is Dir' do
          expect(maildir.handle).to be_a Dir
        end

        describe '#read' do
          mailobj = SisimaiLegacy::Mail::Maildir.new(cannotparse)
          mailtxt = mailobj.read

          it 'returns message string' do
            expect(mailtxt).to be_a String
            expect(mailtxt.size).to be > 0
          end
        end
      end
    end
  end

  describe SisimaiLegacy::Message do
    seekhandle = Dir.open(cannotparse)
    mailastext = ''

    while r = seekhandle.read do
      next if r == '.' || r == '..'
      emailindir = sprintf('%s/%s', cannotparse, r)
      emailindir = emailindir.squeeze('/')

      next unless File.ftype(emailindir) == 'file'
      next unless File.size(emailindir) > 0
      next unless File.readable?(emailindir)

      filehandle = File.open(emailindir,'r')
      mailastext = filehandle.read
      filehandle.close

      it 'returns String' do
        expect(mailastext).to be_a String
        expect(mailastext.size).to be > 0
      end

      p = SisimaiLegacy::Message.new(data: mailastext)
      it 'returns SisimaiLegacy::Message' do
        expect(p).to be_a SisimaiLegacy::Message
        expect(p.ds).to be nil
        expect(p.from).to be nil
        expect(p.rfc822).to be nil
        expect(p.header).to be nil
      end
    end

  end
end
