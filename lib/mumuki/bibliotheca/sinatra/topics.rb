class Mumuki::Bibliotheca::App < Sinatra::Application
  helpers do
    def topic
      Topic.find_by_slug!(slug.to_s)
    end

    def list_topics(topics)
      { topics: topics.as_json(only: [:name, :slug]) }
    end
  end

  get '/topics' do
    list_topics Topic.visible(permissions)
  end

  get '/topics/writable' do
    list_topics Topic.allowed(permissions)
  end

  get '/topics/:organization/:repository' do
    topic.to_resource_h
  end

  get '/topics/:organization/:repository/organizations' do
    organizations_for topic
  end

  post '/topics' do
    insert_and_notify! :topic
  end

  put '/topics' do
    upsert_and_notify! :topic
  end

  post '/topics/:organization/:repository/fork' do
    fork! Topic
  end

  delete '/topics/:organization/:repository' do
    delete! Topic
  end
end
