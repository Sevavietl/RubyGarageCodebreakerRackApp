RSpec.describe CodebreakerRack::Models::Score do
  subject { described_class.new }

  before(:all) do
    @data_dir = "#{ __dir__ }/data"
    CodebreakerRack::Models::Model.storage = CodebreakerRack::Storage::CSVStorage.new(@data_dir)
  end

  before(:each) { File.new("#{@data_dir}/scores.csv", 'w').close() }
  after(:each) { File.delete("#{@data_dir}/scores.csv") }

  describe('#find') do
    before(:each) do
      [
        ['John Dow', 1],
        ['Jane Doe', 0]
      ].each do |record| 
        CodebreakerRack::Models::Model.storage.add('scores', record)
      end
    end

    it('finds score by id (name)') do
      score1 = described_class.find('John Dow')
      score2 = described_class.find('Jane Doe')

      expect(score1.name).to match('John Dow')
      expect(score1.points).to match('1')

      expect(score2.name).to match('Jane Doe')
      expect(score2.points).to match('0')
    end

    it('returns nil on not found id') do
      expect(described_class.find('Louie Anderson')).to be_nil
    end
  end

  describe('#all') do
    it('returns list of all records') do
      records = [
        ['John Dow', '1'],
        ['Jane Doe', '0']
      ]
      
      records.each do |record| 
        CodebreakerRack::Models::Model.storage.add('scores', record)
      end

      models = described_class.all

      models.each { |model| expect(model).to be_a(described_class) }
      expect(models.shift.to_ary).to match_array(records.shift)
      expect(models.shift.to_ary).to match_array(records.shift)
    end

    it('returns empty array when there are no records found') do
      expect(described_class.all).to match_array([])
    end
  end

  describe('#save') do
    before(:each) do
      [
        ['John Dow', 1],
        ['Jane Doe', 0]
      ].each do |record| 
        CodebreakerRack::Models::Model.storage.add('scores', record)
      end
    end

    it('creates a new record') do
      score = described_class.new
      score.name = 'Louie Anderson'
      score.points = 3
      score.save

      expect(described_class.all.length).to be(3)
      expect(described_class.find('Louie Anderson')).not_to be_nil
    end
    
    it('updates existing record') do
      score = described_class.find('Jane Doe')
      score.points = 3
      score.save

      expect(described_class.all.length).to be(2)
      expect(described_class.find('Jane Doe').points).to match('3')
    end
  end
end
