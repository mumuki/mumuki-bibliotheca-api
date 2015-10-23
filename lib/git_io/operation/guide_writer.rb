module GitIo::Operation
  class GuideWriter
    attr_accessor :dir, :log

    def initialize(dir, log)
      @dir = dir
      @log = log
    end

    def write_guide!(guide)
      guide.exercises.each do |e|
        write_exercise! guide, e
      end
      write_description!(guide)
      write_corollary!(guide)
      write_meta!(guide)
      write_extra!(guide)
    end


    def write_exercise!(guide, e)
      dirname = File.join dir, "#{guide.format_original_id(e)}_#{e[:name]}"

      FileUtils.mkdir_p dirname

      write_file!(dirname, "test.#{guide.language.test_extension}", e.test)
      write_file!(dirname, 'description.md', e.description)
      write_file!(dirname, 'meta.yml', metadata_yaml(e))

      write_file!(dirname, 'hint.md', e.hint) if e.hint.present?
      write_file!(dirname, extra_filename(guide), e.extra_code) if e.extra_code.present?
      write_file!(dirname, 'expectations.yml', expectations_yaml(e)) if e.expectations.present?
      write_file!(dirname, 'corollary.md', e.corollary) if e.corollary.present?

    end

    def write_description!(guide)
      write_file! dir, 'description.md', guide.description
    end

    def write_corollary!(guide)
      write_file! dir, 'corollary.md', guide.corollary if guide.corollary.present?
    end

    def write_meta!(guide)
      write_file! dir, 'meta.yml', {
          'locale' => guide.locale,
          'learning' => guide.learning,
          'beta' => guide.beta,
          'language' => guide.language.name,
          'original_id_format' => guide.original_id_format,
          'order' => guide.exercises.map { |e| e.original_id }
      }.to_yaml
    end

    def write_extra!(guide)
      write_file!(dir, extra_filename(guide), guide.extra_code) if guide.extra_code.present?
    end

    private

    def metadata_yaml(e)
      {'tags' => e.tag_list.to_a,  'layout' => e.layout, 'type' => e.type}.to_yaml
    end

    def expectations_yaml(e)
      {'expectations' => e.expectations.map(&:stringify_keys) }.to_yaml
    end

    def extra_filename(guide)
      "extra.#{guide.language.extension}"
    end

    def write_file!(dirname, name, content)
      File.write(File.join(dirname, name), content)
    end
  end
end