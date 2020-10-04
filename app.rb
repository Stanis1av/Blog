require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb 'Welcome user! '
end

get '/new' do
  erb :new
end

post '/new' do
  @content = params[:content]
  erb :new
end


