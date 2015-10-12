module Dedup
  module CoreExtensions
    module Array_extension
      def aggregate_by(key)
        hashable_array =
            self.group_by do |elem|
              elem[key]
            end.each_pair.map do |k, v|
              [k, v.map { |h| h.delete(key); h }]
            end
        Hash[hashable_array]
      end

      def contains_blank?
        self.blank? ||
            self.map do |value|
              if value.respond_to? :contains_blank?
                value.contains_blank? and break
              else
                value.blank? and break
              end
            end.nil?
      end
    end
  end
end