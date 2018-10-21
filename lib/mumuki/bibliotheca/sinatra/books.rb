get '/books' do
  Book.all.as_json
end

get '/books/writable' do
  Book.allowed(current_user.permissions).as_json
end

get '/books/:organization/:repository' do
  Book.find_by_slug!(slug.to_s).as_json
end

post '/books' do
  upsert! Bibliotheca::Book, Book
end

post '/book/:organization/:repository/fork' do
  fork! Book
end

delete '/books/:organization/:repository' do
  delete! Book
end
