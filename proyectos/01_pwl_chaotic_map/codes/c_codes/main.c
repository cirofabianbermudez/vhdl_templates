/*
    Autor: 		 Ciro Fabian Bermudez Marquez
    Descripción: Simulador de diseños en VHDL de 64 bits en punto fijo
*/
/* Librerias*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

/* Variables globales */
int _a;			// parte entera
int _b;			// parte fraccionaria
long _power;	// factor de conversion

/*Funciones*/

// Inicializacion A(a,b) representacion en punto fijo
void inicializa( int a, int b ){        
	_a = a;					// _a: parte entera
    _b = b;					// _b: parte fraccionaria
    _power = (long)1 << _b;	// calculo de factor de conversion
}

// Convierte a punto fijo con truncamiento 
long setNumber( double v ){
    return ( (long)(v*_power) );
}

// Convierte de vuelta a punto flotante
double getNumber( long r ){
    return ( (double)r/_power);
}

// Multiplicacion de punto fijo con truncamiento
long multTrunc( long x, long y ){
    __int128 r;
    __int128 a=0;
    __int128 b=0;
    a = x;
    b = y;
    r = a*b;
    r = r >> _b;
    return( r );
}

long pwl_custom( long m1, long m2, long b1, long a, long b2, long x ){
	long r;
	long zero = setNumber( 0.0 );
	if(x <= -a && -a < zero){
	    printf("Caso 1\n");
		r = multTrunc( x, m1 ) + b1;
	}else if(-a < x && x < zero){
	    printf("Caso 2\n");
		r = multTrunc( m2, x ) + b2;
	}else if(zero <= x && x < a){
	    printf("Caso 3\n");
		r = multTrunc( m2, x ) - b2;
	}else{
	    printf("Caso 4\n");
		r = multTrunc( m1, x ) - b1;
	}
	return( r );
}




int main(int argc, char *argv[]){
    FILE *fpointer = fopen("salida.txt","w");	    // Archivo de texto
	
    // Arq: 64 bits entera + frac + 1 = 64
    int entera = 8;
    int frac;
    frac = 64 - 1 - entera;
    
    // Variables y parametros de simulacion
	// Condiciones iniciales
	double x_0 = 0.1;
	
	// Parametros
	double m1 = 0.8;
	double m2 = 5.0;
	double b1 = 4.0;
	double  a = 5.0;
	double b2 = 25.0;
	
	
	// Variables para algoritmo en punto fijo
	long x_n;       // Actual
    long x_ni;		// Siguiente
	long m1pf, m2pf, b1pf, apf, b2pf;
    
    // Inicializacion de arq
    inicializa(entera, frac);
    printf(" Representacion A(a,b) = A(%d,%d)\n a: entera\tb: fraccionaria\n",entera,frac);
    printf(" Rango: [%30.20f,%30.20f] = \n", -pow(2.0,entera),pow(2.0,entera)-pow(2.0,-frac));
    
    // Conversion a punto fijo
	
	x_n = setNumber( x_0 );

	m1pf = setNumber( m1 );
	m2pf = setNumber( m2 ); 
	b1pf = setNumber( b1 );
	apf  = setNumber( a );
	b2pf = setNumber( b2 );
	
	printf(" # x_0:      %12.8f\n # x_0 real: %12.8f\n", x_0, getNumber( x_n ) );

	printf(" # m1:      %12.8f\n # m1 real: %12.8f\n", m1, getNumber( m1pf ) );
	printf(" # m2:      %12.8f\n # m2 real: %12.8f\n", m2, getNumber( m2pf ) );
	printf(" # b1:      %12.8f\n # b1 real: %12.8f\n", b1, getNumber( b1pf ) );
	printf(" #  a:      %12.8f\n # a  real: %12.8f\n",  a, getNumber(  apf ) );
	printf(" # b2:      %12.8f\n # b2 real: %12.8f\n", b2, getNumber( b2pf ) );
	
	
    
	fprintf(fpointer,"%20.15f\n",getNumber( x_n ));
    for(int i = 0; i < 10; i++){

        x_ni = pwl_custom( m1pf, m2pf, b1pf, apf, b2pf, x_n );
        x_n = x_ni;
       
        fprintf(fpointer,"%20.15f\n",getNumber( x_n ) );
    }
    
	fclose(fpointer);								// Cerrar archivo de texto
	return 0;
}
// gcc -o simulation simulation.c
// ./simulation 
// gnuplot -e "filename='salida.txt'" graph.gnu