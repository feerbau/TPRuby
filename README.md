# rn

Ruby Notes, o simplemente `rn`, es un gestor de notas web concebido como un clon simplificado
de la excelente herramienta [TomBoy](https://wiki.gnome.org/Apps/Tomboy).


## Decisiones de diseño

Para el desarrollo de la aplicacion "Ruby Notes" se tuvieron en cuenta estos criterios de diseño.

- Cada usuario tendra un cuaderno global ("Global Book") al que se asignaran todas las notas credas en las que no se seleccione un cuaderno al cual pertenzcan.

- Las notas se mostrarán por fecha de actualización mas reciente.

- Para la exportacion de notas se utilizo "Wicked PDF", y la exportacion de las notas será en formato PDF.

- La exportacion de un cuaderno completo se realizara en un archivo comprimido, con extension .zip. El cual tendra de nombre el titulo del cuaderno y archivos PDF correspondientes a cada nota que contuviera dicho cuaderno.

- No se permite modificar el nombre del cuaderno global.

- No se puede eliminar el cuaderno global, solo se "limpia" eliminando las notas que contenga.

## Configuración inicial

Antes de poder usar la aplicacion hay que configurar la base de datos, para eso hay que ejecutar estos comandos:

```bash
$ rails db:create
$ rails db:migrate
```
Y opcionalmente, para crear unos datos de prueba se puede ejecutar lo siguiente:

```bash
$rails db:seed
```
Esto creara un usuario de prueba junto con algunas notas y cuadernos.

## Uso de `rn`

Para ejecutar RUbyNotes podes hacerlo de la siguiente manera:

```bash
$ rails s
```

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
