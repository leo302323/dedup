require 'active_support'
require "dedup/version"
require "dedup/dedupable"
require "dedup/algorithm"
require 'dedup/elasticsearchable'
require 'dedup/core_extensions'

module Dedup
  # Your code goes here...
  include Dedup::CoreExtensions
end
