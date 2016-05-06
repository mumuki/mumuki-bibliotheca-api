get '/guides' do
  Bibliotheca::Collection::Guides.all.as_json
end

get '/guides/writable' do
  Bibliotheca::Collection::Guides.allowed(permissions).as_json
end

get '/guides/:id/raw' do
  Bibliotheca::Collection::Guides.find!(params['id']).raw
end

get '/guides/:id' do
  Bibliotheca::Collection::Guides.find!(params['id']).as_json
end

get '/guides/:guide_id/exercises/:exercise_id/test' do
  Bibliotheca::Collection::Guides.find!(params['guide_id']).run_tests(params['exercise_id'].to_i).as_json
end

delete '/guides/:id' do
  protect!
  Bibliotheca::Collection::Guides.delete!(params['id'])
  {}
end

get '/guides/:organization/:repository/raw' do
  Bibliotheca::Collection::Guides.find_by_slug!(slug.to_s).raw
end

get '/guides/:organization/:repository' do
  Bibliotheca::Collection::Guides.find_by_slug!(slug.to_s).as_json
end

post '/guides' do
  upsert! Bibliotheca::Guide, Bibliotheca::Collection::Guides, Bibliotheca::IO::GuideExport
end

post '/guides/import/:organization/:repository' do
  Bibliotheca::IO::GuideImport.new(bot, slug).run!
end