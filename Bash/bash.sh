#/*=========================================================================
#===========================================================================
#    =            Proyecto:      BASH                                  =
#    =            Archivo:       bash.sh                               =
#    =            Autor:         Adrián Epifanio R.H                   =
#    =            Fecha:         13/12/2018                            =
#    =            Asignatura:    Sistemas Operativos                   =
#    =            Lenguaje:      bash                                  = 
#===========================================================================          
#=========================================================================*/


#/*===================================================================
#=                            MAIN PROGRAM                           =
#===================================================================*/
############# VARIABLES
N=
M=
uid_orderx=
inversive_userx=
inversive_uidx=
kill_timex=
kill_pcpux=
sorttx=
sortdx=
helperx=
sentinela=
#orden_usuario=ps axo user,uid,gid,pid,pcpu,comm,cputime,etime |grep U -v | sort -d |uniq -w 10
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
######### ESTILOS DEL TEXTO
TEXT_BOLD=$(tput bold)
TEXT_ULINE=$(tput sgr 0 1)
TEXT_GREEN=$(tput setaf 2)
TEXT_RED=$(tput setaf 1)
TEXT_RESET=$(tput sgr0)


#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
#############FUNCIONES

uid_order(){ #Funcion que ordena por UID
	echo $TEXT_BOLD$TEXT_RED"  UID USER       GID   PID %CPU COMMAND         CPU_TIME       ETIME"$TEXT_RESET
	ps axo uid,user,gid,pid,pcpu,comm,cputime,etime |grep U -v | sort -g | uniq -w 10


	echo
	echo
	echo
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
inversive_user(){ #Funcion que ordena por USER inversivamente
	echo $TEXT_BOLD$TEXT_RED"USER       UID   GID   PID %CPU COMMAND         CPU_TIME       ETIME"$TEXT_RESET
	ps axo user,uid,gid,pid,pcpu,comm,cputime,etime |grep U -v | sort -d -r |uniq -w 10

	echo
	echo
	echo
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
inversive_uid(){ #Funcion que ordena por UID inversivamente
	echo $TEXT_BOLD$TEXT_RED"  UID USER       GID   PID %CPU COMMAND         CPU_TIME       ETIME"$TEXT_RESET
	ps axo uid,user,gid,pid,pcpu,comm,cputime,etime |grep U -v | sort -g -r | uniq -w 10


	echo
	echo
	echo
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
kill_time(){ #Funcion Kill por tiempo (tiempo en segundos)
	for user in $(ps axo user --sort user --no-heading | uniq ); do
		sentinela=0
		for comm in $(ps axo etimes, -u $user --no-heading); do
			sentinela=$((sentinela + 1))			
			if [ "$comm" -le "$N" ]; then
				alpha=$(ps -u $user -o pid --no-heading | head -n $sentinela | tail -n 1)
				echo "Kill $alpha"
			fi
		

		done
	done
				
		

}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
kill_pcpu(){ #Funcion kill por % de cpu
	for user in $(ps axo user --sort user --no-heading | uniq ); do
		sentinela=0
		for comm in $(ps axo pcpu, -u $user --no-heading); do
			sentinela=$((sentinela + 1))			
			if  (( $(echo "$comm > $M" |bc -l) )); then
				beta=$(ps -u $user -o pid --no-heading | head -n $sentinela | tail -n 1)
				echo "Kill $beta"
			fi
		

		done
	done
				
		

}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
funcion_sortt(){
	echo $TEXT_BOLD$TEXT_RED"  UID USER       GID   PID %CPU COMMAND         CPU_TIME       ETIME"$TEXT_RESET
	ps axo uid,user,gid,pid,pcpu,comm,cputime,etime --sort -cputime |grep U -v | uniq -w 10


	echo
	echo
	echo
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
funcion_sortd(){
	echo $TEXT_BOLD$TEXT_RED"  UID USER       GID   PID %CPU COMMAND         CPU_TIME       ETIME"$TEXT_RESET
	ps axo uid,user,gid,pid,pcpu,comm,cputime,etime --sort -etime |grep U -v | uniq -w 10


	echo
	echo
	echo
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
error_apertura(){ #funcion de error si la opcion es no valida
	echo "Error en las opciones, opciones válidas: [-U] [-R] [-R -U] [-ut N] (N en segundos) [-ud N] (N en % de CPU)"
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
helper(){ #funcion de ayuda
	echo "Las opciones para abrir el programa son: [-U] [-R] [-R -U] [-ut N] (N en segundos) [-ud N] (N en % de CPU)"
}
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
# Procesar la línea de comandos del script para leer las opciones
while [ "$1" != "" ]; do
	
   case $1 in
       "-U")
		clear
		echo "$TEXT_BOLD $TEXT_GREEN El listado ordenado por UID es: $TEXT_RESET "	
		echo
		echo
            	uid_orderx=1
           ;;

       "-R")
		clear
		echo "$TEXT_BOLD $TEXT_GREEN El listado ordenado por user inversamente es: $TEXT_RESET "	
		echo
		echo
		inversivex=1
            ;;

	"-ut" | --Kill_CPU )
		clear
		echo "$TEXT_BOLD $TEXT_GREEN Los procesos que se deberina matar por tiempo son: $TEXT_RESET "	
		echo
		echo
		kill_timex=1
		shift
		N=$1
            ;;

	"-ud" | --Kill_Time )
		clear
		echo "$TEXT_BOLD $TEXT_GREEN Los procesos que se deben matar por %CPU son: $TEXT_RESET "	
		echo
		echo
		kill_pcpux=1
		shift
		M=$1
            ;;

       "-sortt")
		clear
		echo "$TEXT_BOLD $TEXT_GREEN El listado ordenado por tiempo de CPU es: $TEXT_RESET "	
		echo
		echo
		sorttx=1
            ;;

       "-sortd")
		clear
		echo "$TEXT_BOLD $TEXT_GREEN El listado ordenado por tiempo en ejecución es: $TEXT_RESET "	
		echo
		echo
		sortdx=1
            ;;

       -h | --help )
           helperx=1
           exit
           ;;

       * )
           error_apertura
           exit 1
   esac
   shift
