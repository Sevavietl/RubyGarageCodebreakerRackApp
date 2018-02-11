require 'rack/test'
require_relative 'app_mixin'

RSpec.describe 'Game process' do
  include Rack::Test::Methods
  include AppMixin

  let(:game) do
    {
      secret_code: '1234',
      hints: ['1', '4', '2', '3'],
      attempts_left: 7,
      status: :in_progress
    }
  end
  let(:session) { {'user' => 'John Dow', 'game' => game} }

  before { env('rack.session', session) }

  describe('GET "/" (get form)') do
    it('initiates a game') do
      get('/')
      
      expect(last_response.status).to be(200)
    end
  end

  describe('POST "/" (take a move)') do
    it('takes a guess') do
      post('/', { code: '1111' })

      expect(last_response.status).to be(302)
      expect(last_response.headers['Location']).to eq('/')
    end
    
    it('takes a correct guess') do
      post('/', { code: '1234' })
      
      expect(last_response.status).to be(200)
      expect(last_response.body).to include('You have won the game')
    end

    it('ends game after 7 incorrect attempts') do
      session['game'][:attempts_left] = 1
      
      post('/', { code: '1111' })
      
      expect(last_response.status).to be(200)
      expect(last_response.body).to include('You have lost the game')
    end
  end

  describe('GET "/hint" (take a hint)') do
    it('returns a hint') do
      get('/hint')

      expect(last_response.status).to be(200)
      expect(last_response.body).to match('1')
    end

    it('returns empty body when no hints left') do
      session['game'][:hints] = []

      get('/hint')

      expect(last_response.status).to be(200)
      expect(last_response.body).to match('')
    end

    it('returns empty body when no game in progress') do
      session.delete('game')

      get('/hint')

      expect(last_response.status).to be(200)
      expect(last_response.body).to match('')
    end
  end
end
