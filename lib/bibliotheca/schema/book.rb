module Bibliotheca::Schema::Book
  extend Bibliotheca::Schema

  def self.fields_schema
    [
      {name: :id},
      {name: :slug},

      {name: :name},
      {name: :locale},
      {name: :description},
      {name: :teacher_info},

      {name: :chapters},
      {name: :complements}
    ]
  end
end
