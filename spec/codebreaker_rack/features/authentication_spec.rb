require 'rack/test'
require_relative 'app_mixin'

RSpec.describe 'Login/Logout process' do
  include Rack::Test::Methods
  include AppMixin

  let(:user) { 'John Dow' }

  describe('Login') do
    it('redirects to login when not authenticated') do
      get '/'
      
      expect(last_response.status).to be(302)
      expect(last_response.headers['Location']).to eq('/login')
    end
    
    it('does not redirects when not authenticated and goes to login') do
      get '/login'

      expect(last_response.status).to be(200)
    end

    it('does not redirect logged in users') do
      env "rack.session", {'user' => user}

      get '/'
      
      expect(last_response.status).to be(200)
    end

    it('logs user in') do
      post('/login', {
        name: 'codebreaker'
      })

      expect(last_response.status).to be(302)
      expect(last_response.headers['Location']).to eq('/')
    end
  end

  describe('Logout') do
    it('logges user out and redirect to login page') do
      env "rack.session", {'user' => user}

      get '/logout'
      
      expect(last_response.status).to be(302)
      expect(last_response.headers['Location']).to eq('/login')
    end
  end
end
