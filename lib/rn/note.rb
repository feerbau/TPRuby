# lib/rn/note.rb
module RN
  class Note
    require_relative "paths_helper"
    require_relative "book"
    extend PathsHelper

    attr_accessor :title, :content, :book

    def self.export_path
      File.join(Dir.home, "/RubyNotes")
    end

    def self.export_all_notes(book = '*')
      Dir["#{root_path}/#{book}/*.rn"].select { |f| File.file?(f) }.map do | file_path |
        book = File.dirname(file_path).split('/').last
        Note.new(File.basename(file_path), book).exportNote
      end
    end

    def initialize(title, book= nil)
      self.title = title
      # self.content = content
      self.book = book || Book.global
    end

    def path
      Book.new(self.book).path + "/#{self.title}"
    end

    def exist?
      File.exist? path
    end

    def confirm
      puts "Are you sure you want to delete the note '#{self.title}' inside '#{self.book}' book? Type in 'y' to confirm."
      confirmation = STDIN.gets.chomp
      if confirmation != 'y'
        return false
      end 
      return true
    end

    def create
      if Book.new(self.book).exist?
        if exist?
          return "There is already a note named #{self.title} in '#{self.book}' book."
        else
          File.new(path,  "w+")
          return "Book '#{self.title}' has been created inside '#{self.book}' book."
        end
      else
        return "The book '#{self.book}' does not exists."
      end
    end

    def delete
      if Book.new(self.book).exist?
        if exist?
          if !confirm
            return "Canceling delete of the note."
          end
          File.delete(path)
          return "The note '#{title}' has been deleted from '#{book}'"
        else
          return "There is no note named '#{self.title}' inside '#{book}' book"
        end
      else
        return "The book '#{self.book}' does not exists."
      end
    end

    def edit
      if Book.new(self.book).exist?
        if exist?
          editor = TTY::Editor.new(prompt: "Which one do you fancy?")
          editor.open(path)
          return "Note succesfully edited."
        else
          return "There is no note named '#{title}' in '#{book}' book."
        end
      else
        return "The book '#{self.book}' does not exists."
      end
    end

    def rename(new_title)
      File.rename(path, Note.new(new_title).path)
    end

    def retitle(new_title)
      if Book.new(self.book).exist?
        if exist?
          if !Note.new(new_title, self.book).exist?
            rename(new_title)
            return "Note has been renamed from #{title} to #{new_title}"
          else
            return "There is already a note named '#{new_title}' inside '#{book}'"
          end
        else
          return "There is no note called '#{title}' inside '#{book}' book"
        end
      else
        return "The book '#{self.book}' does not exists."
      end
    end

    def self.list_all
      path = File.join(Dir.home,".my_rns/*/*.rn")
      message = "Listing notes of book every book"
    
      list_notes(path, message)
    end

    def self.list(book_to_list)
      path = File.join(Dir.home,".my_rns/*/*.rn")
      if Book.new(book_to_list).exist?
        path = File.join(Dir.home,".my_rns",book_to_list,"*.rn")
        message = "Listing notes of book '#{book_to_list}'"
      else
        return "The book '#{book_to_list}' does not exists."
      end
      list_notes(path, message)
    end

    def self.list_notes(path, message)
      puts message
      Dir[path].each { |a| puts File.basename(a)}
    end

    def show
      if exist?
        if !File.empty?(path)
          table = Terminal::Table.new do |t|
            t.title = title
            File.open(path).each do |line|
              t.add_row [line] 
            end
          end
          return table
        else
          return "The note '#{title}' is empty."
        end
      else
        return "That note does not exists."
      end
    end

    def exportNote
      if exist?
        new_path = Note.export_path + "/" + self.book
        data = File.read(path).to_s
        markdown= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables:true)
        new_content= markdown.render(data)
        export_to(new_content, new_path)
      else
        abort "That note does not exists."
      end
    end

    def export_to(data, path_to)
      if not Dir.exist?(path_to)
        Dir.mkdir(path_to)
      end

      if File.file? path_to + "/#{self.title.slice(0..-4)}.html"
        puts "Exported note '#{path_to+"/"+self.title.slice(0..-4)}.html' will be overwritten. Do you want that? Type in 'y' to confirm."
        confirmation = STDIN.gets.chomp
        if confirmation != 'y'
          abort "Export cancelled."
        end
      end
      File.new(path_to + "/#{self.title.slice(0..-4)}.html",  "w+")
      File.write(path_to + "/#{self.title.slice(0..-4)}.html", data)
      puts "Note '#{self.title.slice(0..-4)}.html' has been exported to #{path_to}'"
    end


  end
end