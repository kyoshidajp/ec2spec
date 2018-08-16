require 'json'

module Ec2spec
  module SlackFormatter
    include Ec2spec::PlainTextFormatter

    def output(results, _hosts)
      "```\n#{super}\n```"
    end
  end
end
