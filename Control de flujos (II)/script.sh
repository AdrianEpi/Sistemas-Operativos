#/*=========================================================================
#===========================================================================
#    =            Proyecto:      Control Flujos                        =
#    =            Archivo:       script.sh                             =
#    =            Autor:         Adrián Epifanio R.H                   =
#    =            Fecha:         30/11/2018                            =
#    =            Asignatura:    Sistemas Operativos                   =
#    =            Lenguaje:      bash                                  = 
#===========================================================================          
#=========================================================================*/




#/*===================================================================
#=                            Functions                              =
#===================================================================*/

#He quitado los subrayados y colores porque luego en el .txt no se imprimen y se ven simbolos random

#!/bin/bash
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 30/11/2018
# *
# *
#**/
# Opciones por defecto. 

interactive=
filename=sysinfo.txt
PROGNAME=$(basename $0)
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 30/11/2018
# *
# *
#**/
##### Constantes

TITLE="Información del sistema para $HOSTNAME"
RIGHT_NOW=$(date +"%x %r%Z")
TIME_STAMP="Actualizada el $RIGHT_NOW por $USER"
alpha=
beta=
sentinel=

##### Estilos

TEXT_BOLD=$(tput bold)
TEXT_ULINE=$(tput sgr 0 1)
TEXT_GREEN=$(tput setaf 2)
TEXT_RESET=$(tput sgr0)
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 30/11/2018
# *
# *
#**/
##### Funciones

system_info()
{
   echo "Versión del sistema"

    echo
   uname -a
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 30/11/2018
# *
# *
#**/
show_uptime()
{
   echo "Tiempo de encendido del sistema"
    echo
   uptime
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 30/11/2018
# *
# *
#**/
drive_space()
{
   echo "Uso del disco"
    echo
	if [ "$sentinel" = "" ]; then
   df
   else
   df | grep "$sentinel"
   fi
   echo 
   
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 30/11/2018
# *
# *
#**/
home_space()
{
	if [ "$USER" != "$LOGNAME" ]
		then
		echo "El usuario actual no coincide con el usuario de logueo"
		echo "Usuario actual: $USER"
		echo "Usuario de logueo: $LOGNAME"

	fi
    echo "Espacio ocupado en el disco"
	if [ $USER == "root" ]; then
		echo "El usuario es root"
		echo
		echo "El espacio ocupado es: "
		echo
		du -sh /home/*
		echo
	else
		echo "El usuario no es root"
		echo
		echo "El espacio ocupado es: "
		echo
		du -sh /home/$USER
		echo
		
		echo "El numero de procesos en curso actualmente es:"
		ps |wc -l		
		#ps | wc -l
	fi

	echo
	echo "Los 5 procesos ordenados por memoria son: "
	ps -a --no-headers -o vsz,command | sort -rr | head -n 5

	#espacio de cada subdirectorio (no necesario en la practica)	
	#du -ch /home/$USER/*/* | sort -r -n

	echo "Los procesos cuyo propietario no está en el sistema actualmente son: "
	ps axu | grep -v $USER  | grep -v root
	 #!/bin/bash
        #for i in $( who ); do
	#	echo
	#	echo
	#	echo
	#	echo $i		
	#	
        #   ps axu | grep -v $i  | grep -v root
	#	echo
        #done
   
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 30/11/2018
# *
# *
#**/
# Una función de salida con error

error_exit()
{
#        Función para salir en caso de error fatal
#                Acepta 1 argumento:
#                        cadena conteniendo un mensaje descriptivo del error
        echo "${PROGNAME}: ${1:-"Error desconocido"}" 1>&2
        exit 1
}

# Ejemplo de llamada a la función error_exit. Nótese la inclusión de la variable de entorno LINENO que contiene el número de línea actual
#echo "Ejemplo de error con mensaje y número de línea"
#error_exit "$LINENO: Ha ocurrido un error."

#/*======================================================================*/
#/*=========================  End of Functions  =========================*/
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 30/11/2018
# *
# *
#**/
#/*===================================================================
#=                            MAIN PROGRAM                           =
#===================================================================*/
##### Programa principal


usage()
{
   echo "usage: sysinfo [-f file ] [-i] [-h]"

}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 30/11/2018
# *
# *
#**/
write_page()

{

# El script-here se puede indentar dentro de la función si

# se usan tabuladores y "<<-EOF" en lugar de "<<".

cat << _EOF_

$TITLE


$(system_info)


$(show_uptime)


$(drive_space)


$(home_space)


$TIME_STAMP

_EOF_

}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 30/11/2018
# *
# *
#**/
# Procesar la línea de comandos del script para leer las opciones
while [ "$1" != "" ]; do
   case $1 in
       -f | --file )

            shift
           filename=$1
           ;;
       -i | --interactive )

            interactive=1

            ;;
       -h | --help )

            usage
           exit
           ;;
	-p | --partitions-filter )
	        shift
                sentinel=$1
		;;
       * )

            usage
           exit 1
   esac
   shift
done

if [ "$interactive" = "1" ]; then
echo "Especifica el nombre del archivo de salida"
read filename
  if [ -f $filename ]; then
  until [ "$bool" = "1" ]; do
  echo "Ya existe un fichero con ese nombre. ¿Desea sobreescribirlo? (S/N)"
  read alpha
    case $alpha in
    "S" ) echo "Si"
    beta=1
    ;;
    "N" ) exit
    beta=1
    ;;
    * ) echo "$alpha opción no válida"
    beta=0
    ;;
    esac
  done
  fi
fi
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 30/11/2018
# *
# *
#**/
# Generar el informe del sistema y guardarlo en el archivo indicado

# en $filename

(write_page) >> $filename
#/*=================================================================*/
#/*=========================  End of Main  =========================*/





