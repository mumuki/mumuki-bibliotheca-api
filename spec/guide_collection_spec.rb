require 'spec_helper'

describe Guide do
  before { create(:haskell) }

  describe '#upsert_by_slug' do
    let(:upserted) { Guide.find_by_slug!('foo/goo') }

    context 'slug exists' do
      let!(:original_id) {
        import_from_api!(:guide,
                         name: 'baz',
                         slug: 'foo/goo',
                         language: 'haskell',
                         description: 'foo',
                         exercises: [{id: 1, name: 'baz', description: '#goo', manual_evaluation: true}])[:id]
      }

      let!(:id) {
        import_from_api!(:guide,
                         name: 'foobaz',
                         slug: 'foo/goo',
                         language: 'haskell',
                         description: 'foo',
                         exercises: [{id: 1, name: 'baz', description: '#goo', manual_evaluation: true}])[:id] }

      it { expect(id).to_not be nil }
      it { expect(id).to eq original_id }

      it { expect(upserted.id).to eq id }
      it { expect(upserted.slug).to eq 'foo/goo' }
      it { expect(upserted.name).to eq 'foobaz' }
      it { expect(Guide.count).to eq 1 }
    end

    context 'slugs does not exits' do
      let!(:id) {
        import_from_api!(:guide,
                        name: 'foobaz',
                        slug: 'foo/goo',
                        language: 'haskell',
                        description: 'foo',
                        exercises: [{id: 1, name: 'baz', description: '#goo', manual_evaluation: true}])[:id]
      }

      it { expect(id).to_not be nil }
      it { expect(upserted.id).to eq id }
      it { expect(upserted.slug).to eq 'foo/goo' }
      it { expect(upserted.name).to eq 'foobaz' }
      it { expect(Guide.count).to eq 1 }
    end
  end
end
