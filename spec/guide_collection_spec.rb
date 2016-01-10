require 'spec_helper'

describe Bibliotheca::Collection::Guides do
  after do
    Bibliotheca::Collection::Database.client[:guides].drop
  end

  describe '#insert' do
    let!(:id) { Bibliotheca::Collection::Guides.insert(Bibliotheca::Guide.new(
          name: 'foo',
          language: 'haskell',
          description: 'foo',
          exercises: []))[:id] }
    let(:inserted) { Bibliotheca::Collection::Guides.find(id) }

    it { expect(id).to_not be nil }
    it { expect(inserted).to_not be nil }
    it { expect(inserted.raw).to_not be_empty }
    it { expect(inserted.id).to eq id }
    it { expect(inserted.name).to eq 'foo' }
    it { expect(inserted.exercises).to eq [] }
    it { expect(Bibliotheca::Collection::Guides.count).to eq 1 }

    it { expect(inserted.to_json).to json_eq ({
        beta: false,
        type: 'practice',
        id_format: '%05d',
        name: 'foo',
        language: 'haskell',
        description: 'foo',
        exercises: [], id: id, expectations: []}) }

    it { expect(inserted.raw.to_json).to json_eq ({
        name: 'foo',
        language: 'haskell',
        exercises: [],
        description: 'foo',
        id: id}) }

  end

  describe '#upsert_by_slug' do
    let(:upserted) { Bibliotheca::Collection::Guides.find_by_slug('foo/goo') }

    context 'slug exists' do
      let!(:original_id) { Bibliotheca::Collection::Guides.insert(
          Bibliotheca::Guide.new(
            name: 'baz',
            slug: 'foo/goo',
            language: 'haskell',
            description: 'foo',
            exercises: [{name: 'baz', description: '#goo'}]))[:id] }

      let!(:id) { Bibliotheca::Collection::Guides.upsert_by_slug(
          'foo/goo',
          Bibliotheca::Guide.new(
            name: 'foobaz',
            slug: 'foo/goo',
            language: 'haskell',
            description: 'foo',
            exercises: [{name: 'baz', description: '#goo'}]))[:id] }

      it { expect(id).to_not be nil }
      it { expect(id).to eq original_id }

      it { expect(upserted.id).to eq id }
      it { expect(upserted.slug).to eq 'foo/goo' }
      it { expect(upserted.name).to eq 'foobaz' }
      it { expect(Bibliotheca::Collection::Guides.count).to eq 1 }
    end

    context 'slugs does not exits' do
      let!(:id) { Bibliotheca::Collection::Guides.upsert_by_slug(
          'foo/goo',
          build(:guide,
            name: 'foobaz',
            slug: 'foo/goo',
            description: 'foo',
            exercises: [{name: 'baz', description: '#goo'}]))[:id] }

      it { expect(id).to_not be nil }
      it { expect(upserted.id).to eq id }
      it { expect(upserted.slug).to eq 'foo/goo' }
      it { expect(upserted.name).to eq 'foobaz' }
      it { expect(Bibliotheca::Collection::Guides.count).to eq 1 }
    end
  end


  describe '#find_by_slug' do
    let!(:id) { Bibliotheca::Collection::Guides.insert(
        build(:guide,
          name: 'baz',
          slug: 'foo/goo',
          description: 'foo',
          exercises: [{name: 'baz', description: '#goo'}]))[:id] }
    context 'exists' do
      let(:guide) { Bibliotheca::Collection::Guides.find_by_slug('foo/goo') }

      it { expect(guide.raw).to_not be_empty }
      it { expect(guide.exercises.count).to eq 1 }
      it { expect(guide.name).to eq 'baz' }
      it { expect(Bibliotheca::Collection::Guides.count).to eq 1 }
    end

    context 'not exists' do
      it { expect { Bibliotheca::Collection::Guides.find_by_slug('foo/bar') }.to raise_error('guide {"slug":"foo/bar"} not found') }
    end
  end

  describe '#delete' do
    let!(:id) { Bibliotheca::Collection::Guides.insert(build(:guide))[:id] }

    before { Bibliotheca::Collection::Guides.delete(id) }

    it { expect { Bibliotheca::Collection::Guides.find(id) }.to raise_error(%Q{guide {"id":"#{id}"} not found}) }
  end
end
