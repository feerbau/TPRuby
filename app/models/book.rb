class Book < ApplicationRecord
	has_many :notes, inverse_of: :book, dependent: :delete_all
	belongs_to :user, inverse_of: :books

	validates :title, presence: true, uniqueness: {scope: :user}, length: {maximum: 40}
	before_validation :strip_whitespaces

	require 'zip'

	def strip_whitespaces
        self.title = if !title.nil? then title.strip end
    end

    def global?
    	self.title == "Global Book"
    end

    def delete_all_notes
    	self.notes.delete(self.notes)
    	self.save
    end
    
	def to_s
		title
	end

	def export
		zip_book(self.notes, self.title)
	end

	private
		def zip_book(notes, book_title)
		  #grab some test records
		  @notes = notes
		  ac = ActionController::Base.new()
		  stringio = Zip::OutputStream.write_buffer do |zio|
		      @notes.each do |n|
		      	@note = n
		        #create and add a pdf file for this record
		        dec_pdf = ac.render_to_string :pdf => "#{@note.title}.pdf",
		        		 :template => 'export/pdf_note.pdf.erb',
		        		 :locals => {note: @note} 
		        zio.put_next_entry("#{@note.title}.pdf")
		        zio << dec_pdf
		      end
		    end
		    # This is needed because we are at the end of the stream and 
		    # will send zero bytes otherwise
		    stringio.rewind
		    #just using variable assignment for clarity here
		    binary_data = stringio.sysread
		    # binary_data
		end

end
