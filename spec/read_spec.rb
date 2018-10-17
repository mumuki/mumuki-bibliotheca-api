require 'spec_helper'

describe Bibliotheca::IO::GuideReader do
  context 'when optional properties are specified' do
    before { create(:haskell) }

    let(:log) { Bibliotheca::IO::Log.new }
    let(:repo) { Mumukit::Auth::Slug.new('mumuki', 'functional-haskell-guide-1') }
    let(:reader) { Bibliotheca::IO::GuideReader.new('spec/data/full-guide', repo, log) }
    let!(:guide) { reader.read_guide! }

    context 'when removing that properties and reimporting the guide' do
      let(:reader) { Bibliotheca::IO::GuideReader.new('spec/data/simple-guide', repo, log) }
      let!(:guide) { reader.read_guide! }

      it { expect(guide.id_format).to eq '%05d' }
      it { expect(guide.type).to eq 'practice' }
      it { expect(guide.beta).to be false }
      it { expect(guide.language.name).to eq 'haskell' }
      it { expect(guide.locale).to eq 'en' }
      it { expect(guide.teacher_info).to eq 'information' }
    end
  end
end
