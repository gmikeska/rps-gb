require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'pry-byebug'
require 'bcrypt'

lib_files = ['lib/db_helper.rb', 'lib/repos/user_repo.rb', 'lib/repos/game_repo.rb']

lib_files.each do |f|
	require_relative f
	also_reload f
end


configure do
	enable :sessions
end

before do
	if session['user_id']
	  user_id = session['user_id']
	  @db = RpsGame.create_db_connection
	  @current_user = RpsGame::UsersRepo.find @db, user_id
	else
	  @current_user = {'username' => 'anonymous', 'id' => 1}
	end
end


get '/' do
	erb :"index"
end
get '/signup' do
	erb :"auth/signup"
end

post '/signup' do
	password_hash = BCrypt::Password.create(params['password'])
	user_data = {username: params['username'], password: password_hash}
	user_data = RpsGame::UsersRepo.save(@db, user_data)
	session['user_id'] = user_data['id']
	redirect to '/'
end

get '/signin' do
	erb :"auth/signin"
end

post '/signin' do
	user_data = RpsGame::UsersRepo.find_by_name(@db, params['username'])
	if(user_data)
	  password_hash = BCrypt::Password.new(user_data['password'])
	  if password_hash == params['password']
	    session['user_id'] = user_data['id']
	    redirect to '/'
	  else
	    flash.now[:alert] = "Incorrect Password for username #{params['username']}. Please try again."
	    erb :"auth/signin"
	  end
	else
	  flash.now[:alert] = "No user found with username #{params['username']}."
	  erb :"auth/signin"
	end
end

get '/signout' do
	session.clear
	redirect to '/'
end

