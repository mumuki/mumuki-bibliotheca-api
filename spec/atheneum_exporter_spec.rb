require 'spec_helper'

describe Bibliotheca::IO::AtheneumExporter do
  context 'when credentials are not set' do
    it { expect { Bibliotheca::IO::AtheneumExporter.run!({}) }.to_not raise_error }
  end
end
