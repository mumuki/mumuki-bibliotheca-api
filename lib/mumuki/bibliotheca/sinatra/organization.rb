class Mumuki::Bibliotheca::App < Sinatra::Application
  get '/organization' do
    Organization.base.to_resource_h
  end
end
