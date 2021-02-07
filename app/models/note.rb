class Note < ApplicationRecord
  belongs_to :book, optional: true, inverse_of: :notes
  belongs_to :user, inverse_of: :notes

  validates :title, presence: true, length: {maximum: 255}
  validates :content, presence: true

  def to_s
  	title
  end

  def export
  	ac = ActionController::Base.new()
  	ac.render_to_string :pdf => "#{self.title}.pdf",
                 :template => 'export/pdf_note.pdf.erb',
                 :locals => {note: self}
  end
end
