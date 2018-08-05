require 'thor'

module Ec2spec
  class CLI < Thor
    desc 'ec2spec host1', 'red words print.'
    def ec2spec(*hosts)
      client = Ec2spec::Client.new(hosts)
      client.run
    end
  end
end
