module Ec2spec
  class OfferIndexFile
    REGION_INDEX_FILE_URL = 'https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonEC2/current/region_index.json'

    def initialize
      @offer_index_file_json = nil

      mkdir_project_dir
      offer_index_file_json
    end

    def offer_file_url(region)
      file_path = @offer_index_file_json['regions'][region]['currentVersionUrl']
      parsed_url = URI.parse(REGION_INDEX_FILE_URL)
      parsed_url.path = file_path
      parsed_url.to_s
    end

    private

    def project_dir
      File.join(ENV['HOME'], Const::PROJECT_DIR)
    end

    def mkdir_project_dir
      Dir.mkdir(project_dir) unless Dir.exist?(project_dir)
    end

    def region_index_file_path
      File.join(project_dir, REGION_INDEX_FILE_URL)
    end

    def offer_index_file_path
      file_name = File.basename(REGION_INDEX_FILE_URL)
      File.join(project_dir, file_name)
    end

    def offer_index_file_json
      download_region_index_file unless File.exist?(offer_index_file_path)
      @offer_index_file_json ||=
        JSON.parse(File.open(offer_index_file_path).read)
    end

    def download_region_index_file
      http_conn = Faraday.new do |builder|
        builder.adapter Faraday.default_adapter
      end
      response = http_conn.get(REGION_INDEX_FILE_URL)
      File.open(offer_index_file_path, 'wb') { |fp| fp.write(response.body) }
    end
  end
end
