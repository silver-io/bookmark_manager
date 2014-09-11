get '/users/new' do
  @user = User.new
  erb :"users/new"
end

post '/users' do
	@user = User.new(:email => params[:email],
							:password => params[:password],
              :password_confirmation => params[:password_confirmation])
  if @user.save
    session[:user_id] = @user.id
    redirect to ('/')
  else
    flash[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

get '/users/reset_password' do
  erb :"users/reset_password"
end

post '/users/reset_password' do
  email = params[:email]
  user = User.first(:email => email)
  user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
  user.password_token_timestamp = Time.now
  user.save
  flash[:notice] = "password token has been sent"
  redirect to ('/')
end

get "/users/reset_password/:token" do | token |
    user = User.first(:password_token => token)
    session[:token] = token
    if Time.now - user.password_token_timestamp > 3600
    flash[:errors] = ["expired token"]
    else
    redirect to '/users/token_accepted'
    end
end

get '/users/token_accepted' do
    @user = User.first(:password_token => session[:token])
    erb :"users/token_accepted" 
end

post '/users/token_accepted' do
  user = User.first(:password_token => params[:accepted_token])
  user.password = params[:password]
  user.password_confirmation = params[:password_confirmation]
  user.password_token = nil
  user.password_token_timestamp = nil
  user.save
  redirect to ('/sessions/new')
end









