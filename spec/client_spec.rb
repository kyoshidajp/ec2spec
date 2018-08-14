RSpec.describe Ec2spec::Client do
  describe '.initialize' do
    it 'accepts plain text format' do
      expect(Ec2spec::Client.new(['host1'], 30, 'plain_text'))
        .to be_an_instance_of Ec2spec::Client
    end
    it 'accepts json format' do
      expect(Ec2spec::Client.new(['host1'], 30, 'json'))
        .to be_an_instance_of Ec2spec::Client
    end
    it 'accepts hash format' do
      expect(Ec2spec::Client.new(['host1'], 30, 'hash'))
        .to be_an_instance_of Ec2spec::Client
    end
    it 'does not accept other format' do
      expect { Ec2spec::Client.new(['host1'], 30, 'xml') }
        .to raise_error Ec2spec::UndefineFormatterError
    end
    it 'does not accept illegal format' do
      expect { Ec2spec::Client.new(['host1'], 30, 100) }
        .to raise_error Ec2spec::UndefineFormatterError
    end
  end
end
