require 'spec_helper'

describe Bibliotheca::IO::AtheneumExporter do
  def setup_dummy_atheneum_credentials
    [:atheneum_url, :atheneum_client_id, :atheneum_client_secret].each { |msg| allow(Bibliotheca::Env).to receive(msg).and_return('foo') }
  end

  let(:exporter) { Bibliotheca::IO::AtheneumExporter }

  context 'when credentials are not set' do
    it { expect { exporter.run!({}) }.to_not raise_error }
  end

  context 'guides url' do
    it { expect(exporter.guides_url 'http://foo.com').to eq 'http://foo.com/api/guides' }
    it { expect(exporter.guides_url 'http://foo.com/').to eq 'http://foo.com/api/guides' }
  end

  context 'when the request to Atheneum fails' do
    before { setup_dummy_atheneum_credentials }
    before { allow_any_instance_of(RestClient::Resource).to receive(:post).and_raise(RestClient::InternalServerError, 'Something went wrong') }

    it { expect { exporter.run!({ name: 'bar', slug: 'foo/bar' }) }.to_not raise_error }
  end
end
