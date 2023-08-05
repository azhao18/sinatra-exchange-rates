require "sinatra"
#require "sinatra/reloader"

require 'net/http'
require 'json'
#require_relative 'get_symbols' # assuming get_symbols method is in this file

def get_symbols
  uri = URI('https://api.exchangerate.host/symbols')
  response = Net::HTTP.get(uri)
  JSON.parse(response)["symbols"].keys
end

get '/' do
  @currencies = get_symbols
  erb :index
end
#get '/' do
##  redirect to('/USD')
#end

get '/:currency' do
  @base_currency = params['currency'].upcase
  @other_currencies = get_symbols - [@base_currency]
  erb :conversion
end

get '/:base_currency/:target_currency' do
  base_currency = params['base_currency'].upcase
  target_currency = params['target_currency'].upcase
  
  # Make API request to get conversion rate
  uri = URI("https://api.exchangerate.host/convert?from=#{base_currency}&to=#{target_currency}")
  response = Net::HTTP.get(uri)
  rate = JSON.parse(response)["result"]

  @conversion_text = "1 #{base_currency} equals #{rate} #{target_currency}"

  erb :convert
end
