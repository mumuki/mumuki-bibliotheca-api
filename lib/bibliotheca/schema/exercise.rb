module Bibliotheca::Schema::Exercise
  extend Bibliotheca::Schema

  def self.fields_schema
    [
      {name: :id, kind: :special},
      {name: :name, kind: :special},

      {name: :solution, kind: :transient},

      {name: :tags, kind: :metadata, reverse: :tag_list,
       transform: proc { |it| it.to_a }, default: []},
      {name: :layout, kind: :metadata, default: 'input_right'},
      {name: :editor, kind: :metadata, default: 'code'},

      {name: :type, kind: :metadata, default: 'problem'},
      {name: :extra_visible, kind: :metadata, default: false},
      {name: :language, kind: :metadata},
      {name: :teacher_info, kind: :metadata},
      {name: :manual_evaluation, kind: :metadata, default: false},

      {name: :expectations, kind: :file, extension: 'yml',
       transform: proc { |it| {'expectations' => it.map(&:stringify_keys)}.to_yaml },
       default: []},

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
    def get_file_name(exercise)
      "#{name}.#{get_file_extension(exercise)}"
    end

    def get_file_extension(exercise)
      case extension
        when :code then
          exercise.effective_language.extension
        when :test then
          exercise.effective_language.test_extension
        else
          extension
      end
    end
  end
end

