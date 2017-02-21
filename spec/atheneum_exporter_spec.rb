require 'spec_helper'

describe Bibliotheca::IO::AtheneumExport do
  before { Bibliotheca::Collection::Languages.insert!(build(:haskell)) }

  context 'when credentials are not set' do
    it { expect { Bibliotheca::IO::GuideAtheneumExport.new(slug: 'foo/bar').run! }.to_not raise_error }
  end

  context 'when the request to Atheneum fails' do
    let(:guide) { build(:guide) }

    it { expect { Bibliotheca::IO::GuideAtheneumExport.new(slug: guide.slug).run!  }.to_not raise_error }
  end
end
