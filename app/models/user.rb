class User < ActiveRecord::Base
  has_many :authentications, :dependent => :delete_all

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name

  # Link to omniauth
  def apply_omniauth(auth)
    # Store email, and build the authentication
    self.email = auth['extra']['raw_info']['email']
    authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
  end
end
