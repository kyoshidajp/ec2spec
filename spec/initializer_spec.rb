require 'fileutils'

RSpec.describe Ec2spec::Initializer do
  describe '.do' do
    let(:temp_dir) { './tmp' }
    before do
      FileUtils.rm_rf Ec2spec.project_dir
      FileUtils.mkdir_p temp_dir
      allow(ENV).to receive(:[]).with('HOME').and_return(temp_dir)
      allow_any_instance_of(Ec2spec::OfferFile)
        .to receive(:prepare).and_return(nil)
      Ec2spec::Initializer.instance.do('ap-north-east1')
    end

    it 'makes project dir' do
      expect(File).to exist Ec2spec.project_dir
    end

    after do
      FileUtils.rm_rf Ec2spec.project_dir
    end
  end
end
