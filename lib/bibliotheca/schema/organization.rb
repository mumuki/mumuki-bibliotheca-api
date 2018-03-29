module Bibliotheca::Schema::Organization
  extend Bibliotheca::Schema

  def self.fields_schema
    [
      {name: :name},
      {name: :book},
      {name: :settings},
      {name: :profile},
      {name: :theme}
    ]
  end
end
