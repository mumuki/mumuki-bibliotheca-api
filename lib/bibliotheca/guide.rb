module Bibliotheca
  class Guide < JsonWrapper
    def defaults
      {beta: false,
       learning: false,
       original_id_format: '%05d'}
    end

    def transforms(original)
      {exercises: original[:exercises].map { |e| Exercise.new e },
       language: Language.find_by_name(original[:language])}
    end

    def format_original_id(exercise)
      self.original_id_format % exercise.original_id
    end

    def find_exercise_by_original_id(original_id)
      exercises.select { |e| e.original_id == original_id }.first
    end

  end
end