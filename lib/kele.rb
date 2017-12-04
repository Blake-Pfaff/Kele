#make sure kele class has access to httparty
require 'httparty'
#make sure kele class has access to json
require 'json'

class Kele
  #includes the httparty libary class as a module, gives access to httparty methods like "post" think inheritance-ish
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'
  #called when "new" method is used.  Passes the email and PW in from the input
  def initialize(email, password)
    #self.class will envoke HTTPArty to use post method.  "sessions" is passed into the private method api_url and used as the end point.
    #this will return an auth token, wil send 404 if return page does not exist
    response = self.class.post(api_url("sessions"), body: { email: email, password: password })
    # if you receive error code 404 display string
    raise 'YOU SHALL NOT PASS' if response.code == 404
    #returns JSON key called auth_token and assigns it to @auth_token
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(me_url, headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  private

    def me_url
      "https://www.bloc.io/api/v1/users/me"
    end

    #sets the api_url used in init method
    def api_url(endpoint)
      "https://www.bloc.io/api/v1/#{endpoint}"
    end
end
