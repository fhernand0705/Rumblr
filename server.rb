require 'sinatra'
require 'sinatra/activerecord'

# add 'enable :session'

set :database, {adapter: "sqlite3", database: "database.sqlite3"}

# User model
class User < ActiveRecord::Base
end

# Post model
class Post < ActiveRecord::Base
end

################### WEB APP CONTROLLER LAYOUT ##########################

# HOME page
get '/' do

  erb :home
end

# READ signup form
get '/users/create' do

  erb :'/users/create'
end

# CREATE user
post '/users/create' do
  @user = User.new(first_name: params['first_name'],
          last_name: params['last_name'], email: params['email'],
          password: params['password'], birthday: params['birthday'])
  @user.save

  redirect "/users/#{@user.id}"
end

# REDIRECT to user profile
get '/users/:id' do
  @user = User.find(params['id'])

  erb :'/users/profile'
end

# CREATE new post
post '/posts/create' do
  @post = Post.new(title: params['title'], content:
          params['content'], user_id: params['user_id'])

  redirect "/posts/#{@post.id}"
end

# REDIRECT to new post
get '/posts/:id' do
   @post = Post.find(params['id'])

   erb :'/posts/show'
end
