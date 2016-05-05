get '/books' do
  Bibliotheca::Collection::Books.all.as_json
end

get '/books/:organization/:repository' do
  Bibliotheca::Collection::Books.find_by_slug!(slug.to_s).as_json
end

post '/books' do
  upsert! Bibliotheca::Book, Bibliotheca::Collection::Books
end
