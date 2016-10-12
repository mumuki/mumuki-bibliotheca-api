module Bibliotheca::Schema::Exercise
  extend Bibliotheca::Schema

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

  def self.new_field(it)
    Field.new(it)
  end

  class Field < Bibliotheca::Schema::Field
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
  end
end

