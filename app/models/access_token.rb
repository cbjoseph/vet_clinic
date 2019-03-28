require 'net/http'
require 'json'
require 'net/https'
require 'dotenv'

class AccessToken
  attr_accessor :access_token
  def initialize
    Dotenv.load
    @access_token = nil
  end
  def get_access_token
    begin
        uri = URI('https://api.trial.ezyvet.com/v1/oauth/access_token')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'x-www-form-urlencoded'})
        req.set_form_data(
          "partner_id" => ENV["partner_id"],
          "client_id" => ENV["client_id"],
          "client_secret" => ENV["client_secret"],
          "grant_type" => "client_credentials",
          "scope" => "read-animal, read-address")
        res = http.request(req)
        puts "response #{res.body}"
        body = JSON.parse(res.body)
        @access_token = body["access_token"]
    rescue => e
        puts "failed #{e}"
    end
  end

  def get_addresses
    uri = URI("https://api.ezyvet.com/v1/address")
    begin 
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri.path)
      req['Authorization'] = "Bearer #{@access_token}"
      resp = http.request(req) 
      puts "response #{resp.body}"
    rescue => e
      puts "failed #{e}"
    end
  end

  def get_animals
    uri = URI("https://api.ezyvet.com/v1/animal")
    begin 
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri.path)
      req['Authorization'] = "Bearer #{@access_token}"
      resp = http.request(req)
      JSON.parse(resp.body)
      # puts "response #{resp.body}"
    rescue => e
      puts "failed #{e}"
    end
  end
end