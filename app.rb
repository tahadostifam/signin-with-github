require 'sinatra'
require 'rest-client'
require 'json'

# Your github application tokens 
# create new app:
# https://github.com/settings/applications/new
CLIENT_ID = ""
CLIENT_SECRET = ""

get '/' do 
  erb :index, :locals => { :client_id => CLIENT_ID }
end

get '/callback' do
    session_code = request.env['rack.request.query_hash']['code']

    result = RestClient.post('https://github.com/login/oauth/access_token',
                          {:client_id => CLIENT_ID,
                           :client_secret => CLIENT_SECRET,
                           :code => session_code},
                           :accept => :json)

    
    access_token = JSON.parse(result)['access_token']

    
    auth_result = RestClient.get("https://api.github.com/user", 
      {
        Authorization: "token #{access_token}"
      }
    )

    final_result = JSON.parse(auth_result)

    erb :logged_successfully, :locals => { :user => final_result }
end