get '/topics' do
  Bibliotheca::Collection::Topics.all.as_json
end

get '/topics/writable' do
  Bibliotheca::Collection::Topics.allowed(current_user.permissions).as_json
end

get '/topics/:organization/:repository' do
  Bibliotheca::Collection::Topics.find_by_slug!(slug.to_s).as_json
end

post '/topics' do
  upsert! Bibliotheca::Topic, Bibliotheca::Collection::Topics
end

post '/book/:organization/:repository/fork' do
  fork! Bibliotheca::Collection::Topics
end

delete '/topics/:organization/:repository' do
  authorize! :editor
  id = Bibliotheca::Collection::Topics.find_by_slug!(slug.to_s).id
  Bibliotheca::Collection::Topics.delete! id
  {}
end
