require 'spec_helper'

describe Mumukit::Nuntius do
  it { expect(Mumukit::Nuntius.event_name Bibliotheca::Guide).to eq 'GuideChanged' }
  it { expect(Mumukit::Nuntius.event_name Bibliotheca::Topic).to eq 'TopicChanged' }
  it { expect(Mumukit::Nuntius.event_name Bibliotheca::Book).to eq 'BookChanged' }
end
