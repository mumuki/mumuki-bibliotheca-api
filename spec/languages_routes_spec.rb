require 'spec_helper'

require_relative '../app/routes'

describe 'routes' do
  after do
    Bibliotheca::Database.clean!
  end

  def app
    Sinatra::Application
  end

  describe('get /languages') do
    before do
      get '/languages'
    end

    it { expect(last_response).to be_ok }
    skip { expect(last_response.body).to json_eq({languages: [
        {name: 'haskell', extension: 'hs'},
        {name: 'java', extension: 'java'},
        {name: 'wollok', extension: 'wlk'},
        {name: 'c', extension: 'c'},
        {name: 'prolog', extension: 'pl'},
        {name: 'ruby', extension: 'rb'},
        {name: 'gobstones', extension: 'gbs'},
        {name: 'javascript', extension: 'js'}]}) }
  end
end
