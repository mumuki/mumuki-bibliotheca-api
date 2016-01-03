module Bibliotheca
  class Guide < JsonWrapper
    def defaults
      {beta: false,
       type: 'practice',
       id_format: '%05d'}
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
        ("Unrecognized guide type #{type}" unless ['practice', 'learning'].include? type),
        ("Beta flag must be boolean" unless [true, false].include? beta),
        ("Name must be present" unless name.present?),
        ("Language must be present" unless language.present?)
      ].compact
    end

    def validate!
      e = errors + exercises.flat_map(&:erros)
      raise InvalidGuideFormatError.new(e.join(', ')) unless e.empty?
    end

    def validate_slug!(a_slug)
      raise "inconsistent slug, must be #{slug}" if slug.present? && slug != a_slug
    end
  end

  class InvalidGuideFormatError < StandardError
  end
end