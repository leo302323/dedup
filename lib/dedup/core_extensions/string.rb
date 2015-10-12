module Dedup
  module CoreExtensions
    module String_extension


      def utf8_strip
        dup.utf8_strip!
      end

      def utf8_strip!
        gsub!(/(\A[\u00a0\s\u3000]+|[\u00a0\s\u3000]+\Z)/, "") or self
      end

    end
  end
end