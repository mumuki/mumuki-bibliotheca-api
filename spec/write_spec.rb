require 'spec_helper'

describe Bibliotheca::IO::GuideWriter do
  let(:bot) { Bibliotheca::Bot.new('mumukibot', 'zaraza') }
  let(:haskell) { build(:haskell) }
  let(:log) { Bibliotheca::IO::Log.new }

  let!(:exercise_1) { guide.exercises.first }
  let(:exercise_2) { guide.exercises.second }

  let(:guide) { Bibliotheca::Guide.new(
      name: 'Guide Name',
      description: 'Baz',
      slug: 'flbulgarelli/never-existent-repo',
      language: 'haskell',
      teacher_info: 'an info',
      locale: 'en',
      id_format: '%05d',
      extra: 'Foo',
      authors: ['Foo Bar', 'Jhon Doe'],
      collaborators: 'Jhon Doe',
      exercises: [

          {name: 'foo',
           id: 100,
           position: 1,
           locale: 'en',
           tag_list: %w(foo bar),
           extra: 'foobar',
           expectations: [{binding: 'bar', inspection: 'HasBinding'}]},

          {description: 'a description',
           name: 'bar',
           tag_list: %w(baz bar),
           id: 200,
           position: 2,
           type: 'problem',
           layout: 'editor_right',
           test: 'foo bar'}]) }

  let(:writer) { Bibliotheca::IO::GuideWriter.new(dir, log) }

  describe 'write methods' do
    let(:dir) { 'spec/data/export' }

    before { Dir.mkdir(dir) }
    after { FileUtils.rm_rf(dir) }

    describe '#write_meta' do
      before { writer.write_meta! guide }

      it { expect(File.exist? 'spec/data/export/meta.yml').to be true }
      it { expect(File.read 'spec/data/export/meta.yml').to eq "---\nname: Guide Name\nlocale: en\ntype: practice\nbeta: false\nteacher_info: an info\nlanguage: haskell\nid_format: '%05d'\norder:\n- 100\n- 200\n" }
    end

    describe '#write_description' do
      before { writer.write_description! guide }
      it { expect(File.exist? 'spec/data/export/description.md').to be true }
      it { expect(File.read 'spec/data/export/description.md').to eq 'Baz' }
    end

    describe '#write_authors' do
      before { writer.write_authors! guide }
      it { expect(File.exist? 'spec/data/export/AUTHORS.txt').to be true }
      it { expect(File.read 'spec/data/export/AUTHORS.txt').to eq 'Foo Bar, Jhon Doe' }
    end

    describe '#write_collaborators' do
      before { writer.write_collaborators! guide }
      it { expect(File.exist? 'spec/data/export/COLLABORATORS.txt').to be true }
      it { expect(File.read 'spec/data/export/COLLABORATORS.txt').to eq 'Jhon Doe' }
    end

    describe '#write_extra' do
      before { writer.write_extra! guide }
      it { expect(File.exist? 'spec/data/export/extra.hs').to be true }
      it { expect(File.read 'spec/data/export/extra.hs').to eq 'Foo' }
    end

    describe '#write_exercise' do
      context 'with extra' do
        before { writer.write_exercise! guide, exercise_1 }

        it { expect(File.exist? 'spec/data/export/00100_foo/extra.hs').to be true }
        it { expect(File.read 'spec/data/export/00100_foo/extra.hs').to eq 'foobar' }
      end

      context 'without extra' do
        before { writer.write_exercise! guide, exercise_2 }

        it { expect(File.exist? 'spec/data/export/00200_bar/extra.hs').to be false }
      end

      context 'with expectations' do
        before { writer.write_exercise! guide, exercise_1 }

        it { expect(File.exist? 'spec/data/export/00100_foo/expectations.yml').to be true }
        it { expect(File.read 'spec/data/export/00100_foo/expectations.yml').to eq "---\nexpectations:\n- binding: bar\n  inspection: HasBinding\n" }
      end

      context 'without expectations' do
        before { writer.write_exercise! guide, exercise_2 }

        it { expect(Dir.exist? 'spec/data/export/00200_bar/').to be true }

        it { expect(File.exist? 'spec/data/export/00200_bar/description.md').to be true }
        it { expect(File.read 'spec/data/export/00200_bar/description.md').to eq 'a description' }

        it { expect(File.exist? 'spec/data/export/00200_bar/meta.yml').to be true }
        it { expect(File.read 'spec/data/export/00200_bar/meta.yml').to eq "---\ntags:\n- baz\n- bar\nlayout: editor_right\ntype: problem\nextra_visible: false\nlanguage: \nteacher_info: \nmanual_evaluation: false\n" }


        it { expect(File.exist? 'spec/data/export/00200_bar/test.hs').to be true }
        it { expect(File.read 'spec/data/export/00200_bar/test.hs').to eq 'foo bar' }

        it { expect(File.exist? 'spec/data/export/00200_bar/expectations.yml').to be false }
      end

    end

    describe '#write_licenses' do
      before { writer.write_licenses! guide }
      context 'with copyright' do
        it { expect(File.exist? 'spec/data/export/COPYRIGHT.txt').to be true }
        it { expect(File.read 'spec/data/export/COPYRIGHT.txt').to eq "Copyright Foo Bar, Jhon Doe and contributors\n\nThis content consists of voluntary contributions made by many\nindividuals. For exact contribution history, see its revision history\navailable at https://github.com/flbulgarelli/never-existent-repo and the AUTHORS.txt file.\n" }
      end
      context 'with readme' do
        it { expect(File.exist? 'spec/data/export/README.md').to be true }
        it { expect(File.read 'spec/data/export/README.md').to eq "## License\n![License icon](http://mmedia.20m.es/especiales/corporativo/css/img/licencia-cc-by-sa.png)\n\nThis content is distributed under Creative Commons License Share-Alike, 4.0. [https://creativecommons.org/licenses/by-sa/4.0/](https://creativecommons.org/licenses/by-sa/4.0)\n\nCopyright Foo Bar, Jhon Doe and contributors\n\nThis content consists of voluntary contributions made by many\nindividuals. For exact contribution history, see its revision history\navailable at https://github.com/flbulgarelli/never-existent-repo and the AUTHORS.txt file.\n\n" }
      end
      context 'with license' do
        it { expect(File.exist? 'spec/data/export/LICENSE.txt').to be true }
        it { expect(File.read 'spec/data/export/LICENSE.txt').to include 'Attribution-ShareAlike 4.0 International' }
      end
    end

    describe '#write_guide_files' do
      before { writer.write_guide! guide }

      it { expect(Dir.exist? 'spec/data/export/').to be true }
      it { expect(Dir.exist? 'spec/data/export/00100_foo/').to be true }
      it { expect(Dir.exist? 'spec/data/export/00200_bar/').to be true }
      it { expect(File.exist? 'spec/data/export/description.md').to be true }
      it { expect(File.exist? 'spec/data/export/meta.yml').to be true }
      it { expect(File.exist? 'spec/data/export/extra.hs').to be true }
      it { expect(File.exist? 'spec/data/export/AUTHORS.txt').to be true }
      it { expect(File.exist? 'spec/data/export/README.md').to be true }
      it { expect(File.exist? 'spec/data/export/LICENSE.txt').to be true }
      it { expect(File.exist? 'spec/data/export/COPYRIGHT.txt').to be true }
      it { expect(File.exist? 'spec/data/export/COLLABORATORS.txt').to be true }
      it { expect(Dir['spec/data/export/*'].size).to eq 10 }
    end
  end
end
