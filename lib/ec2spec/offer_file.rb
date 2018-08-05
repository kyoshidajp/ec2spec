require 'json'
require 'faraday'

module Ec2spec
  class OfferFile
    OFFER_FILE_URL  = 'https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonEC2/20180802021534/ap-northeast-1/index.json'
    OFFER_FILE_NAME = 'price_list.json'
    OFFER_FILE_DIR  = '.ec2spec'

    def initialize(instance_type)
      @instance_type = instance_type
      @offer_file_json = nil
    end

    def price_per_unit
      sku_instance_type = sku
      on_demand = offer_file_json['terms']['OnDemand']
      sku_value = on_demand[sku_instance_type].first[1]
      price_dimensions = sku_value['priceDimensions']
      price_dimensions.first[1]['pricePerUnit']['USD'].to_f
    end

    private

    def offer_file_json
      download unless File.exist?(offer_file_path)
      @offer_file_json ||= JSON.parse(File.open(offer_file_path).read)
    end

    def offer_file_path
      price_list_dir = File.join(ENV['HOME'], OFFER_FILE_DIR)
      Dir.mkdir(price_list_dir) unless Dir.exist?(price_list_dir)
      File.join(price_list_dir, OFFER_FILE_NAME)
    end

    def download
      http_conn = Faraday.new do |builder|
        builder.adapter Faraday.default_adapter
      end
      response = http_conn.get(OFFER_FILE_URL)
      File.open(offer_file_path, 'wb') { |fp| fp.write(response.body) }
    end

    def sku
      products = offer_file_json['products']
      target_product = products.find do |product|
        product?(product, @instance_type)
      end
      target_product[1]['sku']
    end

    def product?(product, instance_type)
      attributes = product[1]['attributes']
      attributes['instanceType'] == instance_type &&
        attributes['operatingSystem'] == 'Linux' &&
        attributes['preInstalledSw'] == 'NA'
    end
  end
end
