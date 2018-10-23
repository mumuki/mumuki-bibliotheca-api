module Mumuki::Bibliotheca
  class Guide < Bibliotheca::SchemaDocument
    def schema
      Bibliotheca::Schema::Guide
    end

    def transforms(original)
      {exercises: original[:exercises].map { |e| Exercise.new e.merge(guide: self) },
       language: original[:language].try { |it| Language.find_by!(name: it) }}
    end

    def validate_slug!(a_slug)
      raise "inconsistent slug, must be #{slug}" if slug.present? && slug != a_slug
    end

     def export!(author_email)
      exercises.each { |e| e.expectations = e.expectations.as_json if e.expectations }
      Bibliotheca::IO::GuideExport.new(slug: slug,
                                       document: self,
                                       author_email: author_email,
                                       bot: Bibliotheca::Bot.from_env).run!

    end
  end
end
