require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'sinatra/activerecord'

set :database, {adapter: "sqlite3", database: "blog.db"}

class Post < ActiveRecord::Base
    has_many :comments
end

class Comment < ActiveRecord::Base
end


# configure do
#   init_db
#   @db.execute 'CREATE TABLE if not exists Posts
#   (
#     id INTEGER,
#     name_autor TEXT,
#     created_date DATE,
#     content TEXT,
#     PRIMARY KEY(id AUTOINCREMENT)
#   );'

#   @db.execute 'CREATE TABLE if not exists Comments
#   (
#     id INTEGER PRIMARY KEY AUTOINCREMENT,
#     created_date DATE,
#     content TEXT,
#     post_id integer
#   );'
# end
get '/' do
  @result = Post.order('created_at DESC')
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  p = Post.new params[:post]
  p.save
  erb :new
  # @content = params[:content]
  # @name_autor = params[:name_autor]

  # if @content.length < 1
  #   @error = 'Type post text'
  #   return erb :new
  # end

  # @db.execute 'insert into Posts (name_autor, content, created_date) values (?, ?, datetime())', [@name_autor, @content]

  # # Перенаправление на главную страницу
  # redirect to '/'
end

get '/details/:id' do
  # Получаю переменную из URL,ф
  #post_id = params[:post_id]
  # Получаю список постов
  # у нас  только 1 пост
  # results = @db.execute 'select * from Posts where id = ?', [post_id]
  # Выбираю этот 1 пост в переменную @row
  # @row = results[0]
  # Выбираем комментарии для моего поста
  # @comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]
  # Возвращаю пердставление details.erb
  @results = Post.find(params[:id])

  @comments = Comment.order('created_at DESC')

  erb :details
end

# Обработчик post запроса /details/...
# (браузер отправляет данные на сервер, мы их принимаем)
post '/details/:id' do

  c = Comment.new params[:comment]
  c.save
  @results = Post.find(params[:id])

  #   post_id = params[:post_id]
  #   content = params[:content]

  #   # if content.length < 1
  #   #   @error = 'Type text comment'
  #   #   return erb :index
  #   # end
  #     @db.execute 'insert into Comments
  #     (
  #       content,
  #       created_date,
  #       post_id
  #     )
  #       values
  #     (
  #       ?,
  #       datetime(),
  #       ?
  #     )', [content, post_id]


  # # Перенаправление на главную страницу
  redirect to ('/details/' + @results[id])
end

