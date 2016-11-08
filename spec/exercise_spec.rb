require 'spec_helper'

describe Bibliotheca::Exercise do
  let(:multiple_json) {{
        type: 'problem',
        name: 'Multiple',
        language: 'text',
        editor: 'multiple_choice',
        choices: [{value: 'foo', checked: true}, {value: 'bar', checked: false}, {value: 'baz', checked: true}],
        tag_list: %w(baz bar),
        layout: 'input_bottom',
        id: 2}.deep_stringify_keys}
  let(:single_json) {{
    type: 'problem',
    name: 'Single',
    language: 'haskell',
    test: 'foo',
    editor: 'single_choice',
    choices: [{value: 'foo', checked: true}, {value: 'bar', checked: false}, {value: 'baz', checked: false}],
    tag_list: %w(baz bar),
    layout: 'input_bottom',
    id: 2}.deep_stringify_keys}

  describe 'process multiple choices' do
    it { expect(Bibliotheca::Exercise.new(multiple_json).type).to eq 'problem' }
    it { expect(Bibliotheca::Exercise.new(multiple_json).name).to eq 'Multiple' }
    it { expect(Bibliotheca::Exercise.new(multiple_json).editor).to eq 'multiple_choice' }
    it { expect(Bibliotheca::Exercise.new(multiple_json).choices).to eq  multiple_json['choices'] }
    it { expect(Bibliotheca::Exercise.new(multiple_json).test).to eq "---\nequal: '0:2'\n" }
  end
  describe 'process single choices' do
    it { expect(Bibliotheca::Exercise.new(single_json).type).to eq 'problem' }
    it { expect(Bibliotheca::Exercise.new(single_json).name).to eq 'Single' }
    it { expect(Bibliotheca::Exercise.new(single_json).editor).to eq 'single_choice' }
    it { expect(Bibliotheca::Exercise.new(single_json).choices).to eq  single_json['choices'] }
    it { expect(Bibliotheca::Exercise.new(single_json).test).to eq "foo" }
  end
end
