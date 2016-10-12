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
      Hash[Bibliotheca::Exercise::Schema.metadata_fields.map do |field|
        [field.reverse_name, meta[field.name.to_s]]
      end].merge(Hash[Bibliotheca::Exercise::Schema.file_fields.map do |field|
        [field.reverse_name, self.send(field.name)]
      end]).merge(name: name, id: id).compact
    end
  end
end
