require 'spec_helper'

describe GitIo::Operation::GuideReader do
  context 'when optional properties are specified' do
    let(:log) { GitIo::Operation::ImportLog.new }
    let(:repo) { Repo.new('functional-haskell-guide-1', 'mumuki') }
    let(:reader) { GitIo::Operation::GuideReader.new('spec/data/full-guide', repo, log) }
    let!(:guide) { reader.read_guide! }

    context 'when removing that properties and reimporting the guide' do
      let(:reader) { GitIo::Operation::GuideReader.new('spec/data/simple-guide', repo, log) }
      let!(:guide) { reader.read_guide! }

      it { expect(guide.original_id_format).to eq '%05d' }
      it { expect(guide.learning).to be false }
      it { expect(guide.beta).to be false }
    end
  end
end