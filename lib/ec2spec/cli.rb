require 'thor'

module Ec2spec
  class CLI < Thor
    desc 'ssh host ...', ''
    option 'host', aliases: 'h', type: :array, equired: true
    option 'days', type: :numeric
    def ssh
      hosts = options['host']
      days = options['days']
      client = Ec2spec::Client.new(hosts, days)
      client.run
    end
  end
end
