require 'rack/test'
require_relative 'app_mixin'

RSpec.describe 'Statistics' do
  include Rack::Test::Methods
  include AppMixin

  before(:all) do
    @data_dir = "#{ __dir__ }/data"
    CodebreakerRack::Models::Model.storage = CodebreakerRack::Storage::CSVStorage.new(@data_dir)
  end

  let(:session) { {'user' => 'John Dow'} }

  before(:each) do
    env('rack.session', session)
    File.new("#{@data_dir}/scores.csv", 'w').close()
  end

  after(:each) { File.delete("#{@data_dir}/scores.csv") }

  it('shows the table with scores statistics') do
    [
      ['John Dow', 1],
      ['Jane Doe', 0]
    ].each do |record| 
      CodebreakerRack::Models::Model.storage.add('scores', record)
    end

    get '/statistics'
    
    expect(last_response.status).to be(200)
    expect(last_response.body).to include('John Dow')
    expect(last_response.body).to include('Jane Doe')
  end
end
