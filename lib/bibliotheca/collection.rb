module Bibliotheca::Collection
end

require 'mongo'
require 'json/ext'

require_relative './collection/database'
require_relative './collection/guides'
require_relative './collection/languages'
require_relative './collection/guide_not_found_error'
