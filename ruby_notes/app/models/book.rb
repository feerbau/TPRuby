class Book < ApplicationRecord
	has_many :notes, inverse_of: :book, dependent: :delete_all
	belongs_to :user, inverse_of: :books

	validates :title, presence: true, uniqueness: {scope: :user}, length: {maximum: 40}
	before_validation :strip_whitespaces

	def strip_whitespaces
        self.title = if !title.nil? then title.strip end
    end
    
	def to_s
		title
	end
end
