require 'spec_helper'

describe Bibliotheca::IO::GuideReader do
  context 'when optional properties are specified' do
    let(:log) { Bibliotheca::IO::ImportLog.new }
    let(:repo) { Bibliotheca::Repo.new('mumuki', 'functional-haskell-guide-1') }
    let(:reader) { Bibliotheca::IO::GuideReader.new('spec/data/full-guide', repo, log) }
    let!(:guide) { reader.read_guide! }

    context 'when removing that properties and reimporting the guide' do
      let(:reader) { Bibliotheca::IO::GuideReader.new('spec/data/simple-guide', repo, log) }
      let!(:guide) { reader.read_guide! }

      it { expect(guide.original_id_format).to eq '%05d' }
      it { expect(guide.learning).to be false }
      it { expect(guide.beta).to be false }
    end
  end
end