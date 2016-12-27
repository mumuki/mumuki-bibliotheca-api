require 'spec_helper'

describe Bibliotheca::Event::UserChanged do

  let(:user_event) {{user: user}}
  let(:user) {{uid: uid, permissions: {writer: 'foo/bar'}}}

  describe 'should update user permissions' do
    let(:uid) {'bot@mumuki.org'}
    let(:permissions) { Mumukit::Auth::Store.get uid }

    before { Mumukit::Auth::Store.set! uid, {} }
    before { Bibliotheca::Event::UserChanged.execute! user_event }

    it{ expect(permissions.has_permission? :writer, 'foo/bar').to eq true }
    it{ expect(permissions.has_permission? :editor, 'foo/bar').to eq false }
  end

end
