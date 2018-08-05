module Ec2spec
  class HostResult
    attr_accessor :host, :backend, :instance_id, :instance_type,
                  :memory, :cpu, :price_per_unit

    def initialize(host)
      @host = host
      @backend = nil
      @instance_id = nil
      @memory = nil
      @cpu = nil
    end

    def instance_type=(value)
      @instance_type = value

      @offer_file = Ec2spec::OfferFile.new(value)
      price_per_unit
    end

    def price_per_unit
      @price_per_unit ||= @offer_file.price_per_unit
    end

    def price_per_month
      @price_per_unit * 24 * 31
    end
  end
end
