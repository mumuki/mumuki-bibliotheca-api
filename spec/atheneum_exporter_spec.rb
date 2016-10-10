require 'spec_helper'

describe Bibliotheca::IO::AtheneumExport do
  before { Bibliotheca::Collection::Languages.insert!(build(:haskell)) }

  def setup_dummy_atheneum_credentials
    allow(Mumukit::Service::Env).to receive(:atheneum_url).and_return('http://foo.com')
    [:atheneum_client_id, :atheneum_client_secret].each { |msg| allow(Mumukit::Service::Env).to receive(msg).and_return('foo') }
  end

  context 'when credentials are not set' do
    it { expect { Bibliotheca::IO::GuideAtheneumExport.new(slug: 'foo/bar').run! }.to_not raise_error }
  end

  context 'guides url' do
    let(:exporter) { Bibliotheca::IO::GuideAtheneumExport.new(slug: 'foo/bar') }

    before {  setup_dummy_atheneum_credentials }

    it { expect(exporter.item_url).to eq 'http://foo.com/api/guides' }
    it { expect(exporter.item_url).to eq 'http://foo.com/api/guides' }
  end

  context 'when the request to Atheneum fails' do
    before { setup_dummy_atheneum_credentials }
    before { allow_any_instance_of(RestClient::Resource).to receive(:post).and_raise(RestClient::InternalServerError, 'Something went wrong') }

    let(:guide) { build(:guide) }

    it { expect { Bibliotheca::IO::GuideAtheneumExport.new(slug: guide.slug).run!  }.to_not raise_error }
  end
end
