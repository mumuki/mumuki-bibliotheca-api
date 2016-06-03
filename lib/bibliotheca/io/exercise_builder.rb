require 'ostruct'

module Bibliotheca::IO
  class ExerciseBuilder < OpenStruct
    def locale
      meta['locale']
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
      {type: meta['type'],
       name: name,
       description: description,
       hint: hint,
       corollary: corollary,
       test: test,
       extra: extra,
       expectations: expectations_list,
       tag_list: meta['tags'],
       extra_visible: meta['extra_visible'],
       default_content: default_content,
       layout: meta['layout'],
       language: meta['language'],
       id: id}.compact
    end
  end
end
