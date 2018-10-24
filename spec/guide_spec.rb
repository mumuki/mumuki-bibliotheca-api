require 'spec_helper'

describe Guide do
  let!(:haskell) { create(:haskell) }

  let(:json) {
    {name: 'my guide',
     description: 'Baz',
     slug: 'flbulgarelli/never-existent-repo',
     language: 'haskell',
     locale: 'en',
     exercises: [
       {name: 'Bar',
        description: 'a description',
        test: 'foo bar',
        layout: 'input_bottom',
        manual_evaluation: true,
        id: 1},

       {type: 'problem',
        description: 'other description',
        name: 'Foo',
        tag_list: %w(foo bar),
        manual_evaluation: true,
        id: 4},

       {type: 'playground',
        description: 'another description',
        name: 'Baz',
        tag_list: %w(baz bar),
        layout: 'input_bottom',
        manual_evaluation: true,
        id: 2}]} }


  context 'stringified keys' do
    let(:stringified) { json.stringify_keys }
    let(:guide) { import_from_api! :guide, stringified }

    it { expect(guide.name).to eq 'my guide' }
    it { expect(guide.exercises.first.name).to eq 'Bar' }
    it { expect(guide.exercises.first).to be_a Problem }
  end

  context 'symbolized keys' do
    let(:guide) { import_from_api! :guide, json }

    it { expect(guide.name).to eq 'my guide' }
    it { expect(guide.exercises.first.name).to eq 'Bar' }
    it { expect(guide.exercises.first).to be_a Problem }
    it { expect(guide.exercises.second).to be_a Problem }
    it { expect(guide.exercises.third).to be_a Playground }
    it { expect(guide.exercises.first.tag_list).to eq [] }
    it { expect(guide.id_format).to eq '%05d' }
    it { expect(guide.expectations).to eq [] }
  end

  describe 'validations' do
    context 'bad type' do
      it { expect { create(:guide, type: 'fdfd') }.to raise_error "'fdfd' is not a valid type" }
    end
  end
end
