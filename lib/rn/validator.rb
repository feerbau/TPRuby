class Validator
    def get_path(name = '')
        return File.join(Dir.home, '.my_rns', name)
    end 
    
    def note_exists?(path)
        return File.exist?(path)
    end

    def book_exists?(path)
        return Dir.exist?(path)
    end

    def validate_global
        unless Dir.exist?(get_path("global"))
            Dir.mkdir(get_path("global"))
        end
    end

    def validate_folder_name(name)
        if ! /^[\w\-. ]+$/m.match?(name)
            warn "Book title #{name} not valid."
            exit 1
        end
        return true
    end

    def validate_file_name(name)
        if ! /^[\w\-. ]+$/m.match?(name) or name.include? "\n"
            warn "Title #{name} not valid."
            exit 1
        end

        if File.extname(name) != ".rn"
            name = name + ".rn"
        end

        return name
    end
end