require 'rails_helper'

RSpec.describe Oulipo::Validators::StatusValidator do
  let(:account)       { Fabricate(:account, username: 'mus') }

  before :each do
    Oulipo.set_invalid_glyphs!(Oulipo::FIFTH_GLYPH_REGEX)
  end
  
  after :each do
    Oulipo.set_invalid_glyphs!(/(?=a)b/)
  end
  
  
  describe 'invalid text' do
    subject  { Fabricate.build(:status, text: 'Treebeard is the eldest Ent!', account: account) }

    it 'checks for invalid glyphs' do
      expect(subject.valid?).to eq(false)
    end

    it 'adds an error message' do
      subject.valid?
      expect(subject.errors.messages[:text]).to eq([I18n.t('oulipo.invalid_symbol')])
    end
  end

  describe 'invalid spoiler text' do
    subject  { Fabricate.build(:status, text: 'No bad glyphs in this toot!', spoiler_text: "eeeeeeeeeeeeeeeeee!", account: account) }

    it 'checks for invalid glyphs' do
      expect(subject.valid?).to eq(false)
    end

    it 'adds an error message' do
      subject.valid?
      expect(subject.errors.messages[:spoiler_text]).to eq([I18n.t('oulipo.invalid_symbol')])
    end
  end

  describe 'statuses with URLs' do
    subject  { Fabricate.build(:status, text: 'https://example.com', account: account) }

    it 'ignores invalid glyphs in URLs' do
      expect(subject.valid?).to eq(true)
    end
  end

  describe 'statuses with mentions' do
    subject { Fabricate.build(:status, text: '@ecmendenhall@party.personal.pizza', account: account) }

    it 'ignores invalid glyphs in mentions' do
      expect(subject.valid?).to eq(true)
    end
  end

  describe 'statuses with emoji' do
    subject { Fabricate.build(:status, text: ':heart_eyes_cat:', account: account) }

    it 'ignores invalid glyphs in emoji' do
      expect(subject.valid?).to eq(true)
    end
  end
end
