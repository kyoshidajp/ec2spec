require 'thor'

module Ec2spec
  class CLI < Thor
    desc 'ssh host ...', ''
    option 'host', aliases: 'h', type: :array, equired: true
    def ssh
      hosts = options['host']
      client = Ec2spec::Client.new(hosts)
      client.run
    end
  end
end
