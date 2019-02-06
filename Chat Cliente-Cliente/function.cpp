/*=========================================================================
===========================================================================
	=			 Proyecto:		Chat Sockets						  =
    =            Archivo:    	function.cpp  	                      =
    =            Autor:         Adrián Epifanio R.H                   =
    =            Fecha:         17/01/2019                            =
    =            Asignatura:    Sistemas Operativos                   =
    =            Lenguaje:      C++                                   = 
===========================================================================          
=========================================================================*/

/*----------  Libraries set  ----------*/
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


/*====================================
=            Functions	             =
====================================*/
//Declaramos una estructura singhander
typedef void (*sighandler_t)(int);
sighandler_t signal(int signum, sighandler_t handler);
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/
//Declaramos una variable booleana
std::atomic<bool> quit(false);
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/
//Recibe una direccion ip como cadena y un puerto como entero. Devuelve una estructura sockaddr_in
sockaddr_in make_ip_address(const std::string& ip_address, int port) 
{
	int puerto;
	// Dirección del socket remoto
	sockaddr_in remote_address{};	// Porque se recomienda inicializar a 0
	remote_address.sin_family = AF_INET;
	remote_address.sin_port = htons(puerto);
	//Si la dirección IP en ip_address es una cadena vacía "", la dirección IP almacenada en sockaddr_in deberá ser INADDR_ANY.
	if (ip_address.empty())
	{
		remote_address.sin_addr.s_addr = INADDR_ANY;
	}
	else
	{
		inet_aton(ip_address.c_str(), &remote_address.sin_addr);
	}
	remote_address.sin_port = htons(port);
	return remote_address;
}
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/
//Hilo para enviar mensajes al otro usuario
void send_thread(Socket socket, std::string message_text, Message message, sockaddr_in direccion_destino, std::exception_ptr& eptr)
{
	// Primero bloqueamos la señal SIGINT y SIGTERM para este hilo.
	sigset_t set;
	sigset_t set2;
	sigaddset(&set, SIGINT);
	sigaddset(&set2, SIGTERM);

	pthread_sigmask(SIG_BLOCK, &set, nullptr);
	pthread_sigmask(SIG_BLOCK, &set2, nullptr);

	try
	{
		//Solicitamos que se finalicen todas las solicitudes de cancelacion de hilos
		pthread_testcancel();
		//Hacemos un bucle para que se repita para infinitos mensajes hasta que el usuario teclee "exit"
		do
		{
			//Recibimos una entrada por teclado
			std::getline(std::cin, message_text);
			message_text.copy(message.text, sizeof(message.text) -1, 0);
			message.text[message_text.size()] = '\0';

			//LLamamos a la funcion send_to para enviar un mensaje y le pasamos los parametros del string leido anteiormente y la direccion de destino
			socket.send_to(message, direccion_destino);

		}while (message_text != "exit");
	}
	//Intentamos localizar excepciones
	catch(std::system_error& e)
	{
		std::cerr << "mitalk" << ": " << e.what() << '\n';
	}
	catch (...)
	{
		eptr = std::current_exception();
	}

	// En caso de excepción el hilo terminará solo por aquí.
	// Se acabó. Este hilo se va para casa...
	quit = true;

}
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/
//Hilo para recibir mensajes del otro usuario
void recive_thread(Socket socket, Message message, sockaddr_in direccion_destino, std::exception_ptr& eptr)
{
	try
	{
		//Solicitamos que se finalicen todas las solicitudes de cancelacion de hilos
		pthread_testcancel();
		//Hacemos un bucle para que se repita para infinitos mensajes hasta que el usuario teclee "exit"
		do
		{
			//LLamamos a la clase receive_from y le pasamos por parametros el mensaje y la direccion de destino
			socket.receive_from(message, direccion_destino);

			// Vamos a mostrar el mensaje recibido en la terminal
			// Primero convertimos la dirección IP como entero de 32 bits en una cadena de texto.
			char* remote_ip = inet_ntoa(direccion_destino.sin_addr);
			// Recuperamos el puerto del remitente en el orden adecuado para nuestra CPU
			int remote_port = ntohs(direccion_destino.sin_port);
			// Imprimimos el mensaje y la dirección del remitente
			std::cout << "El sistema " << remote_ip << ":" << remote_port << " envió el mensaje '" << message.text << "'\n";

		}while (message.text != "exit");

	}
	//Intentamos localizar excepciones
	catch(std::system_error& e)
	{
		std::cerr << "mitalk" << ": " << e.what() << '\n';
	}
	catch (...)
	{
		eptr = std::current_exception();
	}
	//En caso de excepcion el hilo acabara solo por aqui
	// Se acabó. Este hilo se va para casa...
	quit = true;
}
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/
//Funcion de deteccion de señales
void int_signal_handler(int signum)
{
	//En caso de detectar una señal indicamos por patalla de que tipo y finalizamos el programa
	if (signum == SIGINT)
	{
		write(1, "¡Señal SIGINT interceptada!\n", 1);
	}
	else if (signum == SIGTERM)
	{
		write(1, "¡Señal SIGTERM interceptada!\n", 1);
	}
	else if (signum == SIGHUP)
	{
		write(1, "¡Señal SIGUP interceptada!\n", 1);
	}

	quit = true;
}
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/
//Implementamos la funcion de cancelacion de hilos
void request_cancellation(std::thread& my_thread)
{
	//Lanzamos un mensaje para informar de que se ha cancelado el hilo
	std::cout << "Thread Cancelled \n";
	pthread_cancel(my_thread.native_handle());
}
/**
 *
 *
 *   Autor: Adrián Epifanio R.H
 *   Fecha: 17/01/2019
 *
 *
**/
/*===============================*/
/*=====  End of Functions  ======*/







