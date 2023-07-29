require "sinatra"
require "sinatra/reloader"

require 'net/http'
require 'json'
require_relative 'get_symbols' # assuming get_symbols method is in this file

def get_symbols
  uri = URI('https://api.exchangerate.host/symbols')
  response = Net::HTTP.get(uri)
  JSON.parse(response)["symbols"].keys
end

get("/") do
  "
  <h1>Currency pairs</h1>
  <p>Define some routes in app.rb</p>
  "
  @currencies = get_symbols
  erb :index
end
