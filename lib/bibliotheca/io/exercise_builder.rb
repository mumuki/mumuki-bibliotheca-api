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
      Hash[Bibliotheca::Schema::Exercise.metadata_fields.map do |field|
        [field.reverse_name, meta[field.name.to_s]]
      end].merge(Hash[Bibliotheca::Schema::Exercise.simple_fields.map do |field|
        [field.reverse_name, self.send(field.name)]
      end]).compact
    end
  end
end
