#/*=========================================================================
#===========================================================================
#    =            Proyecto:      Automatizacion de tareas              =
#    =            Archivo:       file.sh                               =
#    =            Autor:         Adrián Epifanio R.H                   =
#    =            Fecha:         02/11/2018                            =
#    =            Asignatura:    Sistemas Operativos                   =
#    =            Lenguaje:      bash                                  = 
#===========================================================================          
#=========================================================================*/



#/*
#En este entregable se pretende resolver un problema de automatización utilizando los comandos del sistema operativo. La práctica consistirá en diseñar un pequeño fichero de automatización con comandos para realizar la copia de seguridad de los archivos en un directorio concreto.
#
#Una automatización consta de un conjunto de comandos almacenados en un fichero de texto. Por ejemplo si tuvieramos que crear una estructura de directorios en varias carpetas podríamos añadir los comandos:
#
#mkdir p1
#mkdir p2
#mkdir p3
#a un fichero de nombre comandos.sh. Despues para ejecutar esos comandos sería con
#
#> bash comandos.sh
#El ejercicio consiste en la creación de un script que realice las siguientes funciones
#
#1. Haga una copia de todos los ficheros del directorio actual en un directorio destino: /tmp/backup
#
#2. Empaquete esos archivos en un único archivo utilizando el comando tar. El nombre del archivo destino debe ser igual a la fecha de hoy y su extension .bk
#
#3. Copie ese nuevo archivo empaquetado en el directorio actual.
#
#4. Cree un archivo de texto con los archivos contenidos en la copia de seguridad, el nombre será la fecha de hoy.txt
#
#5. En la primera linea de este fichero deben estar el número de ficheros de los que se ha realizado la copia de seguridad
#
#6. Elimine el directorio temporal y todos sus archivos.
#
#Como ayuda, se puede crear un directorio con la fecha actual en el nombre, haciendo: mkdir $(date +"%Y_%m_%d_%H_%M").dir
#*/


#/*===================================================================
#=                            MAIN PROGRAM                           =
#===================================================================*/
#Creamos los 3 directios en la bash
cd /
sudo mkdir p1 p2 p3

#Copiamos todos los directorios de 2 letras que empiecen por p en /tmp/backup
cp -R p? /tmp/backup

#Nos movemos al /tmp/backup
cd /tmp/backup

#Comprimimos todos los directorios del directorio actual en un archivo con fecha de hoy por nombre
tar -cvf /tmp/$(date +"%Y_%m_%d_%H_%M").bk /tmp/backup

#Nos movemos al directorio anterior para copar la copia de seguridad en el directorio actual y luego volvemos al directorio actual.
cd ../
cp -R 2018* backup
cd backup/

#Creamos un archivo de texto con fecha de hoy por nombre en el que escribimos en la primera linea los directorios de la copia de seguridad.
ls > $(date +"%Y_%m_%d_%H_%M").txt

#Borramos todo el direcorio actual y los archivos restantes creados durante la practica
rm -R *
cd ../
rm -R 2018*
cd ../
sudo rm -R p?
#/*=================================================================*/
#/*=========================  End of Main  =========================*/
#/**
# *
# *
# *   Autor: Adrián Epifanio R.H
# *   Fecha: 02/11/2018
# *
# *
#**/


