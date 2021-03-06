require 'faraday'
require 'json'
require 'specinfra'
require 'terminal-table'
require 'ec2spec/cli'
require 'ec2spec/client'
require 'ec2spec/const'
require 'ec2spec/formatter'
require 'ec2spec/initializer'
require 'ec2spec/version'
require 'ec2spec/host_result'
require 'ec2spec/logger'
require 'ec2spec/offer_file'
require 'ec2spec/offer_index_file'
require 'ec2spec/price_calculator'

module Ec2spec
  def self.project_dir
    File.join(ENV['HOME'], Const::PROJECT_DIR)
  end
end
