require 'ostruct'

module Bibliotheca::IO
  class GuideBuilder < OpenStruct
    attr_writer :exercises

    def initialize(slug)
      super()
      self.slug = slug
    end

    def exercises
      @exercises ||= []
    end

    def build
      Bibliotheca::Guide.new(build_json.compact)
    end

    def add_exercise(exercise)
      self.exercises << exercise
    end

    private

    def build_json
      {name: name,
       description: description,
       corollary: corollary,
       language: language.name,
       locale: locale,
       type: type,
       extra: extra,
       beta: beta,
       authors: authors,
       collaborators: collaborators,
       teacher_info: teacher_info,
       id_format: id_format,
       slug: slug,
       expectations: expectations || [],
       exercises: exercises.sort_by { |e| order.position_for(e[:id]) }}
    end

  end
end
