get '/languages' do
  Bibliotheca::Collection::Languages.all.as_json
end