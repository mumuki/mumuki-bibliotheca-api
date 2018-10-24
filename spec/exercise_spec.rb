require 'spec_helper'

describe Exercise do
  let!(:text) { create(:text) }
  let!(:gobstones) { create(:gobstones) }
  let(:guide_language) { 'gobstones' }
  let(:guide_api_json) {
    {
      name: 'sample guide',
      description: 'Baz',
      slug: 'mumuki/sample-guide',
      language: guide_language,
      locale: 'en',
      extra: 'bar',
      teacher_info: 'an info',
      authors: 'Foo Bar',
      exercises: [ exercise_api_json ]
    }
  }
  subject { import_from_api!(:guide, guide_api_json).exercises.first }

  describe 'choices import' do
    describe 'process multiple choices' do
      let(:exercise_api_json) { {
        type: 'problem',
        name: 'Multiple',
        description: 'a description',
        language: 'text',
        editor: 'multiple_choice',
        choices: [{value: 'foo', checked: true}, {value: 'bar', checked: false}, {value: 'baz', checked: true}],
        tag_list: %w(baz bar),
        layout: 'input_bottom',
        id: 2} }

      it { expect(subject).to be_a Problem }
      it { expect(subject.name).to eq 'Multiple' }
      it { expect(subject.editor).to eq 'multiple_choice' }
      it { expect(subject.choices).to eq %w(foo bar baz) }
      it { expect(subject.test).to eq "---\nequal: '0:2'\n" }
    end

    describe 'process single choices with non-text language' do
      let(:exercise_api_json) { {
        type: 'problem',
        name: 'Single',
        description: 'a big problem',
        language: 'gobstones',
        test: 'foo',
        editor: 'single_choice',
        choices: [{value: 'foo', checked: true}, {value: 'bar', checked: false}, {value: 'baz', checked: false}],
        tag_list: %w(baz bar),
        layout: 'input_bottom',
        id: 2} }

      it { expect(subject).to be_a Problem }
      it { expect(subject.name).to eq 'Single' }
      it { expect(subject.editor).to eq 'single_choice' }
      it { expect(subject.choices).to eq %w(foo bar baz) }
      it { expect(subject.test).to eq "foo" }
    end

    describe 'process single choices with text language' do
      let(:exercise_api_json) { {
        type: 'problem',
        name: 'Single',
        description: 'a big problem',
        language: 'text',
        editor: 'single_choice',
        choices: [{value: 'foo', checked: true}, {value: 'bar', checked: false}, {value: 'baz', checked: false}],
        tag_list: %w(baz bar),
        layout: 'input_bottom',
        id: 2} }

      it { expect(subject).to be_a Problem }
      it { expect(subject.name).to eq 'Single' }
      it { expect(subject.editor).to eq 'single_choice' }
      it { expect(subject.choices).to eq %w(foo bar baz) }
      it { expect(subject.test).to eq "---\nequal: foo\n" }
    end

    describe 'process single choices with text language in guide' do
      let(:guide_language) { 'text' }
      let(:exercise_api_json) { {
        type: 'problem',
        name: 'Single',
        description: 'a big problem',
        editor: 'single_choice',
        choices: [{value: 'foo', checked: true}, {value: 'bar', checked: false}, {value: 'baz', checked: false}],
        tag_list: %w(baz bar),
        layout: 'input_bottom',
        id: 2} }

      it { expect(subject).to be_a Problem }
      it { expect(subject.name).to eq 'Single' }
      it { expect(subject.language.name).to eq 'text' }
      it { expect(subject.editor).to eq 'single_choice' }
      it { expect(subject.choices).to eq %w(foo bar baz) }
      it { expect(subject.test).to eq "---\nequal: foo\n" }
    end

  end


  describe 'states import' do
    let(:exercise_api_json) {
      {
        name: 'an exercise',
        id: 1,
        description: 'a description',
        expectations: [{binding: 'program', inspection: 'Uses:foo'}],
        layout: 'input_kids',
        language: 'gobstones',
        test: test
      }
    }
    context 'with examples' do
      let(:test) { "
        check_head_position: #{check_head_position}

        examples:
         - title: 'Si hay celdas al Este, se mueve'
           initial_board: |
             GBB/1.0
             size 2 2
             head 0 0
           final_board: |
             GBB/1.0
             size 2 2
             head 1 0
         - title: 'Si no hay celdas al Este, no hace nada'
           initial_board: |
             GBB/1.0
             size 2 2
             head 1 0
           final_board: |
             GBB/1.0
             size 2 2
             head 1 0" }
      let(:check_head_position) { true }

      it { expect(subject.initial_state).to eq "<gs-board> GBB/1.0\nsize 2 2\nhead 0 0\n </gs-board>" }
      it { expect(subject.final_state).to eq "<gs-board> GBB/1.0\nsize 2 2\nhead 1 0\n </gs-board>" }

      context 'with check_head_position: false' do
        let(:check_head_position) { false }

        it { expect(subject.initial_state).to eq "<gs-board> GBB/1.0\nsize 2 2\nhead 0 0\n </gs-board>" }
        it { expect(subject.final_state).to eq "<gs-board without-header> GBB/1.0\nsize 2 2\nhead 1 0\n </gs-board>" }
      end
    end
    context 'without test' do
      let(:test) { nil }
      it { expect(subject.initial_state).to be_nil }
      it { expect(subject.final_state).to be_nil }
    end
    context 'without examples' do
      let(:test) { "check_head_position: true" }
      it { expect(subject.initial_state).to be_nil }
      it { expect(subject.final_state).to be_nil }
    end
    context 'without boards' do
      let(:test) { "
        check_head_position: true

        examples:
         - title: 'Si hay celdas al Este, se mueve'" }
      it { expect(subject.initial_state).to be_nil }
      it { expect(subject.final_state).to eq Mumukit::Sync::Inflator::GobstonesKidsBoards.boom_board }
    end
  end
end
