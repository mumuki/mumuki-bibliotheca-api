require 'spec_helper'

describe Bibliotheca::IO::GuideExport do
  let(:guide) { create(:guide) }
  let(:bot) { Bibliotheca::Bot.new('bot', 'bot@foo.org', 'asdfgh') }
  let(:export) { Bibliotheca::IO::GuideExport.new(document: guide, bot: bot, author_email: 'johnny.cash@hotmail.com') }

  before do
    expect(bot).to receive(:create!).and_return(nil).ordered
    expect(bot).to receive(:clone_into).and_return(nil).ordered
  end

  it { expect { export.run! }.to_not raise_error }
end
