class ExportController < ApplicationController
  # rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  	def index
	        
   	end

	def show
	    @note = Note.find_by_id(params[:id]) or not_found

	    send_data(@note.export, :type => 'application/pdf', :filename => "#{@note.title}.pdf")
	end

	def export_book
		@book = Book.find_by_id(params[:id]) or not_found
		send_data(@book.export, :type => 'application/zip', :filename => "#{@book.title}.zip")
	end

	def export_all
		stringio = Zip::OutputStream.write_buffer do |zio|
	        current_user.notes.each do |n|
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
	    send_data(binary_data, :type => 'application/zip', :filename => "RubyNotes.zip")
	end

    private
        def export_params
      		params.require(:note).permit(:id)
      		params.require(:book).permit(:id)
    	end
end
