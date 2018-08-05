module Ec2spec
  class HostResult
    NA_VALUE = 'N/A'

    attr_accessor :host, :backend, :instance_id, :instance_type,
                  :memory, :cpu, :price_per_unit

    def initialize(host)
      @host = host
      @backend = nil
    end

    def na_values
      @instance_type = NA_VALUE
      @instance_id = NA_VALUE
      @memory = NA_VALUE
      @cpu = NA_VALUE
      @price_per_unit = NA_VALUE
    end

    def instance_type=(value)
      @instance_type = value

      return if value == NA_VALUE
      @offer_file = Ec2spec::OfferFile.new(value)
      price_per_unit
    end

    def price_per_unit
      @price_per_unit ||= @offer_file.price_per_unit
    end

    def price_per_month
      return NA_VALUE if @price_per_unit == NA_VALUE
      @price_per_unit * 24 * 31
    end
  end
end
