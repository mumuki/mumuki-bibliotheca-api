require 'spec_helper'

require_relative '../../app/routes'

describe 'routes' do
  def app
    Sinatra::Application
  end

  describe('get /languages') do
    let(:haskell) { build(:haskell) }
    before { Bibliotheca::Collection::Languages.insert!(haskell) }

    before do
      get '/languages'
    end

    it { expect(last_response.body).to json_eq languages: [{name: 'haskell', test_extension: 'hs', extension: 'hs'}] }
  end
end
