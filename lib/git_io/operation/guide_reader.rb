module GitIo::Operation
  class GuideReader

    attr_reader :exercise_reader, :dir

    def initialize(dir)
      @dir = File.expand_path(dir)
      @exercise_reader = ExerciseReader.new(@dir)
    end

    def read_guide!
      order = read_meta! dir
      read_description! dir
      read_corollary! dir
      read_extra! dir
      read_exercises! dir, order
    end

    def read_description!(dir)
      description = read_file(File.join(dir, 'description.md'))
      raise 'Missing description file' unless description
      guide.update!(description: description)
    end

    def read_corollary!(dir)
      guide.update!(corollary: read_file(File.join(dir, 'corollary.md')))
    end

    def read_extra!(dir)
      guide.update!(extra_code: read_code_file(dir, 'extra'))
    end

    def read_meta!(dir)
      meta = read_yaml_file(File.join(dir, 'meta.yml'))

      guide.language = Language.find_by_ignore_case! :name, meta['language']
      guide.locale = meta['locale']
      read_optional! meta, 'original_id_format', '%05d'
      read_optional! meta, 'learning', false
      read_optional! meta, 'beta', false
      guide.save!

      meta['order']
    end

    def read_optional!(meta, key, default)
      guide[key] = meta[key] || default
    end

    def read_exercises!(dir, order = nil)
      ordering = Ordering.from order
      log = ImportLog.new
      GuideReader.new(author, language, dir).read_exercises(log) do |exercise_builder|
        exercise_builder.ordering = ordering
        exercise_builder.guide = guide
        exercise = exercise_builder.build
        exercise.save
        log.saved exercise
      end
      log
    end


    def read_exercises(log)
      each_exercise_file do |root, position, original_id, name|
        builder = ExerciseBuilder.new
        builder.meta = exercise_reader.meta(root) || (log.no_meta(name); next)
        builder.original_id = original_id
        builder.name = name
        builder.description = exercise_reader.markdown(root, 'description') || (log.no_description name; next)
        builder.position = position
        builder.hint = exercise_reader.markdown(root, 'hint')
        builder.corollary = exercise_reader.markdown(root, 'corollary')
        builder.test = exercise_reader.test_code(root)
        builder.extra_code = exercise_reader.extra_code(root)
        builder.language = @language
        builder.author = @author
        builder.expectations = exercise_reader.expectations(root).try { |it| it['expectations'] }
        yield builder
      end
    end

    private

    def each_exercise_file
      Dir.glob("#{@dir}/**").sort.each_with_index do |file, index|
        basename = File.basename(file)
        match = /(\d*)_(.+)/.match basename
        next unless match
        yield file, index + 1, match[1].to_i, match[2]
      end
    end
  end
end