module Bibliotheca
  module Schema
    def slice(json)
      json.slice(*fields.map(&:reverse_name))
    end

    def metadata_fields
      fields.select { |it| it.kind == :metadata }
    end

    def simple_fields
      fields.select { |it| [:special, :file].include? it.kind }
    end

    def file_fields
      fields.select { |it| it.kind == :file }
    end

    def fields
      @field ||= fields_schema.map { |it| new_field(it) }
    end

    class Field < OpenStruct
      def get_field_value(document)
        t = transform || proc { |it| it }
        t.call document[reverse_name]
      end

      def field_value_present?(document)
        document[reverse_name].present?
      end

      def reverse_name
        reverse || name
      end
    end
  end
end

require_relative './schema/exercise'
