module Bibliotheca
  class Exercise < Mumukit::Service::Document
    module Schema
      def self.metadata_fields
        fields.select { |it| it[:kind] == :metadata }
      end

      def self.fields
        @field ||= fields_schema.map { |it| Field.new(it) }
      end

      def self.fields_schema
        [
          {name: :tags, kind: :metadata, reverse: :tag_list},
          {name: :layout, kind: :metadata},
          {name: :type, kind: :metadata},
          {name: :extra_visible, kind: :metadata},
          {name: :language, kind: :metadata},
          {name: :teacher_info, kind: :metadata},
          {name: :manual_evaluation, kind: :metadata}
        ]
      end

      class Field < OpenStruct
        def get_field_value(exercise)
          exercise[reverse_name]
        end

        def reverse_name
          reverse || name
        end
      end
    end
  end
end
