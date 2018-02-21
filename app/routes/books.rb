get '/books' do
  Bibliotheca::Collection::Books.all.as_json
end

get '/books/writable' do
  Bibliotheca::Collection::Books.allowed(current_user.permissions).as_json
end


get '/books/:organization/:repository' do
  Bibliotheca::Collection::Books.find_by_slug!(slug.to_s).as_json
end

post '/books' do
  upsert! Bibliotheca::Book, Bibliotheca::Collection::Books
end

post '/book/:organization/:repository/fork' do
  authorize! :writer
  destination = Mumukit::Auth::Slug.new json_body['organization'], params[:repository]
  Bibliotheca::Collection::Books.find_by_slug!(slug.to_s).fork_to! destination, bot
end
