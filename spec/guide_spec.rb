require 'spec_helper'

describe Guide do
  let(:syncer) { double(:syncer) }

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
    it { expect(guide.exercises.first.type).to eq 'problem' }
  end

  context 'symbolized keys' do
    let(:guide) { import_from_api! :guide, json }

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
    context 'bad type' do
      it { expect { create(:guide, type: 'fdfd') }.to raise_error "'fdfd' is not a valid type" }
    end
  end

  describe 'to_markdownified_resource_h' do
    context 'description' do
      let(:guide) { build(:guide, description: '`foo = (+)`') }
      it { expect(guide.to_markdownified_resource_h[:description]).to eq("<p><code>foo = (+)</code></p>\n") }
    end
    context 'corollary' do
      let(:guide) { build(:guide, corollary: '[Google](https://google.com)') }
      it { expect(guide.to_markdownified_resource_h[:corollary]).to eq("<p><a title=\"\" href=\"https://google.com\" target=\"_blank\">Google</a></p>\n") }
    end
    context 'teacher_info' do
      let(:guide) { build(:guide, teacher_info: '**foo**') }
      it { expect(guide.to_markdownified_resource_h[:teacher_info]).to eq("<p><strong>foo</strong></p>\n") }
    end
    context 'exercises' do
      let(:guide) { build(:guide, exercises: [build(:exercise, description: '**foo**', expectations: [])]) }
      it { expect(guide.to_markdownified_resource_h[:exercises].first[:description]).to eq("<p><strong>foo</strong></p>\n") }
    end
  end

  describe 'fork' do

    let!(:guide_from) { create :guide, slug: 'foo/bar' }
    let(:slug_from) { guide_from.slug }
    let(:slug_to) { 'baz/bar'.to_mumukit_slug }
    let(:guide_to) { Guide.find_by_slug! slug_to.to_s }
    let!(:guide) { create(:guide, slug: 'test/bar') }

    context 'fork works' do
      before { expect(syncer).to receive(:export!).with(instance_of(Guide)) }
      before { Guide.find_by_slug!(slug_from).fork_to! 'baz', syncer }
      it { expect(guide_from.as_json).to json_like guide_to.as_json, {except: [:slug, :id, :created_at, :updated_at]} }
    end

    context 'fork does not work if guide already exists' do
      before { expect(syncer).to_not receive(:export!) }
      it { expect { Guide.find_by_slug!(slug_from).fork_to! 'test', syncer }.to raise_error ActiveRecord::RecordInvalid }
    end

  end

end
