require 'spec_helper'

describe GitIo::Operation::GuideReader do
  let(:log) { GitIo::Operation::ImportLog.new }
  let(:repo) { GitIo::Repo.new('functional-haskell-guide-1', 'mumuki') }
  let(:haskell) { build(:haskell) }

  describe 'read_exercises' do
    let(:results) { [] }
    let(:reader) { GitIo::Operation::GuideReader.new('spec/data/simple-guide', repo, log) }

    before { reader.read_exercises { |it| results << it } }

    it { expect(results.size).to eq 4 }
    it { expect(log.messages).to eq ['Description does not exist for sample_broken'] }
  end

  describe '#read_guide!' do
    let!(:haskell) { GitIo::Language.find_by_name(:haskell) }

    context 'when guide is ok' do
      let(:reader) { GitIo::Operation::GuideReader.new('spec/data/simple-guide', repo, log) }
      let(:guide) { reader.read_guide! }

      it { expect(guide.github_repository).to eq 'mumuki/functional-haskell-guide-1'}
      it { expect(guide.exercises.count).to eq 4 }
      it { expect(guide.description).to eq "Awesome guide\n" }
      it { expect(guide.language).to eq haskell }
      it { expect(guide.locale).to eq 'en' }
      pending { expect(log.to_s).to eq 'Description does not exist for sample_broken' }

      context 'when importing basic exercise' do
        let(:imported_exercise) { guide.find_exercise_by_original_id(1) }

        it { expect(imported_exercise).to_not be nil }
        it { expect(imported_exercise.author).to eq guide.author }
        it { expect(imported_exercise.name).to eq 'sample_title' }
        it { expect(imported_exercise.description).to eq '##Sample Description' }
        it { expect(imported_exercise.test).to eq 'pending' }
        it { expect(imported_exercise.extra_code).to eq "extra\n" }
        it { expect(imported_exercise.hint).to be nil }
        it { expect(imported_exercise.corollary).to be nil }
        it { expect(imported_exercise.expectations.size).to eq 2 }
        it { expect(imported_exercise.tag_list).to include *%w(foo bar baz) }
        it { expect(guide.description).to eq "Awesome guide\n" }
        it { expect(imported_exercise.layout).to eq 'editor_right' }

      end

      context 'when importing exercise with errors' do
        let(:imported_exercise) { guide.find_exercise_by_original_id(2) }

        it { expect(imported_exercise).to be nil }
      end

      context 'when importing exercise with hint and corollary' do
        let(:imported_exercise) { guide.find_exercise_by_original_id(3) }

        it { expect(imported_exercise).to_not be nil }
        it { expect(imported_exercise.hint).to eq "Try this: blah blah\n" }
        it { expect(imported_exercise.corollary).to eq "And the corollary is...\n" }
      end

      context 'when importing with layout' do
        let(:imported_exercise) { guide.find_exercise_by_original_id(4) }

        it { expect(imported_exercise).to_not be nil }
        it { expect(imported_exercise.layout).to eq 'editor_bottom' }
      end

      context 'when importing playground' do
        let(:imported_exercise) { guide.find_exercise_by_original_id(5) }

        it { expect(imported_exercise).to_not be nil }
        it { expect(imported_exercise.name).to eq 'playground' }
        it { expect(imported_exercise.type).to eq 'playground' }

      end
    end
    context 'when guide is incomplete' do
      let(:reader) { GitIo::Operation::GuideReader.new('spec/data/incompelete-guide', repo, log) }

      it 'fails' do
        expect { reader.read_guide! }.to raise_exception
      end
    end
    context 'when guide has full data' do
      let(:reader) { GitIo::Operation::GuideReader.new('spec/data/full-guide', repo, log) }
      let!(:guide) { reader.read_guide! }

      it { expect(guide.name).to eq 'Introduction' }
      it { expect(guide.exercises.size).to eq 1 }
      it { expect(guide.corollary).to eq "A guide's corollary\n" }
      it { expect(guide.learning).to be true }
      it { expect(guide.beta).to eq true }
      it { expect(guide.extra).to eq "A guide's extra code\n" }
    end
  end
end
