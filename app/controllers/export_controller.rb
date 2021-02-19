class ExportController < ApplicationController
  # rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  	def index
	        
   	end

	def export_note
	    @note = current_user.notes.find_by_id(params[:id]) or not_found

	    send_data(self.create_note_pdf(@note), :type => 'application/pdf', :filename => "#{@note.title}.pdf")
	end

	def export_book
		@book = current_user.books.find_by_id(params[:id]) or not_found
		send_data(self.zip_book(@book.notes,@book.title), :type => 'application/zip', :filename => "#{@book.title}.zip")
	end

	def create_note_pdf(note)
		@note = note
  		render_to_string :pdf => "#{@note.title}.pdf",
                 :template => 'export/pdf_note.pdf.erb',
                 :locals => {note: @note}
  	end

  	def zip_book(notes, book_title)
		  #grab some test records
		  stringio = Zip::OutputStream.write_buffer do |zio|
		      notes.each do |n|
		      	@note = n
		        #create and add a pdf file for this record
		        dec_pdf = render_to_string :pdf => "#{@note.title}.pdf",
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

	def export_all
		stringio = Zip::OutputStream.write_buffer do |zio|
	        current_user.notes.each do |n|
	          pdf = self.create_note_pdf(n)
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
	    send_data(binary_data, :type => 'application/zip', :filename => "RubyNotes.zip")
	end

    private
        def export_params
      		params.require(:note).permit(:id)
      		params.require(:book).permit(:id)
    	end
end
