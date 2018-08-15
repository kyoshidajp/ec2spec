require 'singleton'

module Ec2spec
  class OfferFile
    include Singleton

    OFFER_FILE_NAME = 'price_list.json'

    def prepare(region)
      @region = region

      if File.exist?(offer_file_path)
        Ec2spec.logger.debug('Read from cached offer file')
      else
        Ec2spec.logger.info('Downloading: offer file')
        download
        Ec2spec.logger.info("Downloaded: offer file (#{offer_file_path})")
      end
    end

    def products
      offer_file_json['products']
    end

    def vcpu(instance_type)
      sku_instance_type = sku(instance_type)
      product = products[sku_instance_type]['attributes']
      product['vcpu']
    end

    def memory(instance_type)
      sku_instance_type = sku(instance_type)
      product = products[sku_instance_type]['attributes']
      product['memory']
    end

    def price_per_unit(instance_type)
      sku_instance_type = sku(instance_type)
      on_demand = offer_file_json['terms']['OnDemand']
      sku_value = on_demand[sku_instance_type].first[1]
      price_dimensions = sku_value['priceDimensions']
      price_dimensions.first[1]['pricePerUnit']['USD'].to_f
    end

    private

    def download
      http_conn = Faraday.new do |builder|
        builder.adapter Faraday.default_adapter
      end

      offer_file_url = OfferIndexFile.instance.offer_file_url(@region)
      response = http_conn.get(offer_file_url)
      File.open(offer_file_path, 'wb') { |fp| fp.write(response.body) }
    end

    def offer_file_path
      price_list_dir = File.join(ENV['HOME'], Const::PROJECT_DIR)
      Dir.mkdir(price_list_dir) unless Dir.exist?(price_list_dir)
      File.join(price_list_dir, OFFER_FILE_NAME)
    end

    def offer_file_json
      @offer_file_json ||= JSON.parse(File.open(offer_file_path).read)
    end

    def sku(instance_type)
      target_product = products.find do |product|
        product?(product, instance_type)
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
