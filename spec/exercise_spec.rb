require 'spec_helper'

describe Bibliotheca::Exercise do
  let(:multiple_json) {{
        type: 'problem',
        name: 'Multiple',
        editor: 'multiple_choice',
        choices: [{value: 'foo', checked: true}, {value: 'bar', checked: false}, {value: 'baz', checked: true}],
        tag_list: %w(baz bar),
        layout: 'input_bottom',
        id: 2}.deep_stringify_keys}

  describe 'process choices' do
    it { expect(Bibliotheca::Exercise.new(multiple_json).type).to eq 'problem' }
    it { expect(Bibliotheca::Exercise.new(multiple_json).name).to eq 'Multiple' }
    it { expect(Bibliotheca::Exercise.new(multiple_json).editor).to eq 'multiple_choice' }
    it { expect(Bibliotheca::Exercise.new(multiple_json).choices).to eq  multiple_json['choices'] }
    it { expect(Bibliotheca::Exercise.new(multiple_json).test).to eq "---\nequal: '0:2'\n" }
  end
end
