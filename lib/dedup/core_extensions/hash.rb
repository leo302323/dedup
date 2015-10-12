module Dedup
  module CoreExtensions
    module Hash_extension

      def contains_blank?
        self.blank? || self.values.contains_blank?
      end

    end
  end
end