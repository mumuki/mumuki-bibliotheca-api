module Bibliotheca::Schema::Organization
  extend Bibliotheca::Schema

  def self.fields_schema
    [
      {name: :name},
      {name: :description},
      {name: :logo_url},
      {name: :public},
      {name: :contact_email},
      {name: :theme_stylesheet_url},
      {name: :extension_javascript_url},
      {name: :books},
      {name: :locale},
      {name: :terms_of_service},
      {name: :login_methods},
    ]
  end
end
