require 'spec_helper'

describe GitIo::Guide do
  let(:json) {
    {name: 'my guide',
     description: 'Baz',
     github_repository: 'flbulgarelli/never-existent-repo',
     language: 'haskell',
     locale: 'en',
     exercises: [
         {name: 'Bar',
          description: 'a description',
          test: 'foo bar',
          layout: 'no_editor',
          original_id: 1},

         {type: 'problem',
          name: 'Foo',
          tag_list: %w(foo bar),
          original_id: 4},

         {type: 'playground',
          name: 'Baz',
          tag_list: %w(baz bar),
          layout: 'editor_bottom',
          original_id: 2}]} }


  context 'stringified keys' do
    let(:stringified) { json.stringify_keys }
    let(:guide) { GitIo::Guide.new stringified }

    it { expect(guide.name).to eq 'my guide' }
    it { expect(guide.exercises.first.name).to eq 'Bar' }
    it { expect(guide.exercises.first.type).to eq 'problem' }
  end

  context 'symbolized keys' do
    let(:guide) { GitIo::Guide.new json }

    it { expect(guide.name).to eq 'my guide' }
    it { expect(guide.exercises.first.name).to eq 'Bar' }
    it { expect(guide.exercises.first.type).to eq 'problem' }
    it { expect(guide.exercises.second.type).to eq 'problem' }
    it { expect(guide.exercises.third.type).to eq 'playground' }
    it { expect(guide.exercises.first.tag_list).to eq [] }
    it { expect(guide.original_id_format).to eq '%05d' }
  end
end