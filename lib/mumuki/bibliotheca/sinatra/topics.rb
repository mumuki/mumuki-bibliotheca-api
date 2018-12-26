class Mumuki::Bibliotheca::App < Sinatra::Application
  helpers do
    def list_topics(topics)
      { topics: topics.as_json(only: [:name, :slug]) }
    end
  end

  get '/topics' do
    list_topics Topic.all
  end

  get '/topics/writable' do
    list_topics Topic.allowed(current_user.permissions)
  end

  get '/topics/:organization/:repository' do
    Topic.find_by_slug!(slug.to_s).to_resource_h
  end

  post '/topics' do
    upsert_and_notify! :topic
  end

  post '/book/:organization/:repository/fork' do
    fork! Topic
  end

  delete '/topics/:organization/:repository' do
    delete! Topic
  end
end
