module Dedup
  module Dedupable
    extend ActiveSupport::Concern

    included do
      class << self
        # 根据参数判断是否重复
        def has_dup?(params, &block)
          params = {origin_date: Time.zone.now}.merge(params)
          self.new(params).has_dup?(&block)
        end

        # 根据参数使用 batch 算法查询文章的重复报告
        def duplication_reports(params, &block)
          params = {origin_date: Time.zone.now}.merge(params)
          self.new(params).duplication_reports(:batch, &block)
        end
      end

      # 自动去重判断是否有重复文章
      def has_dup?(&block)
        duplication_reports(:auto, &block).present?
      end

      # 根据不同的算法查询文章的重复报告
      def duplication_reports(type, &block)
        @dedup_algorithm = Dedup::Algorithm.new(self, Settings.dedup_algrithms[type])
        similar_results(&block).map(&@dedup_algorithm.method(:report)).select(&@dedup_algorithm.method(:is_dup?))
      end

    private

      # 找到相似分数最高的 20 条, 不对其进行判断筛选
      def similar_results(size=20)
        @__searcher__ = self.class.searcher
        yield @__searcher__ if block_given?
        @dedup_algorithm ||= Dedup::Algorithm.new(self, score_lower_bound: 200)
        query_results size
      end

      # 一次查询分数都超过了分数线则扩大范围再查一次
      def query_results(size)
        results = @__searcher__.search(per: size, &@dedup_algorithm.method(:setup_elasticsearch_query)).results
        @dedup_algorithm.enough?(results, size) or query_results(size + 10)
      end
    end
  end
end
