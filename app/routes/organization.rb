get '/organization' do
  Bibliotheca::Collection::Organizations.find_by!(name: 'base').as_json
end
