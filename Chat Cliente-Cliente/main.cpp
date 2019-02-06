/*=========================================================================
===========================================================================
	=			 Proyecto:		Chat Sockets						  =
    =            Archivo:  		main.cpp   		                      =
    =            Autor:         Adrián Epifanio R.H                   =
    =            Fecha:         17/01/2019                            =
    =            Asignatura:    Sistemas Operativos                   =
    =            Lenguaje:      C++                                   = 
===========================================================================          
=========================================================================*/
/**

    Descripcion:
        Implementar un chat mediante sockets, se necesitará compilar dos copias
distintas con puertos enlazados para poder comprobar su funcionamiento.
*/

/*----------  Libraries set  ----------*/
////// L I B R E R I A S ////////////
#include <iostream>			// para std::cout
#include <sys/socket.h>
#include <thread>
#include <atomic>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <string>			// para std::string()
#include <cstdlib>			// para std::getenv() y std::setenv()
#include <csignal>			// para señales

////// F I C H E R O S ///////////////
#include "socket.hpp"
#include "function.cpp"
#include "socket.cpp"


/*====================================
=            MAIN PROGRAM            =
====================================*/
int main(int argc, char* argv[])
{
	try
	{
		// Cuando llegue SIGINT, SIGTERM o SIGHUP, invocamos int_signal_handler
		std::signal(SIGINT, &int_signal_handler);
		std::signal(SIGTERM, &int_signal_handler);
		std::signal(SIGHUP, &int_signal_handler);

		//Creamos un string message_text
		std::string message_text;

		//Creamos un message de la estructura message
		Message message;
		//Creamos direccion_local y direccion_destino de la estructura sockaddr_in
		sockaddr_in direccion_local;
		sockaddr_in direccion_destino;

		//Con las variables recien creadas les asignamos una ip a cada una llamando a la funcion creada "make_ip_adress"
		direccion_local = make_ip_address("127.0.0.2", 13001);
		Socket socket(direccion_local);
		direccion_destino = make_ip_address("127.0.0.1", 12001);

		//Creamos dos hilos que llamen a las funciones "send_thread" y "recive_thread" pasandoles todos los argumentos en el mismo orden para que no nos tire ningun error
		std::exception_ptr eptr1 {};
		//Tenemos que pasar el socket, la direccion destino y eptr por referencia para que no nos de error
		std::thread my_thread1(&send_thread, std::ref(socket), message_text, message, std::ref(direccion_destino), std::ref(eptr1));
		std::exception_ptr eptr2 {};
		std::thread my_thread2(&recive_thread, std::ref(socket), message, std::ref(direccion_destino), std::ref(eptr2));

		// Esperamos a que un hilo termine...
		while (!quit);

		// Matamos a todos los hilos
		request_cancellation(my_thread1);
		request_cancellation(my_thread2);

		// Esperamos a que mueran antes de terminar
		my_thread1.join();		// Bloquear el hilo principal hasta que my_thread1 termine
		my_thread2.join();		// Bloquear el hilo principal hasta que my_thread2 termine

		// Si el hilo terminó con una excepción, relanzarla aquí.
		if (eptr1)
		{
			std::rethrow_exception(eptr1);
		}
			if (eptr2)
		{
			std::rethrow_exception(eptr2);
		}
		
	}
	//Intentamos localizar excepciones
	catch(std::bad_alloc& e)
	{
		std::cerr << "mytalk" << ": memoria insuficiente\n";
		return 1;
	}
	catch(std::system_error& e)
	{
		std::cerr << "mitalk" << ": " << e.what() << '\n';
		return 2;
	}
	catch (...)
	{
		std::cout << "Error desconocido\n";
	}
	//catch (const std::exception& e) {
	//	eptr = std::current_exception();
	//}

	return 0;	//Finalizamos el programa correctamente con un return 0
}


/*==========================*/
/*=====  End of Main  ======*/
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/






