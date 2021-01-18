# lib/rn/book.rb
module RN
  class Book
    GLOBAL_BOOK_NAME = 'global'
    require_relative "paths_helper"
    extend PathsHelper

    attr_accessor :name

    def self.global
      GLOBAL_BOOK_NAME
    end

    def self.from_directory(path)
      File.basename(path)
    end

    def self.all
      found = Dir["#{root_path}/*"].select { |e| File.directory?(e) }.map do |book_path|
        Book.from_directory(book_path)
      end
      # Se fuerza la inclusión del cuaderno global en caso que aún no exista
      found.unshift(Book.global) unless found.any? { |name| name == Book.global} 
      found
    end

    def self.rename(old_name, new_name)
      if Book.new(old_name).global?
        return "Global book cannot be renamed."
      end
      File.rename(get_path(old_name), get_path(new_name))
      "The book '#{old_name}' has been renamed to '#{new_name}'"
    end

    def initialize(name)
      self.name = name
    end

    def exist?
      Dir.exist?(path)
    end

    def global?
      name == GLOBAL_BOOK_NAME
    end

    def notes
      Dir["#{path}/*#{Book.notes_extension}"].map do |note_path|
        Note.from_file(note_path, book: self)
      end
    end

    def path
      "#{Book.root_path}/#{self.name}"
    end

    def save
      Dir.mkdir(get_path(self.name))
      "The new book #{self.name} has been created"
    end

    def delete
      if exist? 
        Dir.each_child(path) {|x| File.delete(path+"/#{x}") }
        Dir.rmdir(path)
        return "'#{self.name}' book has been succesfully deleted."
      end
      "The Book '#{name}' does not exists."
    end
    
  end
end