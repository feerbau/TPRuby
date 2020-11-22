# lib/rn/paths_helper.rb
module RN
  module PathsHelper
    def root_path
      "#{Dir.home}/.my_rns"
    end

    def sanitized_for_filename(string)
      string.gsub(/[\\]/, '_') # ¡Esto es una simplificación! Implementá los reemplazos que consideres necesarios
    end

    def notes_extension
      '.rn'
    end

    def get_path(name)
      root_path + "/#{name}"
    end

    # ...implementar otros métodos de soporte sobre rutas que consideres necesarios...
  end
end