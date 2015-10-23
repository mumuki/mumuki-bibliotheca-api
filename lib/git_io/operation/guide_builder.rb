require 'ostruct'

module GitIo::Operation
  class GuideBuilder < OpenStruct
    attr_writer :exercises

    def exercises
      @exercises ||= []
    end

    def build
      GitIo::Guide.new(
          name: name,
          description: description,
          corollary: corollary,
          language: language,
          locale: locale,
          learning: learning,
          extra: extra,
          beta: beta,
          original_id_format: original_id_format,
          expectations: expectations || [],
          exercises: exercises.sort_by { |e| order.position_for(e[:original_id]) })
    end

    def add_exercise(exercise)
      self.exercises << exercise
    end

  end
end