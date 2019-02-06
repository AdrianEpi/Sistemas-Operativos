#/*=========================================================================
#===========================================================================
#    =            Proyecto:      Configuracion                         =
#    =            Archivo:       script.sh                             =
#    =            Autor:         Adrián Epifanio R.H                   =
#    =            Fecha:         22/11/2018                            =
#    =            Asignatura:    Sistemas Operativos                   =
#    =            Lenguaje:      bash                                  = 
#===========================================================================          
#=========================================================================*/




#/*===================================================================
#=                            Functions                              =
#===================================================================*/
#!/bin/bash

# sysinfo - Un script que informa del estado del sistema
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 22/11/2018
# *
# *
#**/
##### Constantes

TITLE="Información del sistema para $HOSTNAME"

RIGHT_NOW=$(date +"%x %r%Z")
TIME_STAMP="Actualizada el $RIGHT_NOW por $USER"
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 22/11/2018
# *
# *
#**/
##### Estilos

TEXT_BOLD=$(tput bold)
TEXT_ULINE=$(tput sgr 0 1)

TEXT_GREEN=$(tput setaf 2)
TEXT_RESET=$(tput sgr0)
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 22/11/2018
# *
# *
#**/
##### Funciones

system_info()
{
   echo "${TEXT_ULINE}Versión del sistema${TEXT_RESET}"

    echo
   uname -a
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 22/11/2018
# *
# *
#**/
show_uptime()
{
   echo "${TEXT_ULINE}Tiempo de encendido del sistema${TEXT_RESET}"
    echo
   uptime
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 22/11/2018
# *
# *
#**/
drive_space()
{
   echo "${TEXT_ULINE}Uso del disco${TEXT_RESET}"
    echo
    df
   
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 22/11/2018
# *
# *
#**/
home_space()
{
	if [ "$USER" -ne "$LOGNAME" ]
		then
		echo "El usuario actual no coincide con el usuario de logueo"
		echo "Usuario actual: $USER"
		echo "Usuario de logueo: $LOGNAME"

	fi
    echo "${TEXT_ULINE}Espacio ocupado en el disco${TEXT_RESET}"
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
		
		echo "${TEXT_ULINE}El numero de procesos en curso actualmente es:${TEXT_RESET}"
		ps |wc -l		
		#ps | wc -l
	fi

	echo
	echo "${TEXT_ULINE}Los 5 procesos ordenados por memoria son:${TEXT_RESET} "
	ps -a --no-headers -o vsz,command | sort -rr | head -n 5

	#espacio de cada subdirectorio (no necesario en la practica)	
	#du -ch /home/$USER/*/* | sort -r -n 
}

#/*======================================================================*/
#/*=========================  End of Functions  =========================*/
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 22/11/2018
# *
# *
#**/
#/*===================================================================
#=                            MAIN PROGRAM                           =
#===================================================================*/
##### Programa principal

cat << _EOF_

$TEXT_BOLD$TITLE$TEXT_RESET

$(system_info)

$(show_uptime)

$(drive_space)

$(home_space)

$TEXT_GREEN$TIME_STAMP$TEXT_RESET

_EOF_


#/*=================================================================*/
#/*=========================  End of Main  =========================*/
