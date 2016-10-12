module Bibliotheca
  class Exercise < Mumukit::Service::Document
    module Schema
      def self.slice(json)
        json.slice(*fields.map(&:reverse_name))
      end

      def self.metadata_fields
        fields.select { |it| it.kind == :metadata }
      end

      def self.simple_fields
        fields.select { |it| [:special, :file].include? it.kind }
      end

      def self.file_fields
        fields.select { |it| it.kind == :file }
      end

      def self.fields
        @field ||= fields_schema.map { |it| Field.new(it) }
      end

      def self.fields_schema
        [
          {name: :id, kind: :special},
          {name: :name, kind: :special},

          {name: :solution, kind: :transient},

          {name: :tags, kind: :metadata, reverse: :tag_list,
           transform: proc { |it| it.to_a }},
          {name: :layout, kind: :metadata},
          {name: :type, kind: :metadata},
          {name: :extra_visible, kind: :metadata},
          {name: :language, kind: :metadata},
          {name: :teacher_info, kind: :metadata},
          {name: :manual_evaluation, kind: :metadata},

          {name: :expectations, kind: :file, extension: 'yml',
           transform: proc { |it| {'expectations' => it.map(&:stringify_keys)}.to_yaml }},

          {name: :test, kind: :file, extension: :test},
          {name: :extra, kind: :file, extension: :code},
          {name: :default, kind: :file, extension: :code, reverse: :default_content},

          {name: :description, kind: :file, extension: 'md'},
          {name: :hint, kind: :file, extension: 'md'},
          {name: :corollary, kind: :file, extension: 'md'}
        ]
      end

      class Field < OpenStruct
        def get_field_value(exercise)
          t = transform || proc { |it| it }
          t.call exercise[reverse_name]
        end

        def get_file_name(guide)
          "#{name}.#{get_file_extension(guide)}"
        end

        def get_file_extension(guide)
          case extension
            when :code then
              guide.language.extension
            when :test then
              guide.language.test_extension
            else
              extension
          end
        end

        def field_value_present?(exercise)
          exercise[reverse_name].present?
        end

        def reverse_name
          reverse || name
        end
      end
    end
  end
end
