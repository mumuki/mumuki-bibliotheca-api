require 'spec_helper'

describe Bibliotheca::Language do
  describe '#import_from_json!' do
    let(:json) do
      {'name' => 'ruby',
       'version' => 'master',
       'escualo_base_version' => nil,
       'escualo_service_version' => nil,
       'mumukit_version' => '1.0.1',
       'output_content_type' => 'markdown',
       'features' => {
         'query' => true,
         'expectations' => false,
         'feedback' => false,
         'secure' => false,
         'sandboxed' => true,
         'stateful' => true,
         'structured' => true
       },
       'language' => {
         'prompt' => '>',
         'name' => 'ruby',
         'icon' => {
           'type' => 'devicon',
           'name' => 'ruby'
         },
         'version' => '2.0',
         'extension' => '.rb',
         'ace_mode' => 'ruby'
       },
       'test_framework' => {
         'name' => 'rspec',
         'version' => '2.13',
         'test_extension' => '.rb'
       },
       'url' => 'http://ruby.runners.mumuki.io'
      }
    end
    before { Bibliotheca::Collection::Languages.import_from_json! json }
    let(:imported_language) { Bibliotheca::Collection::Languages.find_by! name: 'ruby' }

    it { expect(Bibliotheca::Collection::Languages.count).to eq 1 }

    it { expect(imported_language.name).to eq 'ruby' }
    it { expect(imported_language.test_runner_url).to eq 'http://ruby.runners.mumuki.io' }
    it { expect(imported_language.extension).to eq '.rb' }
    it { expect(imported_language.test_extension).to eq '.rb' }

    context 'when re-importing' do
      before { Bibliotheca::Collection::Languages.import_from_json! json }
      it { expect(Bibliotheca::Collection::Languages.count).to eq 1 }
    end
  end


end
