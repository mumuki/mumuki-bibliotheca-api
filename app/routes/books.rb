get '/books' do
  Bibliotheca::Collection::Books.all.as_json
end

post '/books' do
  upsert! Bibliotheca::Book, Bibliotheca::Collection::Books, Bibliotheca::IO::BookExport
end

post '/books/import/:organization/:repository' do
  Bibliotheca::IO::BookImport.new(bot, slug).run!
end
