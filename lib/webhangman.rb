require "./lib/hangman"
require "sinatra"
require "sinatra/reloader" if development?

enable :sessions


get "/" do
  session[:game] = Game.new unless session[:game]
  hangman_values = session[:game].guess(params[:guess])
  erb :index, :locals => {render_word:    hangman_values[:render_word],
                          missed_letters: hangman_values[:missed_letters].join(", "),
                          response:       hangman_values[response].to_s}
end