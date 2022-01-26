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

get '/new_post' do
  erb :new
end

post '/new_post' do
  @content = params[:content]

  erb "You typed: #{@content}"
end