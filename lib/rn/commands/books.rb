module RN
  module Commands
    module Books
      require 'rn/validator'
      class Create < Dry::CLI::Command
        require 'rn/book'

        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'
        option :subtitulo, required: true, desc: 'Name of the book'
        
        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **opciones)
          Validator::new.validate_folder_name(name)
          path = File.join(Dir.home,".my_rns",name)
          if Validator::new.book_exists?(path)
            abort  "There is already a book with the name #{name}"
          end
          puts Book.new(name).save
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          global = options[:global]
          if (name.nil? && !global)
            abort "No book will be deleted."
          end
          if name.nil? 
            name = 'global'
          end
          puts Book.new(name).delete
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          Book.all.each { |name| puts name }
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          old_path = Validator::new.get_path(old_name)
          new_path = Validator::new.get_path(new_name)
          if Validator::new.validate_folder_name(old_name) and Validator::new.validate_folder_name(new_name)
            if Validator::new.book_exists?(old_path) 
              if !Validator::new.book_exists?(new_path)
                puts Book.rename(old_name, new_name)
              else
                abort "A book named '#{new_name}' already exists."
              end
            else
              abort "A book named '#{old_name}' does not exists."
            end
          end
        end
      end
    end
  end
end
