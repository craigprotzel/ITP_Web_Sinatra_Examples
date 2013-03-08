require 'sinatra'
require 'dm-core'

DataMapper::setup(:default, {:adapter => 'yaml', :path => 'db'})

class Thought
  include DataMapper::Resource
  property :id, Serial
  property :body, Text
  
  has n, :comments
end

class Comment
  include DataMapper::Resource
  property :id, Serial
  property :discussion, Text
  
  belongs_to :thought
end


DataMapper.finalize



# Main route  - this is the form is shown
get '/' do
  erb :welcome
end

get '/all' do
  @thoughts = Thought.all.reverse
  erb :all
end


post '/comment/:id' do
  @currentThought = Thought.get(params[:id])
  
  myComment = Comment.new
  myComment.thought = @currentThought
  myComment.discussion = params[:discussion]
  myComment.save

  redirect "http://itp.nyu.edu/~chp250/sinatra/thoughts/all"
end

get '/admin' do
  erb :admin
end

post '/admin_saved' do
  
  myThought = Thought.new
  myThought.body = params[:body]
  
  if(myThought.save)
    @message = "The thought was saved forever!"
  else
    @message = "The thought was NOT SAVED!!!!!!!"
  end
  
  erb :admin_saved
end

