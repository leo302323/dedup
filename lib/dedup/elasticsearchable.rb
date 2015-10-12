module Dedup
  module Elasticsearchable
    extend ActiveSupport::Concern

    included do
      class << self
        def searcher
          BasicSearcher.new(self)
        end
      end


    end

    class BasicSearcher

      def initialize(target_class)
        @target_class = target_class
        reset!
      end

      # 封装查询 ES 的逻辑
      def search(page: 1, per: 20)
        yield self if block_given?
        @target_class.search(query).page(page).per(per)
      end

      def query
        {
          _source: @source,
          sort: @sort,
          query: {
            filtered: {
              filter: {
                bool: {
                  must: @must_filters,
                  must_not: @must_not_filters
                }
              },
              query: {
                bool: {
                  should: @should_filters
                }
              }
            }
          }
        }
      end

      def source(bool)
        @source = bool
      end

      def sort(field, order)
        [field, order].contains_blank? or @sort = {field => {order: order}}; self
      end

      %w[should must must_not].each do |action|
        define_method action do |type, query|
          [type, query].contains_blank? or self.send("#{action}_filters") << {type => query}; self
        end
      end

      def reset!
        @should_filters, @must_filters, @must_not_filters = [], [], []
        @sort = {}
        @source = true
      end

    private

      attr_reader :should_filters, :must_filters, :must_not_filters
    end
  end
end
