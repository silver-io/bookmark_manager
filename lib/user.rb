require 'bcrypt'

class User

	include DataMapper::Resource

	property :id, Serial
  property :email, String
  property :password_digest, Text
  property :email, String, :unique => true, :message => "This email is already taken"

  attr_reader 	 :password
  attr_accessor :password_confirmation

  validates_confirmation_of :password
  validates_uniqueness_of :email

  def password=(password)
  	@password = password
  	self.password_digest = BCrypt::Password.create(password)
  end

end

