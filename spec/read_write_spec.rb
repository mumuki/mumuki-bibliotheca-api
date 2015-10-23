require 'spec_helper'

describe 'read-write' do
  let(:haskell) { build(:haskell) }
  let(:export_log) { GitIo::Operation::ExportLog.new }
  let(:import_log) { GitIo::Operation::ImportLog.new }
  let(:guide) { GitIo::Guide.new(
      description: 'Baz',
      github_repository: 'flbulgarelli/never-existent-repo',
      language: haskell.name,
      locale: 'en',
      original_id_format: '%05d',
      exercises: [
          {type: :problem,
           name: 'Bar',
           description: 'a description',
           test: 'foo bar',
           tag_list: %w(baz bar),
           layout: :no_editor,
           original_id: 1},

          {type: :problem,
           name: 'Foo',
           tag_list: %w(foo bar),
           original_id: 4},

          {name: 'Baz',
           tag_list: %w(baz bar),
           layout: :editor_bottom,
           type: :problem,
           original_id: 2}]) }

  let(:dir) { 'spec/data/import-export' }

  let(:imported_guide) do
    FileUtils.mkdir_p dir
    GitIo::Operation::GuideWriter.new(dir, export_log).write_guide! guide
    GitIo::Operation::GuideReader.new(dir, import_log).read_guide!
  end

  after do
    FileUtils.rm_rf dir
  end

  it { expect(import_log.to_s).to eq '' }
  it { expect(export_log.to_s).to eq '' }

  it { expect(imported_guide.exercises.length).to eq 3 }
  it { expect(imported_guide.exercises.first.name).to eq 'Bar' }
  it { expect(imported_guide.exercises.second.name).to eq 'Foo' }
  it { expect(imported_guide.exercises.third.name).to eq 'Baz' }
  it { expect(imported_guide.exercises.first.layout).to eq 'no_editor' }
  it { expect(imported_guide.exercises.second.layout).to eq 'editor_right' }

  it { expect(imported_guide.language).to eq haskell }
  it { expect(imported_guide.locale).to eq 'en' }
  it { expect(imported_guide.description).to eq 'Baz' }


end
