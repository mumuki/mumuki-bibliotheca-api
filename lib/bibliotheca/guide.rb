module Bibliotheca
  class Guide < JsonWrapper
    def defaults
      {beta: false,
       type: 'practice',
       id_format: '%05d',
       expectations: []}
    end

    def transforms(original)
      {exercises: original[:exercises].map { |e| Exercise.new e },
       language: original[:language].try { |it| Language.find_by_name(it) } }
    end

    def format_id(exercise)
      self.id_format % exercise.id
    end

    def find_exercise_by_id(id)
      exercises.select { |e| e.id == id }.first
    end

    def errors
      [
        ("Unrecognized guide type #{type}" unless [nil, 'practice', 'learning'].include? type),
        ("Beta flag must be boolean" unless [nil, true, false].include? beta),
        ("Name must be present" unless name.present?),
        ("Language must be present" unless language.present?),
        ("Description must be present" unless description.present?)
      ].compact
    end

    def validate!
      e = errors + exercises.flat_map(&:errors).each_with_index.map {|it, i| "in exercise #{i+1}: #{it}"}
      raise InvalidGuideFormatError.new(e.join(', ')) unless e.empty?
    end

    def validate_slug!(a_slug)
      raise "inconsistent slug, must be #{slug}" if slug.present? && slug != a_slug
    end

    def exercise_language(exercise)
      exercise.language || self.language
    end

    def run_tests(exercise_id)
      exercise = find_exercise_by_id(exercise_id)
      raise Bibliotheca::Collection::ExerciseNotFoundError, "exercise #{exercise_id} not found" unless exercise
      runner = Mumukit::Bridge::Runner.new(exercise_language(exercise).test_runner_url)
      runner.run_tests!(test: exercise.test, extra: "#{self.extra}\n#{exercise.extra}",
                        content: exercise.solution, expectations: self.expectations + exercise.expectations)
    end
  end

  class InvalidGuideFormatError < StandardError
  end
end
