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

    def markdownified
      self.dup.tap do |guide|
        guide.description = Mumukit::ContentType::Markdown.to_html(guide.description)
        guide.corollary = Mumukit::ContentType::Markdown.to_html(guide.corollary)
        guide.teacher_info = Mumukit::ContentType::Markdown.to_html(guide.teacher_info)
        guide.exercises.map! &:markdownified
      end
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
