require 'json'
require 'ec2spec/formatter/hash_formatter'

module Ec2spec
  module Formatter
    module JsonFormatter
      include Ec2spec::Formatter::HashFormatter

      def output(results, _hosts)
        super.to_json
      end
    end
  end
end
