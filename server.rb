require 'sinatra'
require 'sinatra/activerecord'

enable :sessions

configure :development do
  set :database, {adapter: "sqlite3", database: "database.sqlite3"}
end

configure :production do
  set :database, ENV["DATABASE_URL"]
end

# User model
class User < ActiveRecord::Base
end

# Post model
class Post < ActiveRecord::Base
end

####################### WEB APP CONTROLLER LAYOUT ##########################

# HOME page
get '/' do

  erb :entry
end

# READ signup form
get '/users/create' do

  if session['user_id'] != nil
   redirect '/dashboard'
  end

  erb :'/users/create'
end

# CREATE user
post '/users/create' do
  @user = User.new(first_name: params['first_name'],
          last_name: params['last_name'], email: params['email'],
          password: params['password'], birthday: params['birthday'])
  @user.save
  session[:user_id] = @user.id

  redirect "/users/#{@user.id}"
end

# READ post form
get '/posts/create' do

  erb :'/posts/create'
end

# CREATE new post
post '/posts/create' do
  @post = Post.new(title: params['title'], content:
          params['content'], user_id: session['user_id'])
  @post.save

  redirect "/users/#{session['user_id']}"
end

# REDIRECT to new post
get '/posts/:id' do
  @post = Post.find(params['id'])

  erb :'/posts/show'
end


# READ login form
get '/users/login' do

   erb :'/users/login'
end

# USER login
post '/users/login' do
   user = User.find_by(email: params['email'])
   if user != nil
       if user.password == params['password']
       session[:user_id] = user.id
       redirect "/users/#{user.id}"
    end
  end
       redirect '/' # redirect to page displaying message
end

# USER logout
post '/logout' do
  session['user_id'] = nil

  redirect '/'
end

# CANCEL user account
post '/users/:id' do
  @user = User.find(params['id'])
  @user.destroy
  session.clear

  redirect '/'
end

# REDIRECT to user profile
get '/users/:id' do
  @user = User.find(params['id'])
  @posts = Post.where(user_id: params['id']).last(20).reverse

  erb :'/users/profile'
end

# READ dashboard w/all posts
get '/dashboard/?' do
  @posts = Post.all.reverse

  erb :'/dashboard'
end

post '/posts/:id' do
  @post = Post.find(params['id'])
  @post.destroy

  redirect "/users/#{session['user_id']}"
end
