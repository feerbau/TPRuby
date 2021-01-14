class ExportController < ApplicationController
  # rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  	def index
	        
   	end

	def show
	    @note = Note.find_by_id(params[:id]) or not_found

	    respond_to do |format|
	        format.html
	        format.pdf do
	            render title: @note.title,
	            pdf: @note.title,
	            page_size: 'A4',
	            template: "export/pdf_note",
	            orientation: "Landscape",
	            lowquality: true,
	            zoom: 1,
	            dpi: 75,
	            disposition: 'attachment'
	        end
	    end
	end

	def export_book
		book_id = params[:id]
		if !book_id.nil?
	    	book = Book.find_by_id(book_id) || not_found
	    else
	    	@notes = Notes.where(book: nil).all
	    end
	    dec_zip(book.notes, book.title)
	end

	def export_all
		dec_zip
	end

    def dec_zip(notes, book_title)
	  require 'zip'
	  #grab some test records
	  @notes = notes
	  stringio = Zip::OutputStream.write_buffer do |zio|
	      @notes.each do |n|
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
	    send_data(binary_data, :type => 'application/zip', :filename => "#{book_title}.zip")
	end

    private
        def scope
            ::Invoice.all.includes(:invoice_items)
        end
        def export_params
      		params.require(:note).permit(:id)
      		params.require(:book).permit(:id)
    	end
end
