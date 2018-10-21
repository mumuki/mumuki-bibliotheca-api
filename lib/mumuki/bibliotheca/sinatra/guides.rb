get '/guides' do
  Guide.visible(current_user&.permissions).as_json
end

get '/guides/writable' do
  Guide.allowed(current_user&.permissions).as_json
end

get '/guides/:organization/:repository/raw' do
  Guide.find_by_slug!(slug.to_s).raw
end

get '/guides/:organization/:repository/markdown' do
  Guide.find_by_slug!(slug.to_s).markdownified.as_json
end

get '/guides/:organization/:repository' do
  Guide.find_by_slug!(slug.to_s).as_json
end

post '/guides' do
  upsert! Guide, Guide, Bibliotheca::IO::GuideExport
end

post '/guides/import/:organization/:repository' do
  Mumukit::Sync::Syncer.new(Mumukit::Sync::Store::Github.new(bot)).import!
end

post '/guides/:organization/:repository/assets' do
  bot.upload_asset!(slug, json_body['filename'], Base64.decode64(json_body['content'])).as_json
end

post '/guides/:organization/:repository/fork' do
  fork! Guide
end

# <b>DEPRECATED:</b> Please use <tt>/assets</tt> instead of /images.
post '/guides/:organization/:repository/images' do
  bot.upload_asset!(slug, json_body['filename'], Base64.decode64(json_body['content'])).as_json
end
