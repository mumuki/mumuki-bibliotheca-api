namespace :guides do
  task :import, [:organization, :url] => :environment do |t, args|
    args.with_defaults(url: 'http://localhost:9292')

    puts "importing guides from organization #{args[:organization]} into #{args[:url]}"

    Octokit.repos(org).map(&:full_name).select { |it| it =~ /guia/ }.each do |slug|
      puts "importing guide #{slug}...."
      begin
        RestClient.post "#{url}/guides/import/#{slug}", {}
      rescue => e
        puts "import failed! #{e.response}"
      end
    end
  end
end





