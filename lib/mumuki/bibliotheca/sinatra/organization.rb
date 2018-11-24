get '/organization' do
  Organization.base.to_resource_h
end
