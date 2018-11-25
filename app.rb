require "yaml"
require "digest"
require "sinatra"
require "sinatra/base"
require "sinatra/reloader"

require_relative "game.rb"

class App < Sinatra::Base
enable :sessions

if File.file? SAVE_LOCATION
    data = File.read SAVE_LOCATION
    game = YAML::load data
else
    game = Game.new
end

get "/" do
    redirect to "login" unless session[:name]
    game.update_ap
    game.save

    erb :index, :locals => {:game => game, :uname => session[:name]}
end

get "/login" do
    erb :login
end

post "/login" do 
    player = game.tank(params[:username])
    halt 403, "Incorrect details" unless player and player.hash == Digest::SHA256.digest(params[:password])
    session[:name] = player.name
    redirect to "/" 
end

get "/register" do
    halt "Game started" if game.started
    erb :register
end

post "/register" do
    halt "Game started" if game.started

    uname = params[:username]
    halt "Username taken" if game.tank uname
    pword = Digest::SHA256.digest params[:password]

    player = Tank.new game, uname, pword
    game.add_player player
    game.save

    session[:name] = uname
    redirect to "/"
end

get "/logout" do
    session[:name] = nil
    redirect to "/"
end

get "/actions" do
    erb :actions
end

post "/move" do
    halt "Game not started" unless game.started
    player = game.tank session[:name] 
    begin
        player.move params[:x].to_i, params[:y].to_i
        game.save
        redirect to "/actions"
    rescue => ex
        halt ex.message
    end
end

post "/attack" do
    halt "Game not started" unless game.started
    player = game.tank session[:name] 
    begin
        player.attack params[:x].to_i, params[:y].to_i
        game.save
        redirect to "/actions"
    rescue => ex
        halt ex.message
    end
end

post "/trade" do
    halt "Game not started" unless game.started
    player = game.tank session[:name] 
    begin
        player.move params[:x].to_i, params[:y].to_i, params[:ap].to_i
        game.save
        redirect to "/actions"
    rescue => ex
        halt ex.message
    end
end
end
