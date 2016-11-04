require 'spec_helper'

describe Bibliotheca::Exercise do
  let(:json) {{
        type: 'problem',
        name: 'Multiple',
        choices: [{value: 'foo', value: true}, {value: 'bar', checked: false}],
        tag_list: %w(baz bar),
        layout: 'input_bottom',
        id: 2}}

  describe 'process choices' do
    it { expect(Bibliotheca::Exercise.new(json).type).to eq 'problem' }
    it { expect(Bibliotheca::Exercise.new(json).name).to eq 'Multiple' }
    it { expect(Bibliotheca::Exercise.new(json).choices).to eq  json[:choices] }
    it { expect(Bibliotheca::Exercise.new(json).test).to eq({ equal: 'foo'})}
  end
end
