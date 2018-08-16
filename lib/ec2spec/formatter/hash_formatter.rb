require 'json'

module Ec2spec
  module Formatter
    module HashFormatter
      def output(results, _hosts)
        results.each_with_object({}) do |result, hash|
          hash[result.host] = result.to_hash
        end
      end
    end
  end
end
