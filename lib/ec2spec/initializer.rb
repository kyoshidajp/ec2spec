require 'singleton'

module Ec2spec
  class Initializer
    include Singleton

    def do(region)
      mkdir_project_dir
      OfferFile.instance.prepare(region)
    end

    private

    def project_dir
      File.join(ENV['HOME'], Const::PROJECT_DIR)
    end

    def mkdir_project_dir
      return if Dir.exist?(project_dir)

      Dir.mkdir(project_dir)
      Ec2spec.logger.debug("Created project dir: #{project_dir}")
    end
  end
end
