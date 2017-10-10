get '/guides' do
  Bibliotheca::Collection::Guides.all.as_json
end

get '/guides/writable' do
  Bibliotheca::Collection::Guides.allowed(current_user.permissions).as_json
end

get '/guides/:id/raw' do
  Bibliotheca::Collection::Guides.find!(params['id']).raw
end

get '/guides/:id' do
  Bibliotheca::Collection::Guides.find!(params['id']).as_json
end

post '/guides/:guide_id/exercises/:exercise_id/test' do
  Bibliotheca::Collection::Languages.find_by!(name: json_body['language']).run_tests!(json_body['solution'])
end

delete '/guides/:id' do
  authorize! :editor
  Bibliotheca::Collection::Guides.delete!(params['id'])
  {}
end

get '/guides/:organization/:repository/raw' do
  Bibliotheca::Collection::Guides.find_by_slug!(slug.to_s).raw
end

get '/guides/:organization/:repository/markdown' do
  Bibliotheca::Collection::Guides.find_by_slug!(slug.to_s).markdownified.as_json
end

get '/guides/:organization/:repository' do
  Bibliotheca::Collection::Guides.find_by_slug!(slug.to_s).as_json
end

post '/guides' do
  upsert! Bibliotheca::Guide, Bibliotheca::Collection::Guides, Bibliotheca::IO::GuideExport
end

post '/guides/import/:organization/:repository' do
  Bibliotheca::IO::GuideImport.new(bot: bot, repo: slug).run!
  Mumukit::Nuntius.notify_content_change_event! Bibliotheca::Guide, slug
end

post '/guides/:organization/:repository/images' do
  bot.upload_image!(slug, json_body['filename'], Base64.decode64(json_body['content'])).as_json
end
