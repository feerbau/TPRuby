module RN
  module Commands
    module Books
      class Create < Dry::CLI::Command
        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'
        option :subtitulo, required: true, desc: 'Name of the book'
        
        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **opciones)
          path = File.join(Dir.home,".my_rns",name)
          if Dir.exist? path
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
          end
          path = File.join(Dir.home,".my_rns")
          if (not name.nil?)
            dir_to_delete = File.join(path,name)
            if(Dir.exist?(dir_to_delete))
              Dir.each_child(dir_to_delete) {|x| File.delete(File.join(dir_to_delete,x)) }
              Dir.rmdir(dir_to_delete)
            else
              puts "The Book #{name} does not exists"
            end
          else
            if Dir.exist? File.join(path,"global")
              Dir.each_child(File.join(path,"global")) {|x| puts x;File.delete(x) }
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
          Dir.entries(directory).select { |file| File.directory?(File.join(directory, file)) }
          path = File.join(Dir.home,".my_rns/*")
          puts Dir.glob(path)
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
          path = File.join(Dir.home,".my_rns/")
          if Dir.exist? File.join(path,old_name)
            puts "Book #{old_name} will be renamed to #{new_name}"
            File.rename(File.join(path,old_name),File.join(path,new_name))
          else
            puts "A book named #{old_name} doesn't exists"
          end
        end
      end
    end
  end
end
