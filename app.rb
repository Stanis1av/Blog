require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'blog.db'
  @db.results_as_hash = true
end

before do
  init_db
end

configure do
  init_db
  @db.execute 'CREATE TABLE if not exists Posts
  (
    id INTEGER,
    created_date  TEXT,
    content TEXT,
    PRIMARY KEY(id AUTOINCREMENT)
  );'
end
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


