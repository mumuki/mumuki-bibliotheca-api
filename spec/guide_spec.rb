require 'spec_helper'

describe Bibliotheca::Guide do
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
          layout: 'no_editor',
          id: 1},

         {type: 'problem',
          name: 'Foo',
          tag_list: %w(foo bar),
          id: 4},

         {type: 'playground',
          name: 'Baz',
          tag_list: %w(baz bar),
          layout: 'editor_bottom',
          id: 2}]} }


  context 'stringified keys' do
    let(:stringified) { json.stringify_keys }
    let(:guide) { Bibliotheca::Guide.new stringified }

    it { expect(guide.name).to eq 'my guide' }
    it { expect(guide.exercises.first.name).to eq 'Bar' }
    it { expect(guide.exercises.first.type).to eq 'problem' }
  end

  context 'symbolized keys' do
    let(:guide) { Bibliotheca::Guide.new json }

    it { expect(guide.name).to eq 'my guide' }
    it { expect(guide.exercises.first.name).to eq 'Bar' }
    it { expect(guide.exercises.first.type).to eq 'problem' }
    it { expect(guide.exercises.second.type).to eq 'problem' }
    it { expect(guide.exercises.third.type).to eq 'playground' }
    it { expect(guide.exercises.first.tag_list).to eq [] }
    it { expect(guide.id_format).to eq '%05d' }
    it { expect(guide.expectations).to eq [] }

    describe 'as_json' do
      let(:exported) { guide.as_json }

      it { expect(exported['name']).to eq 'my guide' }
      it { expect(exported['beta']).to eq false }
      it { expect(exported['exercises'][0]['type']).to eq 'problem' }
    end
  end

  describe 'validations' do
    context 'no name' do
      let(:guide) { build(:guide, name: nil) }

      it { expect(guide.errors).to include 'Name must be present' }
      it { expect(guide.errors.size).to eq 1 }
    end

    context 'bad type' do
      let(:guide) { build(:guide, type: 'fdfd') }

      it { expect(guide.errors).to include 'Unrecognized guide type fdfd' }
      it { expect(guide.errors.size).to eq 1 }

    end

    context 'bad beta' do
      let(:guide) { build(:guide, beta: 'true') }

      it { expect(guide.errors).to include 'Beta flag must be boolean' }
      it { expect(guide.errors.size).to eq 1 }
    end

    context 'no language' do
      let(:guide) { build(:guide, language: nil) }

      it { expect(guide.errors).to include 'Language must be present' }
      it { expect(guide.errors.size).to eq 1 }
    end
  end
end
