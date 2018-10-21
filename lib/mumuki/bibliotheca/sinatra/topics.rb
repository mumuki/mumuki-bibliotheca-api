get '/topics' do
  Topic.all.as_json
end

get '/topics/writable' do
  Topic.allowed(current_user.permissions).as_json
end

get '/topics/:organization/:repository' do
  Topic.find_by_slug!(slug.to_s).as_json
end

post '/topics' do
  upsert! Bibliotheca::Topic, Topic
end

post '/book/:organization/:repository/fork' do
  fork! Topic
end

delete '/topics/:organization/:repository' do
  delete! Topic
end
