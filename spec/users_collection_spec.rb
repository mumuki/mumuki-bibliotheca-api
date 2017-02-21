require_relative './spec_helper'

describe Bibliotheca::Collection::Users do

  describe 'upsert_permissions!' do
    let(:uid) { 'jimmy@company.com' }
    let(:user) { Bibliotheca::Collection::Users.find_by_uid! uid }

    before { Bibliotheca::Collection::Users.upsert_permissions! uid, teacher: 'foo/bar' }

    it { expect(Bibliotheca::Collection::Users.count).to eq 1 }
    it { expect(user).to be_a Bibliotheca::User }
    it { expect(user).to json_like uid: uid, permissions: {teacher: 'foo/bar'} }
    it { expect(user.permissions).to be_a Mumukit::Auth::Permissions }
    it { expect(user.has_role? :teacher).to be true }
    it { expect(user.has_role? :student).to be false }
  end
end
