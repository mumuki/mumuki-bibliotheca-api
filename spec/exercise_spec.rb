require 'spec_helper'

describe Bibliotheca::Exercise do
  let(:json) {{
        type: 'problem',
        name: 'Multiple',
        editor: 'multiple_choice',
        choices: [{value: 'foo', checked: true}, {value: 'bar', checked: false}],
        tag_list: %w(baz bar),
        layout: 'input_bottom',
        id: 2}.deep_stringify_keys}

  describe 'process choices' do
    it { expect(Bibliotheca::Exercise.new(json).type).to eq 'problem' }
    it { expect(Bibliotheca::Exercise.new(json).name).to eq 'Multiple' }
    it { expect(Bibliotheca::Exercise.new(json).editor).to eq 'multiple_choice' }
    it { expect(Bibliotheca::Exercise.new(json).choices).to eq  json['choices'] }
    it { expect(Bibliotheca::Exercise.new(json).test).to eq "---\nequal: foo\n" }
  end
end
