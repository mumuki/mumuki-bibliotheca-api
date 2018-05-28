namespace :content do
  task :import do
    bridge = Mumukit::Platform.bibliotheca_bridge
    bridge.import_contents! do |resource_type, slug|
      resource = bridge.send(resource_type, slug)

      Bibliotheca::Collection.insert_hash! resource_type, resource
    end
  end
end