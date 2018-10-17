get '/organization' do
  Organization.base.as_json
end
