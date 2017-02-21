require 'spec_helper'

describe Bibliotheca::Collection::Users do

  let(:user) { {uid: uid, permissions: {writer: 'foo/bar'}} }

  describe 'should update user permissions' do
    let(:uid) { 'bot@mumuki.org' }
    let(:permissions) { Bibliotheca::Collection::Users.find_by_uid!(uid).permissions }

    before { Bibliotheca::Collection::Users.import_from_json! user }

    it { expect(permissions.has_permission? :writer, 'foo/bar').to eq true }
    it { expect(permissions.has_permission? :editor, 'foo/bar').to eq false }
  end

end
