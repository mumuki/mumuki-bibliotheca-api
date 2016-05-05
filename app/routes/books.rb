get '/books' do
  Bibliotheca::Collection::Books.all.as_json
end

post '/books' do
  upsert! Bibliotheca::Book, Bibliotheca::Collection::Books
end
