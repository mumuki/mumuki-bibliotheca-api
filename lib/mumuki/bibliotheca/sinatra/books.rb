class Mumuki::Bibliotheca::App < Sinatra::Application
  helpers do
    def book
      Book.find_by_slug! slug.to_s
    end

    def list_books(books)
      { books: books.as_json(only: [:name, :slug, :chapters]) }
    end
  end

  get '/books' do
    list_books Book.visible(permissions)
  end

  get '/books/writable' do
    list_books Book.allowed(permissions)
  end

  get '/books/:organization/:repository' do
    validate_accessible! book
    book.to_resource_h
  end

  get '/books/:organization/:repository/organizations' do
    validate_accessible! book
    organizations_for book
  end

  post '/books' do
    insert_and_notify! :book
  end

  put'/books' do
    upsert_and_notify! :book
  end

  post '/books/:organization/:repository/fork' do
    fork! Book
  end

  delete '/books/:organization/:repository' do
    delete! Book
  end
end