done

#   if [ "$uid_orderx" = "1" ]; then
#		clear
#		echo "$TEXT_BOLD $TEXT_GREEN El listado ordenado por UID es: $TEXT_RESET "	
#		echo
#		echo
#           uid_order
#
#  fi

#   if [ "$inversivex" = "1" ]; then
#		clear
#		echo "$TEXT_BOLD $TEXT_GREEN El listado ordenado por user inversamente es: $TEXT_RESET "	
#		echo
#		echo
#		inversive_user
#  fi
#
#  if [ "$inversive_uidx" = "1" ]; then
#		clear
#		echo "$TEXT_BOLD $TEXT_GREEN El listado ordenado por uid inversamente es: $TEXT_RESET "	
#		echo
#		echo
#		inversive_uid
#
#  fi
  

#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
 if [ "$kill_timex" = "1" ]; then
		clear
		echo "$TEXT_BOLD $TEXT_GREEN El listado ordenado por uid inversamente es: $TEXT_RESET "	
		echo
		echo
		kill_time

   fi
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
 if [ "$kill_pcpux" = "1" ]; then
		clear
		echo "$TEXT_BOLD $TEXT_GREEN El listado ordenado por uid inversamente es: $TEXT_RESET "	
		echo
		echo
		kill_pcpu

   fi
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
 if [ "$sorttx" = "1" ]; then
		#clear
		#echo "$TEXT_BOLD $TEXT_GREEN El listado ordenado por uid inversamente es: $TEXT_RESET "	
		echo
		echo
		funcion_sortt

   fi
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
 if [ "$sortdx" = "1" ]; then
		#clear
		#echo "$TEXT_BOLD $TEXT_GREEN El listado ordenado por uid inversamente es: $TEXT_RESET "	
		echo
		echo
		funcion_sortd

   fi
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
    #   -h | --help )
   if [ "$helperx" = "1" ]; then
            helper
           exit
   fi
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
	#clear
	#echo "$TEXT_BOLD $TEXT_GREEN El listado de procesos en el sistema es: $TEXT_RESET"
	echo
	echo
	echo $TEXT_BOLD$TEXT_RED"USER       UID   GID   PID %CPU COMMAND         CPU_TIME       ETIME"$TEXT_RESET
if [ "$uid_orderx" = "1" ]; then
	if [ "$inversivex" = "1" ]; then
		ps axo user,uid,gid,pid,pcpu,comm,cputime,etime --sort -uid |grep U -v |uniq -w 10
		#Tambien se puede hacer asi:
		#ps aux --sort user |uniq -w 4
	else
		ps axo user,uid,gid,pid,pcpu,comm,cputime,etime --sort uid |grep U -v |uniq -w 10
	fi
else
	if [ "$inversivex" = "1" ]; then	
		ps axo user,uid,gid,pid,pcpu,comm,cputime,etime --sort -user |grep U -v |uniq -w 10
		#Tambien se puede hacer asi:
		#ps aux --sort user |uniq -w 4
	else
		ps axo user,uid,gid,pid,pcpu,comm,cputime,etime --sort user |grep U -v |uniq -w 10
	fi

fi
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 13/12/2018
# *
# *
#**/
	echo
	echo "$TEXT_GREEN El número de procesos que está actualmente ejecutando el usuario es: $TEXT_RESET"
	ps axo user |grep $USER |wc -l 

	echo
	echo "$TEXT_GREEN El proceso que ha consumido mas CPU hasta el momento es: $TEXT_RESET"
	echo "%CPU COMMAND         CPU_TIME"
	ps axo pcpu,comm,cputime |sort -g -r | head -n 1
	#La otra forma sería:
	#ps aux --sort=-pcpu |head -n 2
	echo 
	echo "$TEXT_GREEN El proceso que lleva mas tiempo en ejecución es: $TEXT_RESET"
	ps axo comm,etime,user,uid,gid,pid,pcpu --sort=-etime |head -n 2
	echo 


#/*=================================================================*/
#/*=========================  End of Main  =========================*/




