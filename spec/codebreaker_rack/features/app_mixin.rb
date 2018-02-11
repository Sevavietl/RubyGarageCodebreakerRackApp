require "codebreaker_rack"

module AppMixin
  def app
    Rack::Builder.new do
      use Rack::Session::Cookie, :key => 'rack.session', :secret => 'abigsecretforalittlecompany'
      use CodebreakerRack::Middleware::Auth
      use CodebreakerRack::Middleware::Router do
        get '/', 'CodebreakerRack::Controllers::GameController@getAction'
        post '/', 'CodebreakerRack::Controllers::GameController@postAction'
        get '/hint', 'CodebreakerRack::Controllers::HintController@getAction'

        get '/login', 'CodebreakerRack::Controllers::LoginController@getAction'
        post '/login', 'CodebreakerRack::Controllers::LoginController@postAction'

        get '/logout', 'CodebreakerRack::Controllers::LogoutController@getAction'
        
        get '/statistics', 'CodebreakerRack::Controllers::StatisticController@getAction'
      end
        
      run CodebreakerRack::CodebreakerRackApp
    end
  end
end
