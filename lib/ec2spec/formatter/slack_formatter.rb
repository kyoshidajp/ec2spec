require 'json'

module Ec2spec
  module Formatter
    module SlackFormatter
      include Ec2spec::Formatter::PlainTextFormatter

      def output(results, _hosts)
        "```\n#{super}\n```"
      end
    end
  end
end
