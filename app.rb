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
end
 # создание базы данных если такая не существует	

	

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
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

  erb "You typed: #{@content}"
end