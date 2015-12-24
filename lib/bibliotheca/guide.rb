module Bibliotheca
  class Guide < JsonWrapper
    def defaults
      {beta: false,
       type: 'practice',
       id_format: '%05d'}
    end

    def transforms(original)
      {exercises: original[:exercises].map { |e| Exercise.new e },
       language: Language.find_by_name(original[:language])}
    end

    def format_id(exercise)
      self.id_format % exercise.id
    end

    def find_exercise_by_id(id)
      exercises.select { |e| e.id == id }.first
    end

  end
end