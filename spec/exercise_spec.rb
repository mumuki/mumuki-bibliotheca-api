require 'spec_helper'

describe Bibliotheca::Exercise do
  let(:multiple_json) { {
    type: 'problem',
    name: 'Multiple',
    language: 'text',
    editor: 'multiple_choice',
    choices: [{value: 'foo', checked: true}, {value: 'bar', checked: false}, {value: 'baz', checked: true}],
    tag_list: %w(baz bar),
    layout: 'input_bottom',
    id: 2}.deep_stringify_keys }

  let(:single_json) { {
    type: 'problem',
    name: 'Single',
    language: 'haskell',
    test: 'foo',
    editor: 'single_choice',
    choices: [{value: 'foo', checked: true}, {value: 'bar', checked: false}, {value: 'baz', checked: false}],
    tag_list: %w(baz bar),
    layout: 'input_bottom',
    id: 2}.deep_stringify_keys }

  let(:single_json_text) { {
    type: 'problem',
    name: 'Single',
    language: 'text',
    editor: 'single_choice',
    choices: [{value: 'foo', checked: true}, {value: 'bar', checked: false}, {value: 'baz', checked: false}],
    tag_list: %w(baz bar),
    layout: 'input_bottom',
    id: 2}.deep_stringify_keys }


  let(:single_json_text_in_guide) { {
    guide: build(:guide, language: 'text'),
    type: 'problem',
    name: 'Single',
    editor: 'single_choice',
    choices: [{value: 'foo', checked: true}, {value: 'bar', checked: false}, {value: 'baz', checked: false}],
    tag_list: %w(baz bar),
    layout: 'input_bottom',
    id: 2}.deep_stringify_keys }


  describe 'process multiple choices' do
    it { expect(Bibliotheca::Exercise.new(multiple_json).type).to eq 'problem' }
    it { expect(Bibliotheca::Exercise.new(multiple_json).name).to eq 'Multiple' }
    it { expect(Bibliotheca::Exercise.new(multiple_json).editor).to eq 'multiple_choice' }
    it { expect(Bibliotheca::Exercise.new(multiple_json).choices).to eq multiple_json['choices'] }
    it { expect(Bibliotheca::Exercise.new(multiple_json).test).to eq "---\nequal: '0:2'\n" }
  end

  describe 'process single choices with non-text language' do
    it { expect(Bibliotheca::Exercise.new(single_json).type).to eq 'problem' }
    it { expect(Bibliotheca::Exercise.new(single_json).name).to eq 'Single' }
    it { expect(Bibliotheca::Exercise.new(single_json).editor).to eq 'single_choice' }
    it { expect(Bibliotheca::Exercise.new(single_json).choices).to eq single_json['choices'] }
    it { expect(Bibliotheca::Exercise.new(single_json).test).to eq "foo" }
  end

  describe 'process single choices with text language' do
    it { expect(Bibliotheca::Exercise.new(single_json_text).type).to eq 'problem' }
    it { expect(Bibliotheca::Exercise.new(single_json_text).name).to eq 'Single' }
    it { expect(Bibliotheca::Exercise.new(single_json_text).editor).to eq 'single_choice' }
    it { expect(Bibliotheca::Exercise.new(single_json_text).choices).to eq single_json_text['choices'] }
    it { expect(Bibliotheca::Exercise.new(single_json_text).test).to eq "---\nequal: foo\n" }
  end

  describe 'process single choices with text language in guide' do
    subject { Bibliotheca::Exercise.new(single_json_text_in_guide) }
    it { expect(subject.type).to eq 'problem' }
    it { expect(subject.name).to eq 'Single' }
    it { expect(subject.language).to be nil }
    it { expect(subject.effective_language_name).to eq 'text' }
    it { expect(subject.editor).to eq 'single_choice' }
    it { expect(subject.choices).to eq single_json_text_in_guide['choices'] }
    it { expect(subject.test).to eq "---\nequal: foo\n" }
  end


  describe 'markdownified' do
    context 'description' do
      let(:exercise) { build(:exercise, description: '`foo = (+)`') }
      it { expect(exercise.markdownified.description).to eq("<p><code>foo = (+)</code></p>\n") }
    end
    context 'corollary' do
      let(:exercise) { build(:exercise, corollary: '[Google](https://google.com)') }
      it { expect(exercise.markdownified.corollary).to eq("<p><a href=\"https://google.com\">Google</a></p>\n") }
    end
    context 'teacher_info' do
      let(:exercise) { build(:exercise, teacher_info: '**foo**') }
      it { expect(exercise.markdownified.teacher_info).to eq("<p><strong>foo</strong></p>\n") }
    end
    context 'hint' do
      let(:exercise) { build(:exercise, hint: '***foo***') }
      it { expect(exercise.markdownified.hint).to eq("<p><strong><em>foo</em></strong></p>\n") }
    end
  end
end
