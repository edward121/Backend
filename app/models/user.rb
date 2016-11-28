class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :name,                type: String, default: ""
  field :status,              type: String, default: "pending"

  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  field :device_token,        type: String, default: ''

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  # Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  acts_as_token_authenticatable
  field :authentication_token,      :type => String

  def self.find_by_token(token)
    User.where(:authentication_token=>token).first
  end
  def approved?
    self.status == 'approved'
  end
  def info_by_json
    user = self
    user_info={
      id:user.id.to_s,
      name:user.name == nil ? "" : user.name,
      email:user.email,
      token:user.authentication_token,
    }
  end

end
