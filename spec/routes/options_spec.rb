require 'spec_helper'

require_relative '../../app/routes'

describe 'routes' do
  def app
    Sinatra::Application
  end

  describe 'options /' do
    before do
      options '/'
    end
    it { expect(last_response.headers['Allow']).to include 'DELETE' }
  end
end
