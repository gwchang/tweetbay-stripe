require 'rubygems'
require 'sinatra'
require 'oauth2'
require 'yaml'
require 'json'
require 'stripe'

class Server < Sinatra::Base

  configure do
    config = YAML::load(File.open('config.yml'))

    set :api_key, config['api_key']
    set :client_id, config['client_id']

    options = {
      :site => 'https://connect.stripe.com',
      :authorize_url => '/oauth/authorize',
      :token_url => '/oauth/token'
    }

    set :client, OAuth2::Client.new(settings.client_id, settings.api_key, options)
  end

  get '/' do
    erb :index
  end

  get '/authorize' do
    params = {
      :scope => 'read_write',
      #:redirect_uri => 'https://localhost:4567/oauth/callback'
    }

    # Redirect the user to the authorize_uri endpoint
    url = settings.client.auth_code.authorize_url(params)
    p url
    redirect url
  end

  get '/oauth/callback' do
    # Pull the authorization_code out of the response
    code = params[:code]
    p code

    # Make a request to the access_token_uri endpoint to get an access_token
    
    @resp = settings.client.auth_code.get_token(code, :params => {:scope => 'read_write'})
    @access_token = @resp.token

    # Use the access_token as you would a regular live-mode API key
    # TODO: Stripe logic
    Stripe.api_key = @access_token

    products = Stripe::Product.all
    p products

    charges = Stripe::Charge.all
    p charges

    erb :callback
  end
end

puts Dir.pwd
Dir.chdir(File.dirname(__FILE__))
Server.run!
