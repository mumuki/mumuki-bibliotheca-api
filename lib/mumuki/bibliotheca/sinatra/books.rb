class Mumuki::Bibliotheca::App < Sinatra::Application
  helpers do
    def book
      Book.find_by_slug! slug.to_s
    end

    def list_books(books)
      { books: books.as_json(only: [:name, :slug, :chapters]) }
    end

    def permissions
      current_user.permissions
    end
  end

  get '/books' do
    list_books Book.all
  end

  get '/books/writable' do
    list_books Book.allowed(permissions)
  end

  get '/books/:organization/:repository' do
    book.to_resource_h
  end

  get '/books/:organization/:repository/organizations' do
    Organization
      .where(book_id: book.id)
      .map { |it| it.as_json(only: [:name]) }
      .select { |it|
        slug = "#{it['name']}/_"
        permissions.student?(slug) || permissions.writer?(slug)
      }
  end

  post '/books' do
    upsert_and_notify! :book
  end

  post '/book/:organization/:repository/fork' do
    fork! Book
  end

  delete '/books/:organization/:repository' do
    delete! Book
  end
end
