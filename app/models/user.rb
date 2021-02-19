class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :notes, inverse_of: :user
  has_many :books, inverse_of: :user
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_account

	def create_account
	  self.books.create(title: "Global Book")
	end
end
