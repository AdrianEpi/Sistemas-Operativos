/*=========================================================================
===========================================================================
	=			 Proyecto:		Chat Sockets						  =
    =            Archivo:    	socket.hpp                        	  =
    =            Autor:         Adrián Epifanio R.H                   =
    =            Fecha:         17/01/2019                            =
    =            Asignatura:    Sistemas Operativos                   =
    =            Lenguaje:      C++                                   = 
===========================================================================          
=========================================================================*/


/*----------  Libraries set  ----------*/
#ifndef SOCKET_HPP
#define SOCKET_HPP
#include <netinet/ip.h>
#include <thread>


/*====================================
=            Class Socket            =
====================================*/
//Creamos una estructura del tipo Message
struct Message{

	char text[1024];

};
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/
//Creamos la clase Socket
class Socket
{
	//Definimos los metodos privados de la clase
	private:
		int fd_;
		int status_;


	//Defininmos los metodos publicos de la clase
	public:

		Socket(const sockaddr_in& address);								//Constructor
		~Socket();														//Destructor
		void send_to(Message& message, const sockaddr_in& address);		//Funcion para enviar mensajes
		void receive_from(Message& message, sockaddr_in& address);		//Funcion para recibir mensajes


};
#endif //Socket.hpp

/*===========================*/
/*=====  End of Class  ======*/





