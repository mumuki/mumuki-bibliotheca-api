require 'spec_helper'

describe Bibliotheca::Repo do
  let(:repo) { Bibliotheca::Repo.new('mumuki', 'functional-haskell-guide-1') }
  it 'webhook url is properly generated' do
    expect(repo.web_hook_url).to eq('http://bibliotheca.mumuki.io/guides/import/mumuki/functional-haskell-guide-1')
  end
  it 'full name is properly generated' do
    expect(repo.slug).to eq('mumuki/functional-haskell-guide-1')
  end

  it { expect { Bibliotheca::Repo.from_slug 'fo' }.to raise_error(Bibliotheca::InvalidSlugFormatError) }
  it { expect { Bibliotheca::Repo.from_slug 'fo/bar' }.to_not raise_error }
end
