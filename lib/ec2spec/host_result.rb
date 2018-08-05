module Ec2spec

  class HostResult
    attr_reader :host, :backend, :instance_type, :memory, :cpu, :price_per_unit

    def initialize(host)
      @host = host
    end

    def backend=(value)
      @backend = value
    end

    def instance_type=(value)
      @instance_type = value

      @offer_file = Ec2spec::OfferFile.new(value)
      price_per_unit
    end

    def memory=(value)
      @memory = value
    end

    def cpu=(value)
      @cpu = value
    end

    def price_per_unit
      @price_per_unit ||= @offer_file.price_per_unit
    end

    def price_per_month
      @price_per_unit * 24 * 31
    end
  end
end