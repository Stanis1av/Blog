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
    name_autor TEXT,
    created_date DATE,
    content TEXT,
    PRIMARY KEY(id AUTOINCREMENT)
  );'

  @db.execute 'CREATE TABLE if not exists Comments
  (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_date DATE,
    content TEXT,
    post_id integer
  );'
end
get '/' do
  @results = @db.execute 'select * from Posts order by id desc'
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  @content = params[:content]
  @name_autor = params[:name_autor]

  if @content.length <= 0
    @error = 'Type post text'
    return erb :new
  end

  @db.execute 'insert into Posts (name_autor, content, created_date) values (?, ?, datetime())', [@name_autor, @content]

  # Перенаправление на главную страницу
  redirect to '/'
end

get '/details/:post_id' do
  # Получаю переменную из URL,ф
  post_id = params[:post_id]
  # Получаю список постов
  # у нас  только 1 пост
  results = @db.execute 'select * from Posts where id = ?', [post_id]
  # Выбираю этот 1 пост в переменную @row
  @row = results[0]
  # Выбираем комментарии для моего поста
  @comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]
  # Возвращаю пердставление details.erb
  erb :details
end

# Обработчик post запроса /details/...
# (браузер отправляет данные на сервер, мы их принимаем)
post '/details/:post_id' do
    post_id = params[:post_id]
    content = params[:content]

      @db.execute 'insert into Comments
      (
        content,
        created_date,
        post_id
      )
        values
      (
        ?,
        datetime(),
        ?
      )', [content, post_id]


  # Перенаправление на главную страницу
  redirect to ('/details/' + post_id)
end

