module Dedup
  module CoreExtensions
    module String_extension

      def strftime(fmt)
        Time.zone.parse(self).try(:strftime, fmt) or ""
      rescue ArgumentError => e
        ""
      end

      def utf8_strip
        dup.utf8_strip!
      end

      def utf8_strip!
        gsub!(/(\A[\u00a0\s\u3000]+|[\u00a0\s\u3000]+\Z)/, "") or self
      end

      def remove_utf_8_char_can_not_parse_to_gbk_char
        str = self.clone
        invalid_space_charset = ["\u00a0"]
        invalid_charset = str.each_char.map do |c|
          begin
            c.encode('GBK')
            nil
          rescue => e
            c
          end
        end.compact.uniq - invalid_space_charset

        invalid_charset_regexp =
            Regexp.new(invalid_charset.map {|c| Regexp.escape(c) }.join('|'))

        invalid_space_charset_regexp =
            Regexp.new(invalid_space_charset.map {|c| Regexp.escape(c) }.join('|'))

        str.gsub!(invalid_charset_regexp, '')
        str.gsub!(invalid_space_charset_regexp, ' ')
        str
      end

    end
  end
end