module RN
  module Commands
    module Notes
      require 'rn/validator'
      class Create < Dry::CLI::Command
        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]
        
        def call(title:, **options)
          book = options[:book]
          title = Validator::new.validate_file_name(title)

          if book.nil?
            path = File.join(Dir.home,".my_rns","global","/")
            book = "global"
            Validator::new.validate_global
          else
            Validator::new.validate_folder_name(book)
            path = File.join(Dir.home,".my_rns",book,"/")
            
            if !Validator::new.book_exists?(path)
              warn "The book '#{book}' does not exists."
              exit 1
            end
          end

          if Validator::new.note_exists?(path+title)
            warn "There is already a note named #{title} in '#{book}' book."
            exit 1
          end
          File.new(path+title, "w")
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          title = Validator::new.validate_file_name(title)
          if book.nil? or book.empty?
            puts "Book will be searched inside global book."
            Validator::new.validate_global
            book = "global"
          end
          path = File.join(Dir.home, ".my_rns", book)

          if !Validator::new.book_exists?(path)
            warn "The book '#{book}' does not exists."
            exit 1
          end

          if !Validator::new.note_exists?(File.join(path,title)) 
            warn "There is no note called '#{title}' inside '#{book}' book"
            exit
          end
          
          puts "Are you sure you want to delete the note '#{title}' inside '#{book}' book? Type in 'y' to confirm."
          confirmation = STDIN.gets.chomp
          if confirmation != 'y'
            warn "Canceling delete of the note."
            exit 1
          end
          File.delete(File.join(path,title))
          puts "The note '#{title}' has been deleted from '#{book}'"
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          title = Validator::new.validate_file_name(title)

          if book.nil?
            Validator::new.validate_global  
            path = File.join(Dir.home,".my_rns","global",title)
            book = "global"
          else
            Validator::new.validate_folder_name(book)
            path = File.join(Dir.home,".my_rns",book,"/")
            
            if !Validator::new.book_exists?(path)
              warn "The book '#{book}' does not exists."
              exit 1
            end

            path = File.join(Dir.home,".my_rns",book,title)
          end

          if !Validator::new.note_exists?(path)
            warn "There is no note named '#{title}' in '#{book}' book."
            exit 1
          end

          editor = TTY::Editor.new(prompt: "Which one do you fancy?")
          editor.open(path)

          puts "Note succesfully edited."
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          book = options[:book]
          path = File.join(Dir.home,".my_rns")
          old_title = Validator::new.validate_file_name(old_title)
          new_title = Validator::new.validate_file_name(new_title)
          if book.nil? or book.empty?
            puts "Book will be searched inside global book."
            Validator::new.validate_global
            book = "global"
          end
          old_path = File.join(path,book,old_title)
          new_path = File.join(path,book,new_title)
          if Validator::new.note_exists?(old_path) 
            if !Validator::new.note_exists?(new_path)
              File.rename(old_path, new_path)
            else
              warn "There is already a not named '#{new_title}' inside '#{book}'"
            end
          else
            warn "There is no note called '#{old_title}' inside '#{book}' bok"
            exit
          end
          puts "Note has been renamed from #{old_title} to #{new_title}"
          
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]
        
        def call(**options)
          book = options[:book]
          global = options[:global]
          path = File.join(Dir.home,".my_rns/*/*.rn")
          temp = "Listing notes of %{a} "
          message = temp % {a:"every book"}
          if !book.nil? and !book.empty? and Validator::new.validate_folder_name(book)
            if !Validator::new.book_exists?(File.join(Dir.home,'.my_rns',book))
              warn "That book does not exists."
              exit 1
            end
            path = File.join(Dir.home,".my_rns",book,"*.rn")
            message = temp % {a:"book '#{book}'"}
          end

          if global
            path = File.join(Dir.home,".my_rns","global/*.rn")
            message = temp % {a:"global book"}
            Validator::new.validate_global
          end

          list_notes(path, message)
        end

        def list_notes(path, message)
          puts message
          Dir[path].map { |a| puts File.basename(a)}
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]
        
        def call(title:, **options)
          book = options[:book]
          if !book.nil? and Validator::new.book_exists?(Validator::new.get_path(book))
            path = path = File.join(Dir.home,".my_rns", book, title)
          else
            path = File.join(Dir.home,".my_rns","global", title)
            Validator::new.validate_global
          end
          if Validator::new.note_exists?(path)
            if !File.empty?(path)
              table = Terminal::Table.new do |t|
                t.title = title
                File.open(path).each do |line|
                  t.add_row [line] 
                end
              end
              puts table
            else
              puts "The note '#{title}' is empty."
            end
          else
            warn "That note does not exists."
            exit 1
          end
        end
      end
    end
  end
end
