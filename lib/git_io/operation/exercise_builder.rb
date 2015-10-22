module GitIo::Operation

  class ExerciseBuilder < OpenStruct
    def ordering=(ordering)
      ordering.with_position(original_id, self)
    end

    def type
      (meta['type'] || 'problem').camelize
    end

    def clazz
      @clazz ||= Kernel.const_get(type)
    end

    def tag_list
      meta['tags']
    end

    def locale
      meta['locale']
    end

    def layout
      meta['layout'] || Exercise.default_layout
    end

    def expectations_list
      if clazz == Playground
        nil
      else
        (expectations || []).map do |e|
          {binding: e['binding'], inspection: e['inspection']}
        end
      end
    end

    def build
      exercise = clazz.find_or_initialize_by(original_id: original_id, guide_id: guide.id)
      exercise.assign_attributes(
          name: name,
          description: description,
          position: position,
          hint: hint,
          corollary: corollary,
          test: test,
          extra_code: extra_code,
          language: language,
          author: author,
          expectations: expectations_list,
          tag_list: tag_list,
          locale: locale,
          layout: layout)
      exercise
    end
  end
end