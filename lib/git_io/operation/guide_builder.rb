require 'ostruct'

module GitIo::Operation
  class GuideBuilder < OpenStruct
    attr_writer :exercises

    def exercises
      @exercises ||= []
    end

    def build
      {name: name,
       description: description,
       corollary: corollary,
       language: language,
       locale: locale,
       learning: learning,
       extra: extra,
       beta: beta,
       original_id_format: original_id_format,
       expectations: expectations || [],
       exercises: exercises}
    end

    def add_exercise(excercise)
      self.exercises << excercise
    end

  end
end