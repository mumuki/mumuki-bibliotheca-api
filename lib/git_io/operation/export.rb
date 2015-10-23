module GitIo::Operation
  class Export < GitIo::Operation::Operation

    attr_accessor :guide, :bot

    def initialize(guide, bot)
      super(bot)
      @guide = guide
    end

    def repo
      @repo ||= GitIo::Repo.from_full_name(guide[:github_repository])
    end

    def run!
      Rails.logger.info "Exporting guide #{guide[:name]}"

      log = ExportLog.new
      log.with_error_logging do
        bot.ensure_exists! repo
        with_local_repo do |dir, local_repo|
          write_guide! dir
          local_repo.add(all: true)
          local_repo.commit("Mumuki Export on #{Time.now}")
          local_repo.push
        end
        {result: 'Exported', status: :passed} #TODO save sha
      end
    end

    def write_guide!(dir)
      guide.exercises.each do |e|
        write_exercise! dir, e
      end
      write_description! dir
      write_corollary! dir
      write_meta! dir
      write_extra! dir
    end

    def write_exercise!(dir, e)
      Rails.logger.info "Exporting exercise #{e.name} of guide #{guide.id}"

      e.generate_original_id!

      dirname = File.join dir, "#{guide.format_original_id(e)}_#{e.name}"

      FileUtils.mkdir_p dirname

      write_file!(dirname, "test.#{language.test_extension}", e.test)
      write_file!(dirname, 'description.md', e.description)
      write_file!(dirname, 'meta.yml', metadata_yaml(e))

      write_file!(dirname, 'hint.md', e.hint) if e.hint.present?
      write_file!(dirname, extra_filename, e[:extra_code]) if e[:extra_code].present?
      write_file!(dirname, 'expectations.yml', expectations_yaml(e)) if e.expectations.present?
      write_file!(dirname, 'corollary.md', e.corollary) if e.corollary.present?

    end

    def write_description!(dir)
      write_file! dir, 'description.md', guide.description
    end

    def write_corollary!(dir)
      write_file! dir, 'corollary.md', guide.corollary if guide.corollary.present?
    end

    def write_meta!(dir)
      write_file! dir, 'meta.yml', {
          'locale' => guide.locale,
          'learning' => guide.learning,
          'beta' => guide.beta,
          'language' => language.name,
          'original_id_format' => guide.original_id_format,
          'order' => guide.exercises.pluck(:original_id)
      }.to_yaml
    end

    def write_extra!(dir)
      write_file!(dir, extra_filename, guide.extra_code) if guide.extra_code.present?
    end

    private

    def metadata_yaml(e)
      {'tags' => e.tag_list.to_a, 'locale' => e.locale, 'layout' => e.layout, 'type' => e.class.name.underscore}.to_yaml
    end

    def expectations_yaml(e)
      {'expectations' => e.expectations}.to_yaml
    end

    def extra_filename
      "extra.#{language.extension}"
    end

    def write_file!(dirname, name, content)
      File.write(File.join(dirname, name), content)
    end
  end
end