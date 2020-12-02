module RN
  module Commands
    module Notes
      require 'rn/validator'
      require 'rn/note'
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
          Validator::new.validate_global
          title = Validator::new.validate_file_name(title)

          puts Note.new(title,book).create
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
          puts Note.new(title,book).delete
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
          puts Note.new(title,book).edit
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
          Validator::new.validate_global
          old_title = Validator::new.validate_file_name(old_title)
          new_title = Validator::new.validate_file_name(new_title)
          puts Note.new(old_title, book).retitle(new_title)
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
          Validator::new.validate_global
          if !book.nil? and !book.empty?
            puts Note.list(book)
          elsif global
            puts Note.list("global")
          else 
            Note.list_all
          end
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
          Validator::new.validate_global
          title = Validator::new.validate_file_name(title)
          puts Note.new(title, book).show
        end
      end


      class Export < Dry::CLI::Command
        desc 'Export notes'

        argument :title, required: false, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'Global book'

        example [
                    'todo  --global              # Exports a note titled "todo" from the global book',
                    '                            # Export every note from all books',
                    'sample                      # Export "sample" note from global book',
                    '--global                    # Export every note from global book',
                    '--book data                 # Export every note from "data" book',
                    '"sample" --book "My book" # Exports a note titled "sample" from the book "My book"',
                ]

        def call(title: nil, **options)
          Validator::new.validate_export
          book = options[:book]
          global = options[:global]
          if !title.nil?
            title = Validator::new.validate_file_name(title)
            if !book.nil? && Validator::new.validate_folder_name(book)
              Note.new(title, book).exportNote
            else
              Note.new(title).exportNote
            end
          else
            if global
              Note.export_all_notes("global")
            elsif !book.nil?
              Note.export_all_notes(book)
            else
              Note.export_all_notes
            end
          end
        end
      end

    end
  end
end
