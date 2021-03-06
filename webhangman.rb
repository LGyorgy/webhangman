require "./lib/hangman"
require "sinatra"
require "sinatra/reloader" if development?

enable :sessions

get "/" do
  session[:game] = Game.new unless session[:game]
  hangman_values = session[:game].get_status
  img = "/pics/#{hangman_values[:missed_letters].length}.png"
  erb :index, :locals => {render_word:    hangman_values[:render_word],
                          missed_letters: hangman_values[:missed_letters],
                          img:            img,
                          win:            hangman_values[:win],
                          msg:            session.delete(:msg),
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
      session[:save_file] = session[:game].save_game
      msg = "Game saved!"
    when :loaded
      session[:game].load_game(session[:save_file])
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