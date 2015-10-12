module Dedup
  module CoreExtensions
    module Hash_extension

      def contains_blank?
        self.blank? || self.values.contains_blank?
      end

      def find_by_key(key)
        rslt = []
        queue = [self]
        while queue.size > 0
          queue.pop.each_pair do |k, v|
            rslt << v if key == k
            queue << v if v.class == Hash
          end
        end
        rslt
      end
    end
  end
end