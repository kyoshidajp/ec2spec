require 'thor'

module Ec2spec
  class CLI < Thor
    desc 'ssh -h host1 ...', 'Compare the specifications of EC2 instances.'
    option 'host', aliases: 'h', type: :array, equired: true
    option 'days', type: :numeric
    option 'format'
    def ssh
      hosts = options['host']
      days = options['days']
      format = options['format'] || :plain_text
      client = Ec2spec::Client.new(hosts, days, format)
      client.run
    end
  end
end
