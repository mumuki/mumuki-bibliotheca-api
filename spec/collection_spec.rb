require 'spec_helper'

describe Bibliotheca::Collection do
  let(:hash) {
    {
      name: 'the topic',
      description: 'this is important!',
      locale: 'es',
      slug: 'baz/foo',
      lessons: %w(bar/baz1 bar/baz2)
    }
  }

  before { Bibliotheca::Collection.insert_hash! 'topic', hash }
  let(:topic) { Bibliotheca::Collection::Topics.find_by(slug: 'baz/foo')
  }
  it { expect(topic).to be_present }
  it { expect(topic.name).to eq 'the topic' }
  it { expect(topic.lessons.size).to eq 2 }
end
