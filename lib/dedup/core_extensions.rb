require 'dedup/core_extensions/array_ext'
require 'dedup/core_extensions/hash'
require 'dedup/core_extensions/string'

module Dedup
  module CoreExtensions
    extend ActiveSupport::Concern
    included do
      Hash.include Hash_extension
      Array.include Array_extension
      String.include String_extension
    end
  end
end