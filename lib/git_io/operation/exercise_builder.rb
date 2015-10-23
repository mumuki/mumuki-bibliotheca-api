require 'ostruct'

module GitIo::Operation
  class ExerciseBuilder < OpenStruct
    def ordering=(ordering)
      ordering.with_position(original_id, self)
    end

    def type
      (meta['type'] || 'problem')
    end

    def tag_list
      meta['tags']
    end

    def locale
      meta['locale']
    end

    def layout
      meta['layout'] || 'editor_right'
    end

    def expectations_list
      if type == :playground
        nil
      else
        (expectations || []).map do |e|
          {binding: e['binding'], inspection: e['inspection']}
        end
      end
    end

    def build
      {type: type,
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
       layout: layout,
       original_id: original_id}
    end
  end
end