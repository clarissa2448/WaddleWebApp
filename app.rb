require 'bundler'
Bundler.require
require "sinatra"
require "sinatra/activerecord"
require "./models.rb"
set :database, "sqlite3:myblogdb.sqlite3"

class ApplicationController < Sinatra::Base
    get '/' do
        erb :index
    end
    
    get '/show_all' do
        erb :show_all
     end
 
    post '/groups' do
        userSchool = params[:start]
        # iterate through Post.all and find the matching location
        @posts = Post.all
        count = 0
        @location_array = []
        @time_array = []
        @destination_array = []
        @idnum_array = []
        @method_array = []
        @posts.each do |post|
            if userSchool.downcase == post.location.downcase
                @location = post.location
                @destination = post.destination
                @time = post.time
                @idnum = post.id
                @method = post.date
                
                @location_array.push(post.location)
                @destination_array.push(post.destination)
                @time_array.push(post.time)
                @idnum_array.push(post.id)
                @method_array.push(post.date)
                
                count += 1
                
            end
        end
        if count == 0
            @output = "There are currently no waddles available :("
            erb :no_results
        else 
            erb :results
        end

    end
    post '/create_groups' do

        if params[:location] != "" && params[:destination] != "" && params[:time] != "" && params[:name] != "" && params[:method]
            @post = Post.create(location: params[:location], destination: params[:destination], date: params[:method], time: params[:time], penguins: "#{params[:name]}")
            erb :show
        else
            @output = "Please Complete All Fields" 
            erb :no_results
        end
    end
    
    post '/submit' do
        userEnd = params[:destination]
        userMethod = params[:method]
        @posts = Post.all
        @posts.each do |post|
            if userEnd.downcase == post.destination.downcase and userMethod.downcase == post.date.downcase
                @location = post.location
                @destination = post.destination
                @time = post.time
                @method = post.date
                @idnum = post.id
            end
        end
        @post = Post.find(@idnum)
        # milTime = @time
        # if @time.include? "PM"
        #     milTime = @time.chomp(" PM").split(":")
        # else
        #     milTime = @time.chomp(" AM").to_i
        # end
        # if Time.now.hour > milTime
        #     @post.update(penguins: "")
        # end
        @post.update(penguins: (params[:name] + ", " + @post.penguins).chomp(", "))
        
        erb :show
    end
    
end