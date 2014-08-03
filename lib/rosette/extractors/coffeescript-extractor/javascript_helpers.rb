# encoding: UTF-8

module Rosette
  module Extractors

    # taken from actionview
    class JavaScriptHelpers
      JS_ESCAPE_MAP = {
        '\\'    => '\\\\',
        '</'    => '<\/',
        "\r\n"  => '\n',
        "\n"    => '\n',
        "\r"    => '\n',
        '"'     => '\\"',
        "'"     => "\\'"
      }

      JS_ESCAPE_MAP["\342\200\250".force_encoding(Encoding::UTF_8).encode!] = '&#x2028;'
      JS_ESCAPE_MAP["\342\200\251".force_encoding(Encoding::UTF_8).encode!] = '&#x2029;'

      def self.escape_javascript(javascript)
        if javascript
          javascript.gsub(/(\\|<\/|\r\n|\342\200\250|\342\200\251|[\n\r"'])/u) { |match| JS_ESCAPE_MAP[match] }
        else
          ''
        end
      end
    end

  end
end