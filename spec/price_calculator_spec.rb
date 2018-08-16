RSpec.describe Ec2spec::PriceCalculator do
  describe '.prepare' do
    it 'accepts api calc type' do
      expect(Ec2spec::PriceCalculator.instance.prepare('JPY', 110, 'api', 'app-id'))
        .to be_an_instance_of Ec2spec::PriceCalculator
    end
    it 'accepts manual calc type' do
      expect(Ec2spec::PriceCalculator.instance.prepare('JPY', 110, 'manual'))
        .to be_an_instance_of Ec2spec::PriceCalculator
    end
    it 'does not accept illegal calc type' do
      expect do
        Ec2spec::PriceCalculator
          .instance.prepare('JPY', 110, 'illegal')
      end.to raise_error Ec2spec::UndefinedCalcError
    end
    it 'has api calc type but does not have app id' do
      expect do
        Ec2spec::PriceCalculator
          .instance.prepare('JPY', 110, 'api')
      end.to raise_error Ec2spec::ApiKeyError
    end
  end

  describe '.currency_values?' do
    subject { Ec2spec::PriceCalculator.instance.currency_values? }
    context 'having both @currency_unit and @dollar_exchange_rate' do
      before { Ec2spec::PriceCalculator.instance.prepare('JPY', 110, 'manual') }
      it { is_expected.to be_truthy }
    end
    context 'having only @currency_unit' do
      before { Ec2spec::PriceCalculator.instance.prepare('JPY', nil, 'manual') }
      it { is_expected.to be_falsey }
    end
    context 'having only @dollar_exchange_rate' do
      before { Ec2spec::PriceCalculator.instance.prepare(nil, 110, 'manual') }
      it { is_expected.to be_falsey }
    end
    context 'having neither @currency_unit nor @dollar_exchange_rate' do
      before { Ec2spec::PriceCalculator.instance.prepare(nil, nil, 'manual') }
      it { is_expected.to be_falsey }
    end
  end
end
