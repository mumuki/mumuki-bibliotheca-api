require 'spec_helper'

describe Bibliotheca::IO::AtheneumExporter do
  let(:exporter) { Bibliotheca::IO::AtheneumExporter }

  context 'when credentials are not set' do
    it { expect { exporter.run!({}) }.to_not raise_error }
  end

  context 'guides url' do
    it { expect(exporter.guides_url 'http://foo.com').to eq 'http://foo.com/api/guides' }
    it { expect(exporter.guides_url 'http://foo.com/').to eq 'http://foo.com/api/guides' }
  end
end
