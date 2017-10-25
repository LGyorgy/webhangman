require "./lib/hangman"
require "sinatra"
require "sinatra/reloader" if development?

enable :sessions

get "/" do
  session[:game] = Game.new unless session[:game]
  hangman_values = session[:game].get_status
  erb :index, :locals => {render_word:    hangman_values[:render_word],
                          missed_letters: hangman_values[:missed_letters].join(", "),
                          win:            hangman_values[:win],
                          msg:            session.delete(:msg)
                         }
end

post "/" do
  if params[:guess] == "new_game"
    session[:game] = Game.new
  else
    status = session[:game].guess(params[:guess])
    msg = ""
    case status
    when :win
      msg = "You have won!"
    when :saved
      msg = "Game saved!"
    when :loaded
      msg = "Game loaded!"
    when :repeat
      msg = "You have already choose this letter!"
    when :found
      msg = "You have got one!"
    when :miss
      msg = "You missed..."
    end

    session[:msg] = msg
  end
  redirect "/"
end