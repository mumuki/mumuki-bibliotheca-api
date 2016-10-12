module Bibliotheca::Schema::Exercise
  extend Bibliotheca::Schema

  ## Schema definition explanation
  #
  #  * name: the name of the field
  #  * kind: the type of the field: metadata, special, file or transient.
  #     * metadata fields are those that are small and fit into the metadata.yml when exported to git
  #     * special fields are those are essentials and not part of any file, like the id or name when exported to git
  #     * transient fields are not exported to git
  #     * file fields are large fields that are exported to git within their own file.
  #  * reverse: the name of the field in the model. By default, it is assumed to be the same of name, but
  #    can be overridden with this option
  #  * default: the default value of the field
  #  * extension: the file extension. It only applies to file kinds. It can be a plain extension or one of the following
  #    special extensions:
  #      * test: the extension of the test framework
  #      * code: the normal extension for the language
  #
  def self.fields_schema
    [
      {name: :id, kind: :special},
      {name: :name, kind: :special},

      {name: :solution, kind: :transient},

      {name: :tags, kind: :metadata, reverse: :tag_list,
       transform: proc { |it| it.to_a }, default: []},
      {name: :layout, kind: :metadata, default: 'editor_right'},
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

