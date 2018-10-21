require 'spec_helper'

describe Guide do
  before { create(:haskell) }

  describe '#upsert_by_slug' do
    let(:upserted) { Guide.find_by_slug!('foo/goo') }

    context 'slug exists' do
      let!(:original_id) { Guide.insert!(
          Mumuki::Bibliotheca::Guide.new(
            name: 'baz',
            slug: 'foo/goo',
            language: 'haskell',
            description: 'foo',
            exercises: [{name: 'baz', description: '#goo'}]))[:id] }

      let!(:id) { Guide.upsert_by_slug(
          'foo/goo',
          Mumuki::Bibliotheca::Guide.new(
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
      it { expect(Guide.count).to eq 1 }
    end

    context 'slugs does not exits' do
      let!(:id) { Guide.upsert_by_slug(
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
      it { expect(Guide.count).to eq 1 }
    end
  end
end
