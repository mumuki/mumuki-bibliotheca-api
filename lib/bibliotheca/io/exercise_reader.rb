module Bibliotheca::IO
  class ExerciseReader
    include WithFileReading

    def initialize(dir)
      raise "directory #{dir} must exist" unless File.exist? dir
      @dir = dir
    end

    def markdown(root, filename)
      read_file "#{root}/#{filename}.md"
    end

    def test_code(root)
      read_code_file(root, 'test')
    end

    def extra(root)
      read_code_file(root, 'extra')
    end

    def default(root)
      read_code_file(root, 'default')
    end

    def yaml(root, filename)
      read_yaml_file "#{root}/#{filename}.yml"
    end

    def yaml_list(root, filename, key)
      yaml(root, filename).try { |it| it[key] }
    end

    def meta(root)
      yaml(root, 'meta')
    end

    def expectations(root)
      yaml_list(root, 'expectations', 'expectations')
    end

    def assistance_rules(root)
      yaml_list(root, 'assistance_rules', 'rules')
    end

    def randomizations(root)
      yaml(root, 'randomizations')
    end

    def free_form_editor_source(root)
      read_code_file(root, 'free_form_editor_source')
    end
  end
end
