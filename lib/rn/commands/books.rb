module RN
  module Commands
    module Books
      require 'rn/validator'
      class Create < Dry::CLI::Command
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
            puts "There is already a book with the name #{name}"
          else
            Dir.mkdir(path)
            puts "The new book #{name} has been created under #{File.join(Dir.home, ".my_rns", name)}"
          end
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
            puts "No book will be deleted."
            exit 1
          end

          if (not name.nil?)
            dir_to_delete = Validator::new.get_path(name)
            if (Validator::new.book_exists?(dir_to_delete))
              Dir.each_child(dir_to_delete) {|x| File.delete(File.join(dir_to_delete,x)) }
              Dir.rmdir(dir_to_delete)
              puts "'#{name}' book succesfully deleted."
            else
              puts "The Book '#{name}' does not exists."
            end
          else
            if Dir.exist? Validator::new.get_path("global")
              Dir.each_child(File.join(path,"global")) {|x| puts x;File.delete(x) }
              puts "'global' book succesfully deleted."
            end
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          
          path = File.join(Dir.home,".my_rns","/*") 
          dirs =  Dir[path].select { |entry| File.directory?(entry) }
          dirs.each { |name| puts File.basename(name)}
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
                File.rename(old_path, new_path)
              else
                warn "A book named '#{new_name}' already exists."
                exit 1
              end
            else
              warn "A book named '#{old_name}' does not exists."
              exit 1
            end
          end
        end
      end
    end
  end
end
