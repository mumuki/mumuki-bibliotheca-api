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

    def default_content(root)
      read_code_file(root, 'default')
    end

    def yaml(root, filename)
      read_yaml_file "#{root}/#{filename}.yml"
    end

    def meta(root)
      yaml(root, 'meta')
    end

    def expectations(root)
      yaml(root, 'expectations')
    end
  end
end
