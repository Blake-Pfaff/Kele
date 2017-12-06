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
    response = self.class.post("/sessions", body: { email: email, password: password })
    # if you receive error code 404 display string
    raise 'YOU SHALL NOT PASS' if response.code == 404
    #returns JSON key called auth_token and assigns it to @auth_token
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get("/users/me", headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end
  # mentor ID 2299843
  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

end
