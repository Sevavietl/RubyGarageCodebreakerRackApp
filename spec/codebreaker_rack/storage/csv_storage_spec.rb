RSpec.describe CodebreakerRack::Storage::CSVStorage do
  let(:data_dir) { "#{ __dir__ }/data" }
  subject { described_class.new(data_dir) }

  before(:each) { File.new("#{data_dir}/fruits.csv", 'w').close() }
  after(:each) { File.delete("#{data_dir}/fruits.csv") }

  describe('#add') do
    it('adds new records to storage') do
      fruits = [
        ['apple'],
        ['orange'],
        ['banana']
      ]

      fruits.each { |fruit| subject.add('fruits', fruit) }

      expect(subject.all('fruits')).to match_array(fruits)
    end
  end

  describe('#update') do
    it('updates existing record') do
      subject.add('fruits', ['apple', 1])
      subject.update('fruits', ['apple', 3])

      expect(subject.all('fruits')).to match_array([['apple', '3']])
    end
  end

  describe('#find') do
    before(:each) { subject.add('fruits', ['apple', 1]) }

    it('returns first recrod with given id (first column)') do
      expect(subject.find('fruits', 'apple')).to match_array(['apple', '1'])
    end

    it('returns nil on not found id') do
      expect(subject.find('fruits', 'banana')).to be_nil
    end
  end
end
