require 'spec_helper'

describe Bibliotheca::IO::GuideReader do
  let(:repo) { Bibliotheca::Repo.new('mumuki', 'functional-haskell-guide-1') }
  it 'webhook url is properly generated' do
    expect(repo.web_hook_url).to eq('http://bibliotheca.mumuki.io/guides/import/mumuki/functional-haskell-guide-1')
  end
  it 'full name is properly generated' do
    expect(repo.full_name).to eq('mumuki/functional-haskell-guide-1')
  end
end
