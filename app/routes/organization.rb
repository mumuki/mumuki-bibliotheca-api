get '/organization' do
  Bibliotheca::Collection::Organizations.base.as_json
end
