namespace :languages do
  task :import, :environment do |t, args|
    Mumukit::Bridge::Thesaurus.new.runners.each do |url|
      puts "Importing Language #{url}"
      begin
        Bibliotheca::Collection::Language.import! url
      rescue => e
        puts "Ignoring Language #{url} because of import error #{e}"
      end
    end
  end
end
