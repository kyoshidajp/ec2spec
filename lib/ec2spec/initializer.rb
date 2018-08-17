require 'singleton'

module Ec2spec
  class Initializer
    include Singleton

    def do(region)
      mkdir_project_dir
      OfferFile.instance.prepare(region)
    end

    private

    def mkdir_project_dir
      return if Dir.exist?(Ec2spec.project_dir)

      Dir.mkdir(Ec2spec.project_dir)
      Ec2spec.logger.debug("Created project dir: #{Ec2spec.project_dir}")
    end
  end
end
