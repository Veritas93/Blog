#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprozorium.db'
	@db.results_as_hash = true
end
 # before вызывается каждый раз при перезагрузке страницы
before do 
	init_db
end
 # инициализация базы данных
configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts
	 (
	 id INTEGER PRIMARY KEY AUTOINCREMENT,
	 created_date DATE,
	 content TEXT
	  )'

	@db.execute 'CREATE TABLE IF NOT EXISTS Comments
	 (
	 id INTEGER PRIMARY KEY AUTOINCREMENT,
	 created_date DATE,
	 content TEXT,
	 post_id INTEGER
	  )'
end
 # создание базы данных если такая не существует	

	

get '/posts' do
	# список постов из БД
	@results = @db.execute 'select * from Posts order by id desc'
	erb :index
end
 # обработчик  get запроса /new_post
 # (браузер получает страницу с сервера)
get '/new_post' do
  erb :new
end
 # обработчик  post запроса /new_post
 # (браузер отправляет данные на  сервер)
post '/new_post' do
	# получаем переменную из post запроса
  @content = params[:content]

  if @content.length <= 0
  	@error = 'Введите текст'
  	return erb :new
  end
   # сохранение данных в БД
  @db.execute 'insert into Posts (content, created_date) values ( ? , datetime())' , [@content]
  redirect to '/posts'
end

get '/details/:post_id' do
	# получаем переменную из url'a
	post_id = params[:post_id]
	 # получаем список постов
	 # у нас выбирается только один пост
	results = @db.execute 'select * from Posts where id= ?', [post_id]

	 # выбираем этот пост в переменную @row
	@row = results[0]
	 # выбираем комментарии для нашего поста 
	 @comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]

	erb :details
end
# обработчик post-запроса /details/...
post '/details/:post_id' do
	# получаем переменную из url'a
	post_id = params[:post_id]

	# получаем переменную из post запроса 
	content = params[:content]

	 # сохранение данных в БД
    @db.execute 'insert into Comments
     (
     	content,
     	created_date,
    	post_id
    ) 
    	values 
    ( 
    	? ,
    	datetime(),
    	?
    )' , [content, post_id]

	redirect to ('/details/' + post_id)
end