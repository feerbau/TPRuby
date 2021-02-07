# rn

Ruby Notes, o simplemente `rn`, es un gestor de notas concebido como un clon simplificado
de la excelente herramienta [TomBoy](https://wiki.gnome.org/Apps/Tomboy).

Este proyecto es simplemente una plantilla para comenzar a implementar la herramienta e
intenta proveer un punto de partida para el desarrollo, simplificando el _bootstrap_ del
proyecto que puede ser una tarea que consume mucho tiempo y conlleva la toma de algunas
decisiones que pueden tener efectos tanto positivos como negativos en el proyecto.


## Decisiones de diseño

Para el desarrollo de la aplicacion "Ruby Notes" se tuvieron en cuenta estos criterios de diseño.

- Cada usuario tendra un cuaderno global ("Global Book") al que se asignaran todas las notas credas en las que no se seleccione un cuaderno al cual pertenzcan.

- Las notas se mostrarán por fecha de actualización mas reciente.

- Para la exportacion de notas se utilizo "Wicked PDF", y la exportacion de las notas será en formato PDF.

- La exportacion de un cuaderno completo se realizara en un archivo comprimido, con extension .zip. El cual tendra de nombre el titulo del cuaderno y archivos PDF correspondientes a cada nota que contuviera dicho cuaderno.

- No se permite modificar el nombre del cuaderno global.

- No se puede eliminar el cuaderno global, solo se "limpia" eliminando las notas que contenga.

## Uso de `rn`

Para ejecutar el comando principal de la herramienta se utiliza el script `bin/rn`, el cual
puede correrse de las siguientes manera:

```bash
$ rails s
```

Documentar el uso para usuarios finales de la herramienta queda fuera del alcance de esta
plantilla y **se deja como una tarea para que realices en tu entrega**, pisando el contenido
de este archivo `README.md` o bien en uno nuevo. Ese archivo deberá contener cualquier
documentación necesaria para entender el funcionamiento y uso de la herramienta que hayas
implementado, junto con cualquier decisión de diseño del modelo de datos que consideres
necesario documentar.

## Desarrollo

Esta sección provee algunos tips para el desarrollo de tu entrega a partir de esta
plantilla.

### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias. Si aún no sabés qué es eso
o cómo usarlo, no te preocupes: ¡lo vamos a ver en breve en la materia! Mientras tanto,
todo lo que necesitás saber es que Bundler se encarga de instalar las dependencias ("gemas")
que tu proyecto tenga declaradas en su archivo `Gemfile` al ejecutar el siguiente comando:

```bash
$ bundle install
```

> Nota: Bundler debería estar disponible en tu instalación de Ruby, pero si por algún
> motivo al intentar ejecutar el comando `bundle` obtenés un error indicando que no se
> encuentra el comando, podés instalarlo mediante el siguiente comando:
>
> ```bash
> $ gem install bundler
> ```

Una vez que la instalación de las dependencias sea exitosa (esto deberías hacerlo solamente
cuando estés comenzando con la utilización del proyecto), podés comenzar a probar la
herramienta y a desarrollar tu entrega.
