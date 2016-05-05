get '/topics' do
  Bibliotheca::Collection::Topics.all.as_json
end

get '/topics/:organization/:repository' do
  Bibliotheca::Collection::Topics.find_by_slug!(slug.to_s).as_json
end

post '/topics' do
  upsert! Bibliotheca::Guide, Bibliotheca::Collection::Topics
end
