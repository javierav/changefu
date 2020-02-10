RSpec.describe Changefu::Change do
  let(:file) { fixture_path('20200211000930_a_change_for_test.yml') }
  let(:change) { described_class.from_file(file) }

  before do
    allow(Changefu).to receive(:path_helper!).and_return(fixture_path('config.simple.yml'))
  end

  describe '.from_file' do
    it 'return Change object from file' do
      expect(change.title).to be_eql 'A change for test'
      expect(change.type).to be_eql 'changed'
      expect(change.username).to be_eql 'javierav'
      expect(change.issue).to be_eql 1100
      expect(change.path).to be_eql file
      expect(change.timestamp).to be_eql '20200211000930'
    end
  end

  describe '#issue_to_markdown' do
    context 'when issue_url has value' do
      it do
        url = '[#1100](https://github.com/username/project/issues/1100)'
        expect(change.issue_to_markdown).to be_eql(url)
      end
    end

    context 'when issue_url is nil' do
      before do
        allow(Changefu::Configuration).to receive(:issue_url).and_return(nil)
      end

      it do
        expect(change.issue_to_markdown).to be_eql(nil)
      end
    end
  end

  describe '#username_to_markdown' do
    context 'when username_url has value' do
      it do
        url = '([javierav](https://github.com/javierav))'
        expect(change.username_to_markdown).to be_eql(url)
      end
    end

    context 'when username_url is nil' do
      before do
        allow(Changefu::Configuration).to receive(:username_url).and_return(nil)
      end

      it do
        expect(change.username_to_markdown).to be_eql(nil)
      end
    end
  end

  describe '#to_hash' do
    it 'convert change object to hash' do
      expect(change.to_hash).to include(
        title: change.title, username: change.username, issue: change.issue
      )
    end
  end
end
