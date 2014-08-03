# encoding: UTF-8

require 'java'
require 'json'
require 'rosette/core'
require 'commonjs-rhino'
require 'rosette/extractors/coffeescript-extractor/javascript_helpers'

module Rosette
  module Extractors

    class CoffeescriptExtractor < Rosette::Core::Extractor
      protected

      IMPORTANT_KEYS = [
        'expressions', 'properties', 'objects', 'params',
        'boundFuncs', 'value', 'base', 'body'
      ]

      DEFAULT_HASH = {}.freeze

      def each_function_call(coffeescript_code)
        if block_given?
          root = parse(coffeescript_code)
          walk(root) do |node|
            if node.include?('args')
              yield node
            end
          end
        else
          to_enum(__method__, coffeescript_code)
        end
      end

      def valid_args?(node)
        if arg = node['args'].first
          if arg.is_a?(Java::OrgMozillaJavascript::NativeObject)
            value = arg.fetch('base', DEFAULT_HASH).fetch('value', nil)
            if value.is_a?(Java::OrgMozillaJavascript::ConsString)
              return true
            end
          end
        end
        false
      end

      def get_key(node)
        val = node['args'].first['base']['value']
        JSON.parse("[#{val.toString}]").first
      end

      def walk(root)
        if block_given?
          case root
            when Java::OrgMozillaJavascript::NativeArray
              root.each do |node|
                walk(node) { |child| yield child }
              end
            when Java::OrgMozillaJavascript::NativeObject
              yield root
              IMPORTANT_KEYS.each do |key|
                walk(root[key]) { |child| yield child }
              end
          end
        else
          to_enum(__method__, root)
        end
      end

      def parse(coffeescript_code)
        parser_context.eval(
          "coffee.nodes('#{JavaScriptHelpers.escape_javascript(coffeescript_code)}');"
        )
      end

      def parser_context
        @parser_context ||= begin
          ctx = CommonjsRhino.create_context([
            File.expand_path('../../../../vendor', __FILE__),
            File.expand_path('../../../../vendor/coffee-script', __FILE__)
          ])

          ctx.eval("var coffee = require('coffee-script/coffee-script');")
          ctx
        end
      end

      class UnderscoreExtractor < CoffeescriptExtractor
        protected

        def valid_name?(node)
          func_name = node
            .fetch('variable', DEFAULT_HASH)
            .fetch('base', DEFAULT_HASH)
            .fetch('value', nil)

          func_name == '_'
        end
      end
    end

  end
end
