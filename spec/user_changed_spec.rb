require 'spec_helper'

describe Bibliotheca::Collection::Users do

  let(:user) { {uid: uid, permissions: {writer: 'foo/bar'}} }
  let(:uid) { 'bot@mumuki.org' }

  context 'when there are permissions changes' do
    let(:permissions) { Bibliotheca::Collection::Users.find_by_uid!(uid).permissions }

    before { Bibliotheca::Collection::Users.import_from_json! user }

    it { expect(permissions.has_permission? :writer, 'foo/bar').to eq true }
    it { expect(permissions.has_permission? :editor, 'foo/bar').to eq false }
  end

  context 'when there are no permissions changes' do
    before { Bibliotheca::Collection::Users.import_from_json! uid: uid, permissions: {writer: 'foo/bar'} }
    before { Bibliotheca::Collection::Users.import_from_json! uid: uid, permissions: nil }

    let(:permissions) { Bibliotheca::Collection::Users.find_by_uid!(uid).permissions }
    it { expect(permissions.has_permission? :writer, 'foo/bar').to eq true }
    it { expect(permissions.has_permission? :editor, 'foo/bar').to eq false }
  end

end
