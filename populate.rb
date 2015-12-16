#!/usr/bin/env ruby

require 'rubygems'
#require 'bundler/setup'

gem 'octokit'
gem 'rest-client'

require 'rest-client'
require 'octokit'


['pdep-utn', 'sagrado-corazon-alcal', 'mumuki', 'arquitecturas-concurrentes'].flat_map do |org|
  Octokit.repos(org).map(&:full_name).select { |it| it =~ /guia/ }
end.each do |slug|
  puts slug 
  begin
    RestClient.post "http://bibliotheca.mumuki.io/guides/import/#{slug}", {}
  rescue => e
    puts e.response
  end
end

