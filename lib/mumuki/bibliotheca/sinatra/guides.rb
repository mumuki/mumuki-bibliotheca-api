helpers do
  def list_guides(guides)
    { guides: guides.map { |it| it.as_json(only: [:name, :slug, :type]).merge(language: it.language.name) } }
  end

  def slice_guide_resource_h_for_api(guide)
    guide.merge(language: guide.dig(:language, :name))
  end
end

get '/guides' do
  list_guides Guide.visible(current_user&.permissions)
end

get '/guides/writable' do
  list_guides Guide.allowed(current_user&.permissions)
end

delete '/guides/:organization/:repository' do
  delete! Guide
end

get '/guides/:organization/:repository/markdown' do
  slice_guide_resource_h_for_api Guide.find_by_slug!(slug.to_s).to_markdownified_resource_h
end

get '/guides/:organization/:repository' do
  slice_guide_resource_h_for_api Guide.find_by_slug!(slug.to_s).to_resource_h
end

post '/guides' do
  upsert! :guide
end

post '/guides/import/:organization/:repository' do
  history_syncer.locate_and_import! :guide, slug.to_s
end

post '/guides/:organization/:repository/assets' do
  # FIXME this is assuming a github bot
  # FIXME this route is not working and is not tested
  bot.upload_asset!(slug, json_body['filename'], Base64.decode64(json_body['content'])).as_json
end

post '/guides/:organization/:repository/fork' do
  fork! Guide
end
