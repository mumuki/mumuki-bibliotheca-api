namespace :languages do
  task :import do |t, args|
    Mumukit::Bridge::Thesaurus.new(ENV['MUMUKI_THESAURUS_URL'] || 'http://thesaurus.mumuki.io').runners.each do |url|
      puts "Importing Language #{url}"
      begin
        Bibliotheca::Collection::Languages.import! url
      rescue => e
        puts "Ignoring Language #{url} because of import error #{e}"
      end
    end
  end
end
