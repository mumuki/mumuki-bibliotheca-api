class BibliothecaApi < Sinatra::Application
  helpers do
    def list_books(books)
      { books: books.as_json(only: [:name, :slug, :chapters]) }
    end
  end

  get '/books' do
    list_books Book.all
  end

  get '/books/writable' do
    list_books Book.allowed(current_user.permissions)
  end

  get '/books/:organization/:repository' do
    Book.find_by_slug!(slug.to_s).to_resource_h
  end

  post '/books' do
    upsert! :book
  end

  post '/book/:organization/:repository/fork' do
    fork! Book
  end

  delete '/books/:organization/:repository' do
    delete! Book
  end
end
