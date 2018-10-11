require 'spec_helper'

describe Mumuki::Bibliotheca::Nuntius do
  it { expect(Mumuki::Bibliotheca::Nuntius.event_name Bibliotheca::Guide).to eq 'GuideChanged' }
  it { expect(Mumuki::Bibliotheca::Nuntius.event_name Bibliotheca::Topic).to eq 'TopicChanged' }
  it { expect(Mumuki::Bibliotheca::Nuntius.event_name Bibliotheca::Book).to eq 'BookChanged' }
end
