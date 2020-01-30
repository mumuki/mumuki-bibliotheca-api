class Mumuki::Bibliotheca::App < Sinatra::Application
  helpers do
    def guide
      Guide.find_by_slug!(slug.to_s)
    end

    def list_guides(guides)
      { guides: guides.map { |it| it.as_json(only: [:name, :slug, :type]).merge(language: it.language.name) } }
    end

    def slice_guide_resource_h_for_api(guide)
      guide.merge(language: guide.dig(:language, :name)).merge(exercises: guide[:exercises].map { |it| it.tap { |it| it[:language] = it.dig(:language, :name) if it[:language]}})
    end
  end

  get '/guides' do
    list_guides Guide.visible(permissions)
  end

  get '/guides/writable' do
    list_guides Guide.allowed(permissions)
  end

  delete '/guides/:organization/:repository' do
    delete! Guide
  end

  get '/guides/:organization/:repository/markdown' do
    slice_guide_resource_h_for_api guide.to_markdownified_resource_h
  end

  get '/guides/:organization/:repository' do
    slice_guide_resource_h_for_api guide.to_resource_h
  end

  get '/guides/:organization/:repository/organizations' do
    organizations_for guide
  end

  post '/guides' do
    insert_and_notify! :guide
  end

  put '/guides' do
    upsert_and_notify! :guide
  end

  post '/guides/import/:organization/:repository' do
    history_syncer.locate_and_import! :guide, slug.to_s
  end

  post '/guides/:organization/:repository/assets' do
    Mumuki::Bibliotheca.upload_asset! slug, json_body['filename'], json_body['content']
  end

  post '/guides/:organization/:repository/fork' do
    fork! Guide
  end
end
