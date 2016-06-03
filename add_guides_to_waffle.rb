#!/usr/bin/env ruby

require 'rubygems'

gem 'octokit'
gem 'rest-client'

require 'rest-client'
require 'octokit'

access_token = ARGV[0]

['pdep-utn', 'sagrado-corazon-alcal', 'mumuki', 'arquitecturas-concurrentes', 'orga-unq', 'alcal', 'inpr-unq', 'inpr-sarmiento', 'pdp-unsam', 'wollok'].flat_map do |org|
  Octokit.repos(org).map(&:full_name).select { |it| it =~ /guia/ }
end.each do |slug|
  puts slug
  begin
    data = {
      private: false,
      repoPath: slug,
      type: 'github',
      provider: '5399ba229c4ef5963e000508'
    }

    RestClient.post "https://api.waffle.io/projects/574f20ffc73a6c140081ede8/sources", data, {:Authorization => "Bearer #{access_token}"}
    puts "Added!"
  rescue => e
    puts e.response
  end
end

