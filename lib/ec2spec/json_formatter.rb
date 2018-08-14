require 'json'

module Ec2spec
  module JsonFormatter
    def output(results, _hosts)
      result_hash = results.each_with_object({}) do |result, hash|
        hash[result.host] = result.to_hash
      end
      result_hash.to_json
    end
  end
end