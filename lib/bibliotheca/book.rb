module Bibliotheca
  class Book < Bibliotheca::SchemaDocument
    def schema
      Bibliotheca::Schema::Book
    end

    def errors
      [
        ("Name must be present" unless name.present?),
        ("Locale must be present" unless locale.present?),
        ("Description must be present" unless description.present?)
      ].compact
    end
  end
end
