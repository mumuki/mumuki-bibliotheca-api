require 'spec_helper'

describe Bibliotheca::IO::AtheneumExporter do
  def setup_dummy_atheneum_credentials
    [:atheneum_url, :atheneum_client_id, :atheneum_client_secret].each { |msg| allow(Bibliotheca::Env).to receive(msg).and_return('foo') }
  end

  context 'when credentials are not set' do
    it { expect { Bibliotheca::IO::AtheneumExporter.run!(:guide, {}) }.to_not raise_error }
  end

  context 'guides url' do
    let(:exporter) { Bibliotheca::IO::AtheneumExporter.from_env :guide }

    before {  setup_dummy_atheneum_credentials }

    it { expect(exporter.item_url 'http://foo.com').to eq 'http://foo.com/api/guides' }
    it { expect(exporter.item_url 'http://foo.com/').to eq 'http://foo.com/api/guides' }
  end

  context 'when the request to Atheneum fails' do
    before { setup_dummy_atheneum_credentials }
    before { allow_any_instance_of(RestClient::Resource).to receive(:post).and_raise(RestClient::InternalServerError, 'Something went wrong') }

    let(:guide) { build(:guide) }

    it { expect { Bibliotheca::IO::AtheneumExporter.run! :guide, guide }.to_not raise_error }
  end
end
