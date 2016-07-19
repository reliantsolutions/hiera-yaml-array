require 'json'

# This file is basically a copy of the hiera Yaml backend, we just override the parse_string method to
# achieve our needs.
class Hiera
  module Backend

    class Yaml_array_backend
      VERSION = '1.0.0'

      def initialize(cache=nil)
        require 'yaml'

        Hiera.debug('Hiera YAML Array backend starting.')
        @cache = cache || Filecache.new
      end

      def lookup(key, scope, order_override, resolution_type, context)
        answer = nil
        found = false

        Backend.datasourcefiles(:yaml_array, scope, 'yaml', order_override) do |source, yamlfile|
          data = @cache.read_file(yamlfile, Hash) do |data|
            YAML.load(data) || {}
          end

          next if data.empty?
          next unless data.include?(key)
          found = true

          # Extra logging that we found the key. This can be outputted
          # multiple times if the resolution type is array or hash but that
          # should be expected as the logging will then tell the user ALL the
          # places where the key is found.
          Hiera.debug("Found #{key} in #{source}")

          # for array resolution we just append to the array whatever
          # we find, we then goes onto the next file and keep adding to
          # the array
          #
          # for priority searches we break after the first found data item
          new_answer = parse_answer(data[key], scope, {}, context)
          case resolution_type.is_a?(Hash) ? :hash : resolution_type
          when :array
            raise Exception, "Hiera type mismatch for key '#{key}': expected Array and got #{new_answer.class}" unless new_answer.kind_of? Array or new_answer.kind_of? String
            answer ||= []
            answer << new_answer
          when :hash
            raise Exception, "Hiera type mismatch for key '#{key}': expected Hash and got #{new_answer.class}" unless new_answer.kind_of? Hash
            answer ||= {}
            answer = Backend.merge_answer(new_answer, answer, resolution_type)
          else
            answer = new_answer
            break
          end
        end
        throw :no_such_key unless found
        puts answer.inspect
        answer
      end

      private

      def parse_answer(data, scope, extra_data, context)
        if data.is_a?(Numeric) or data.is_a?(TrueClass) or data.is_a?(FalseClass)
          return data
        elsif data.is_a?(String)
          return parse_string(data, scope, extra_data, context)
        elsif data.is_a?(Hash)
          answer = {}
          data.each_pair do |key, val|
            interpolated_key = parse_string(key, scope, extra_data, context)
            answer[interpolated_key] = parse_answer(val, scope, extra_data, context)
          end
        elsif data.is_a?(Array)
          answer = []
          data.each do |item|
            answer << parse_answer(item, scope, extra_data, context)
          end
        end
        answer
      end

      # The backend code is just these lines bellow, have fun.
      SINGLE_VARIABLE_REGEXP = /\A%\{([^\[\]]+)\}\z/
      SEEMS_A_ARRAY = /\A\[.+\]\z/

      def parse_string(data, scope, extra_data, context)
        value = Hiera::Interpolate.interpolate(data, scope, extra_data, context)
        value = JSON.parse(value) if data =~ SINGLE_VARIABLE_REGEXP && value =~ SEEMS_A_ARRAY
        value
      end
    end
  end
end
