module Bibliotheca
  class Guide < Bibliotheca::SchemaDocument
    def schema
      Bibliotheca::Schema::Guide
    end

    def transforms(original)
      {exercises: original[:exercises].map { |e| Exercise.new e.merge(guide: self) },
       language: original[:language].try { |it| Bibliotheca::Collection::Languages.find_by!(name: it) }}
    end

    def format_id(exercise)
      self.id_format % exercise.id
    end

    def find_exercise_by_id(id)
      exercises.select { |e| e.id == id }.first
    end

    def errors
      puts '**********************************************'
      puts "Encoding of description: #{description.encoding.name}"
      puts "Encoding: #{__ENCODING__.name}"
      puts "Ruby version: #{RUBY_VERSION}"
      puts '**********************************************'
      [
        ("Unrecognized guide type #{type}" unless [nil, 'practice', 'learning'].include? type),
        ("Beta flag must be boolean" unless [nil, true, false].include? beta),
        ("Name must be present" unless name.present?),
        ("Language must be present" unless language.present?),
        ("Description must be present" unless description.present?)
      ].compact + exercises.flat_map(&:errors).each_with_index.map { |it, i| "in exercise #{i+1}: #{it}" }
    end

    def validate_slug!(a_slug)
      raise "inconsistent slug, must be #{slug}" if slug.present? && slug != a_slug
    end

    def exercise_language(exercise)
      exercise.language || self.language
    end

    def markdownified
      self.dup.tap do |guide|
        guide.description = Mumukit::ContentType::Markdown.to_html(guide.description)
        guide.corollary = Mumukit::ContentType::Markdown.to_html(guide.corollary)
        guide.teacher_info = Mumukit::ContentType::Markdown.to_html(guide.teacher_info)
        guide.exercises.map! &:markdownified
      end
    end


    def run_tests(exercise_id)
      exercise = find_exercise_by_id(exercise_id)
      raise Bibliotheca::Collection::ExerciseNotFoundError, "exercise #{exercise_id} not found" unless exercise
      runner = Mumukit::Bridge::Runner.new(exercise_language(exercise).test_runner_url)
      runner.run_tests!(test: exercise.test, extra: "#{self.extra}\n#{exercise.extra}",
                        content: exercise.solution, expectations: self.expectations + exercise.expectations)
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
