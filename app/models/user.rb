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

  def export_all
    stringio = Zip::OutputStream.write_buffer do |zio|
        self.notes.each do |n|
          pdf = n.export
          zio.put_next_entry("#{n.title} - from book '#{n.book.title}'.pdf")
          zio << pdf
        end
      # This is needed because we are at the end of the stream and 
      # will send zero bytes otherwise
    end
    stringio.rewind
    #just using variable assignment for clarity here
    binary_data = stringio.sysread
    # binary_data
    
  end
end
