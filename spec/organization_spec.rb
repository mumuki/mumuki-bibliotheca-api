require 'spec_helper'

describe Bibliotheca::Collection::Organizations do
  let(:json) { {
    name: organization_name,
    book: 'MumukiProject/mumuki-libro-metaprogramacion',
    profile: {
      contact_email: 'issues@mumuki.io',
      locale: 'es-AR',
      description: '...',
      logo_url: 'http://mumuki.io/aLogo.png',
      terms_of_service: 'A TOS HERE'
    },
    theme: {
      theme_stylesheet_url: '.theme { color: red }',
      extension_javascript_url: 'doSomething = function() { }'
    },
    settings: {
      public: false,
      login_methods: %w(facebook twitter google),
    }
  } }

  context 'when organization is base and new' do
    let(:organization_name) { 'base' }
    before { Bibliotheca::Collection::Organizations.import_from_json! json }

    it { expect(Bibliotheca::Collection::Organizations.count).to eq 1 }
    it { expect(Bibliotheca::Collection::Organizations.base).to json_like json }
  end

  context 'when organization is base and exists' do
    let(:organization_name) { 'base' }
    before do
      Bibliotheca::Collection::Organizations.import_from_json! json
      Bibliotheca::Collection::Organizations.import_from_json! json
    end

    it { expect(Bibliotheca::Collection::Organizations.count).to eq 1 }
    it { expect(Bibliotheca::Collection::Organizations.base).to json_like json }
  end

  context 'when organization is non-base' do
    let(:organization_name) { 'central' }
    before { Bibliotheca::Collection::Organizations.import_from_json! json }

    it { expect(Bibliotheca::Collection::Organizations.count).to eq 0 }
  end
end
