require 'json'

module Ec2spec
  module JsonFormatter
    def output(results, _hosts)
      results = results.map(&:value)
      result_hash = results.each_with_object({}) do |result, hash|
        host = result.host
        values = host_values(result)
        hash[host] = values
      end
      result_hash.to_json
    end

    def host_values(result)
      Ec2spec::Client::TABLE_LABEL_WITH_METHODS.each_with_object({}) do |(k, v), hash|
        hash[k] = result.public_send(v)
      end
    end
  end
end