class User < ApplicationRecord
  has_one :cart

  attr_accessor :email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:authentication_keys => [:email]


has_many :credit_cards, dependent: :destroy
after_commit :assign_customer_id, on: :create

  def assign_customer_id
    customer = Stripe::Customer.create(email: email)
    self.customer_id = customer.id
  end
end
