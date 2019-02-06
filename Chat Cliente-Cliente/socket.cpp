/*=========================================================================
===========================================================================
	=			 Proyecto:		Chat Sockets						  =
    =            Archivo:    	socket.cpp    	                      =
    =            Autor:         Adrián Epifanio R.H                   =
    =            Fecha:         17/01/2019                            =
    =            Asignatura:    Sistemas Operativos                   =
    =            Lenguaje:      C++                                   = 
===========================================================================          
=========================================================================*/

/*----------  Libraries set  ----------*/
////// L I B R E R I A S ////////////
#include <sys/socket.h>
#include <unistd.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <iostream>
#include <cerrno>
#include <cstring>		// para std::strerror()
#include <stdexcept>
#include <arpa/inet.h>
#include <pthread.h>		// pthread_cancel(my_thread.native_handle());
#include <exception>
#include <atomic>
#include <thread>
#include <csignal>

////// F I C H E R O S ///////////////
#include "socket.hpp"


/*====================================
=            Socket PROGRAM          =
====================================*/
//Implementamos el constructor del socket
Socket::Socket(const sockaddr_in& address)
{
	fd_ = socket(AF_INET, SOCK_DGRAM, 0);
	if (fd_ < 0)
	{
		//Si el socket no se crea correctamente lanzamos un mensaje de error
		throw std::system_error(errno, std::system_category(), "No se pudo crear el socket correctamente");
		std::cerr << "Error en la descripcion del fichero" << std::strerror(errno) << "\n";
		return; 	// Error. Termina el programa 
	}

	//Vincular dicho socket a la dirección de Internet especificada mediante el argumento ‘address’ del constructor, utilizando la llamada al sistema bind().
	int result = bind(fd_, reinterpret_cast<const sockaddr*>(&address), sizeof(address));
	if (result < 0)
	{
		//Si el socket no se crea correctamente lanzamos un mensaje de error
		std::cerr << "Fallo en la direccion de internet, funcion bind()\n";
		return;		// Error. Termina el programa 
	}
}
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/
//Implementamos el destructor del Socket
Socket::~Socket()
{
	//Cerramos fd_ mediante la llamada close()
	close(fd_);
	status_ = close(fd_);
	//En caso de fallo lanzamos un mensje de error
	if (status_ < 0)
		std::cerr << "Error en la descripcion del archivo\n";

}
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/
//Implementamos la funcion send_to
void Socket::send_to(Message& message, const sockaddr_in& remote_address)
{
	//Usamlos la llamada al sistema de la clase Socket sendto() para enviar un mensaje
	int result = sendto(fd_, &message, sizeof(message), 0, reinterpret_cast<const sockaddr*>(&remote_address), sizeof(remote_address));
	//En caso de fallo mandamos un mensaje de error y lanzamos una excepcion
	if (result < 0)
	{
		std::cerr << "Fallo en el send_to: " << std::strerror(errno) << '\n';
		return;
	}

}
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/
//Implementamos la funcion receive_from
void Socket::receive_from(Message& message, sockaddr_in& remote_address)
{
	//Creamos una variable src_len de la calse socklen_t del tamaño de la direccion de destino(remote_address)
	socklen_t src_len = sizeof(remote_address);
	// Recibir un mensaje del socket remoto
	int result = recvfrom(fd_, &message, sizeof(message), 0, reinterpret_cast<sockaddr*>(&remote_address), &src_len);
	//En caso de fallo mandamos un mensaje de error y lanzamos una excepcion
	if (result < 0)
	{
		std::cerr << "Fallo en la funcion de receive_from: " << std::strerror(errno) << '\n';
		return;
	}

}
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/
/*============================*/
/*=====  End of Socket  ======*/






