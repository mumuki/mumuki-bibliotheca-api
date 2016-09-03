module Bibliotheca::IO
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
      write_authors!(guide)
      write_licenses!(guide)
      write_collaborators!(guide)
    end


    def write_exercise!(guide, e)
      dirname = File.join dir, "#{guide.format_id(e)}_#{e.name}"

      FileUtils.mkdir_p dirname

      write_file!(dirname, "test.#{guide.language.test_extension}", e.test)
      write_file!(dirname, 'description.md', e.description)
      write_file!(dirname, 'meta.yml', metadata_yaml(e))

      write_file!(dirname, 'hint.md', e.hint) if e.hint.present?
      write_file!(dirname, extra_filename(guide), e.extra) if e.extra.present?
      write_file!(dirname, default_filename(guide), e.default_content) if e.default_content.present?
      write_file!(dirname, 'expectations.yml', expectations_yaml(e)) if e.expectations.present?
      write_file!(dirname, 'corollary.md', e.corollary) if e.corollary.present?

    end

    def write_authors!(guide)
      write_file! dir, 'AUTHORS.txt', joined_authors(guide)
    end

    def write_collaborators!(guide)
      write_file! dir, 'COLLABORATORS.txt', guide.collaborators
    end

    def write_description!(guide)
      write_file! dir, 'description.md', guide.description
    end

    def write_corollary!(guide)
      write_file! dir, 'corollary.md', guide.corollary if guide.corollary.present?
    end

    def write_meta!(guide)
      write_file! dir, 'meta.yml', {
        'name' => guide.name,
        'locale' => guide.locale,
        'type' => guide.type,
        'beta' => guide.beta,
        'teacher_info' => guide.teacher_info,
        'language' => guide.language.name,
        'id_format' => guide.id_format,
        'order' => guide.exercises.map { |e| e.id }
      }.to_yaml
    end

    def write_extra!(guide)
      write_file!(dir, extra_filename(guide), guide.extra) if guide.extra.present?
    end

    def write_licenses!(guide)
      write_file! dir, 'COPYRIGHT.txt', copyright_content(guide)
      write_file! dir, 'README.md', readme_content(guide)
      copy_file! 'LICENSE.txt'
    end

    private

    def metadata_yaml(e)
      {'tags' => e.tag_list.to_a,
       'layout' => e.layout,
       'type' => e.type,
       'extra_visible' => e.extra_visible,
       'language' => e.language,
       'teacher_info' => e.teacher_info,
       'manual_evaluation' => e.manual_evaluation}.to_yaml
    end

    def expectations_yaml(e)
      {'expectations' => e.expectations.map(&:stringify_keys)}.to_yaml
    end

    def extra_filename(guide)
      "extra.#{guide.language.extension}"
    end

    def default_filename(guide)
      "default.#{guide.language.extension}"
    end

    def write_file!(dirname, name, content)
      File.write(File.join(dirname, name), content)
    end

    def copyright_content(guide)
      @guide_authors = joined_authors(guide)
      @guide_repo_url = "https://github.com/#{guide.slug}"
      ERB.new(read_file 'COPYRIGHT.txt.erb').result binding
    end

    def joined_authors(guide)
      guide.authors.try(:join, ', ')
    end

    def readme_content(guide)
      @copyright = copyright_content guide
      ERB.new(read_file 'README.md.erb').result binding
    end

    def copy_file!(name)
      FileUtils.cp licenses_dir(name), dir
    end

    def read_file(name)
      File.read licenses_dir(name)
    end

    def licenses_dir(name)
      File.join __dir__, 'licenses', name
    end
  end
end
