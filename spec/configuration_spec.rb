RSpec.describe Changefu::Configuration do
  before do
    allow(Changefu).to receive(:path_helper!).and_return(fixture_path('config.simple.yml'))
  end

  describe '.header' do
    it do
      expect(described_class.header).to be_eql('header example')
    end
  end

  describe '.inexistant' do
    it do
      expect {
        expect { described_class.inexistant }.to raise_error(SystemExit)
      }.to output(/directive/).to_stderr
    end
  end
end
