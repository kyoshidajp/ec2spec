require 'json'
require 'ec2spec/hash_formatter'

module Ec2spec
  module JsonFormatter
    include Ec2spec::HashFormatter

    def output(results, _hosts)
      super.to_json
    end
  end
end
