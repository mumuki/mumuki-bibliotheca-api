require 'spec_helper'

describe Bibliotheca::IO::GuideReader do
  let(:log) { Bibliotheca::IO::Log.new }
  let(:repo) { Mumukit::Service::Slug.new('mumuki', 'functional-haskell-guide-1') }
  let(:haskell) { build(:haskell) }

  describe 'read_exercises' do
    let(:results) { [] }
    let(:reader) { Bibliotheca::IO::GuideReader.new('spec/data/simple-guide', repo, log) }

    before { reader.read_exercises { |it| results << it } }

    it { expect(results.size).to eq 4 }
    it { expect(log.messages).to eq ['Description does not exist for sample_broken'] }
  end

  describe '#read_guide!' do
    before { Bibliotheca::Collection::Languages.insert!(haskell) }

    context 'when guide is ok' do
      let(:reader) { Bibliotheca::IO::GuideReader.new('spec/data/simple-guide', repo, log) }
      let(:guide) { reader.read_guide! }

      it { expect(guide.slug).to eq 'mumuki/functional-haskell-guide-1'}
      it { expect(guide.exercises.count).to eq 4 }
      it { expect(guide.description).to eq "Awesome guide\n" }
      it { expect(guide.language.name).to eq 'haskell' }
      it { expect(guide.locale).to eq 'en' }
      it { expect(guide.teacher_info).to eq 'information' }

      context 'when importing basic exercise' do
        let(:imported_exercise) { guide.find_exercise_by_id(1) }

        it { expect(imported_exercise).to_not be nil }
        it { expect(imported_exercise.default_content).to_not be nil }
        it { expect(imported_exercise.author).to eq guide.author }
        it { expect(imported_exercise.name).to eq 'sample_title' }
        it { expect(imported_exercise.extra_visible).to be true }
        it { expect(imported_exercise.description).to eq '##Sample Description' }
        it { expect(imported_exercise.test).to eq 'pending' }
        it { expect(imported_exercise.extra).to eq "extra\n" }
        it { expect(imported_exercise.hint).to be nil }
        it { expect(imported_exercise.teacher_info).to eq 'information' }
        it { expect(imported_exercise.corollary).to be nil }
        it { expect(imported_exercise.expectations.size).to eq 2 }
        it { expect(imported_exercise.tag_list).to include *%w(foo bar baz) }
        it { expect(guide.description).to eq "Awesome guide\n" }
        it { expect(imported_exercise.layout).to eq 'editor_right' }

      end

      context 'when importing exercise with errors' do
        let(:imported_exercise) { guide.find_exercise_by_id(2) }

        it { expect(imported_exercise).to be nil }
      end

      context 'when importing exercise with hint and corollary' do
        let(:imported_exercise) { guide.find_exercise_by_id(3) }

        it { expect(imported_exercise).to_not be nil }
        it { expect(imported_exercise.hint).to eq "Try this: blah blah\n" }
        it { expect(imported_exercise.corollary).to eq "And the corollary is...\n" }
      end

      context 'when importing with layout' do
        let(:imported_exercise) { guide.find_exercise_by_id(4) }

        it { expect(imported_exercise).to_not be nil }
        it { expect(imported_exercise.layout).to eq 'editor_bottom' }
      end

      context 'when importing playground' do
        let(:imported_exercise) { guide.find_exercise_by_id(5) }

        it { expect(imported_exercise).to_not be nil }
        it { expect(imported_exercise.name).to eq 'playground' }
        it { expect(imported_exercise.type).to eq 'playground' }

      end
    end
    context 'when guide is incomplete' do
      let(:reader) { Bibliotheca::IO::GuideReader.new('spec/data/incompelete-guide', repo, log) }

      it 'fails' do
        expect { reader.read_guide! }.to raise_exception
      end
    end
    context 'when guide has full data' do
      let(:reader) { Bibliotheca::IO::GuideReader.new('spec/data/full-guide', repo, log) }
      let!(:guide) { reader.read_guide! }

      it { expect(guide.name).to eq 'Introduction' }
      it { expect(guide.authors).to eq "Foo Bar\n" }
      it { expect(guide.collaborators).to eq "Jhon Doe\n" }
      it { expect(guide.exercises.size).to eq 1 }
      it { expect(guide.corollary).to eq "A guide's corollary\n" }
      it { expect(guide.type).to eq 'learning' }
      it { expect(guide.id_format).to eq '%05d' }
      it { expect(guide.beta).to eq true }
      it { expect(guide.extra).to eq "A guide's extra code\n" }
    end

    context 'when guide has legacy data' do
      let(:reader) { Bibliotheca::IO::GuideReader.new('spec/data/legacy-guide', repo, log) }
      let!(:guide) { reader.read_guide! }

      it { expect(guide.name).to eq 'Introduction' }
      it { expect(guide.exercises.size).to eq 1 }
      it { expect(guide.corollary).to eq "A guide's corollary\n" }
      it { expect(
          guide.type).to eq 'learning' }
      it { expect(guide.id_format).to eq '%03d' }
      it { expect(guide.beta).to eq true }
      it { expect(guide.extra).to eq "A guide's extra code\n" }
    end
  end
end
