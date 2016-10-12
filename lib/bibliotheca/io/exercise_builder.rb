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
      build_metadata.merge(build_simple_fields).compact
    end

    def build_simple_fields
      Bibliotheca::Schema::Exercise.simple_fields.map { |field| [field.reverse_name, self.send(field.name)] }.to_h
    end

    def build_metadata
      Bibliotheca::Schema::Exercise.metadata_fields.map { |field| [field.reverse_name, meta[field.name.to_s]] }.to_h
    end
  end
end
