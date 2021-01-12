class Book < ApplicationRecord
	has_many :notes, inverse_of: :book
	belongs_to :user, inverse_of: :books

	validates :title, presence: true, uniqueness: true, length: {maximum: 255}

	def to_s
		title
	end
end
