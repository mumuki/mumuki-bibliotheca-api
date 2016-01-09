require 'ostruct'

module Bibliotheca::IO
  class ExerciseBuilder < OpenStruct
    def type
      meta['type']
    end

    def tag_list
      meta['tags']
    end

    def locale
      meta['locale']
    end

    def layout
      meta['layout']
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
       hint: hint,
       corollary: corollary,
       test: test,
       extra: extra,
       expectations: expectations_list,
       tag_list: tag_list,
       default_content: default_content,
       layout: layout,
       id: id}.compact
    end
  end
end