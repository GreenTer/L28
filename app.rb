#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db
	@db.execute	'CREATE TABLE IF NOT EXISTS
		Posts
		(
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			content TEXT,
			created_date DATE
		)'
end

get '/' do
	@results = @db.execute 'select * from Posts order by id desc'
	erb :index
end

get'/new_post' do
  erb :new_post
end

post '/new_post' do
  content = params[:content]

  if content.length <= 0
  	@error = 'Type post text'
  	return erb :new_post
  end

  @db.execute 'INSERT INTO Posts (content, created_date) VALUES (?, datetime())', [content]

  redirect to '/'
  erb "You typed #{content}"
end

get '/posts/:post_id' do
	post_id = params[:post_id]

	results = @db.execute 'select * from Posts where id=?', [post_id]
	@row = results[0]

	erb :posts
end

post '/posts/:post_id' do
	post_id = params[:post_id]
	content = params[:content]

	erb "You typed comment #{content} for post #{post_id}"
end