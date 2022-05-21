# PWL sin puntos fijos



## 0. Sistema dinámico

$$
f(x)= \left\{ 
\begin{array}{lcl}
		m_{1}x + b_{1} &  & \text{si }  x \leq -a < 0\\
		m_{2}x + b_{2} &  & \text{si }  -a < x < 0\\
		m_{2}x - b_{2} &  & \text{si }  0 \leq x < a\\
		m_{1}x - b_{1} &  & \text{si }  x \geq a \\
\end{array}
 \right.
$$


$$
\begin{array}{lcl}
		m_{1} & = &  0.8\\
		m_{2} & = &  5\\
		b_{1} & = &  4\\
		    a & = &  5\\
		b_{2} & = &  25\\
\end{array}
$$
y las condiciones iniciales son:
$$
\begin{array}{lcl}
		x_{0} & = &  0.1
\end{array}
$$
___

## 1. Simulación de MATLAB del sistema

```matlab
%%
clear; close all; clc;
m1 = 0.8;
m2 = 5;
b1 = 4;
a = b1/m1;
b2 = m2*a;
x = linspace(-b2,b2,1000);

y = pwl_custom(m1,m2,b1,a,b2,x);
plot(x,y,'.k'); grid on; grid minor;

function R = pwl_custom(m1,m2,b1,a,b2,x)
    R = zeros(size(x));
    for i = 1:numel(x)
        if x(i) <= -a && -a < 0
            R(i) = m1*x(i) + b1;
        elseif -a < x(i) && x(i) < 0
            R(i) = m2*x(i) + b2;
        elseif 0 <= x(i) && x(i) < a
            R(i) = m2*x(i) - b2;
        else
            R(i) = m1*x(i) - b1;
        end
    end

end
```

<img src="images/simu.jpg" alt="simu" style="zoom:60%;" />



```matlab
%%
clear; close all; clc;
m1 = 0.8;
m2 = 5;
b1 = 4;
a = b1/m1;
b2 = m2*a;

% x = linspace(-b2,b2,1000);
% y = pwl_custom(m1,m2,b1,a,b2,x);
% plot(x,y,'.k'); grid on; grid minor;

iter = 10000;
x0 = 0.1;
y = zeros(1,iter);
y(1) = x0;
for i=2:iter
    y(i) = pwl_custom(m1,m2,b1,a,b2,y(i-1));
end

plot(y,'.k'); grid on; grid minor;

function R = pwl_custom(m1,m2,b1,a,b2,x)
    R = zeros(size(x));
    for i = 1:numel(x)
        if x(i) <= -a && -a < 0
            R(i) = m1*x(i) + b1;
            fprintf('Caso 1\n');
        elseif -a < x(i) && x(i) < 0
            R(i) = m2*x(i) + b2;
            fprintf('Caso 2\n');
        elseif 0 <= x(i) && x(i) < a
            R(i) = m2*x(i) - b2;
            fprintf('Caso 3\n');
        else
            R(i) = m1*x(i) - b1;
            fprintf('Caso 4\n');
        end
    end

end
```



<img src="images\matlab_simu.jpg" alt="matlab_simu" style="zoom:80%;" />

## 2. Simulación para determinar punto fijo

Estimamos que la resultado más grande de la aritmética interna esta alrededor de 150, por lo tanto necesitamos $2^8 = 256$ para la parte entera.

## 3. Diagrama a bloques del sistema 

<img src="images\system_imp.svg" alt="system_imp" style="zoom:80%;" />

## 4. Fixed point analysis

| Variable | Number of bits | Format    | Move point | Range $[-2^{a},2^{a}-2^{-b}]$ |
| -------- | -------------- | --------- | ---------- | ----------------------------- |
| $X$      | $64$ bits      | $X(8,55)$ | $55$       | $[-256,256]$                  |



## 5. Simulación en C

```c
/*
    Autor: 		 Ciro Fabian Bermudez Marquez y Claudio Garcia Grimaldo
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
	    //printf("Caso 1\n");
		r = multTrunc( x, m1 ) + b1;
	}else if(-a < x && x < zero){
	    //printf("Caso 2\n");
		r = multTrunc( m2, x ) + b2;
	}else if(zero <= x && x < a){
	    //printf("Caso 3\n");
		r = multTrunc( m2, x ) - b2;
	}else{
	    //printf("Caso 4\n");
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
// gcc -o simulation main.c -lm
// ./simulation 
// gnuplot -e "filename='salida.txt'" graph.gnu
```

<img src="images/c_simulation.png" alt="c_simulation" style="zoom:80%;" />



## 6. Simulación en C HEX

````c
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
	    //printf("Caso 1\n");
		r = multTrunc( x, m1 ) + b1;
	}else if(-a < x && x < zero){
	    //printf("Caso 2\n");
		r = multTrunc( m2, x ) + b2;
	}else if(zero <= x && x < a){
	    //printf("Caso 3\n");
		r = multTrunc( m2, x ) - b2;
	}else{
	    //printf("Caso 4\n");
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
	
	printf("x0=%.16lx\n\n", x_n);
    printf("m1=%.16lx\nm2=%.16lx\nb1=%.16lx\na=%.16lx\nb2=%.16lx\n", m1pf,m2pf,b1pf,apf,b2pf );
    
	fprintf(fpointer,"%.16lx\n", x_n );
    for(int i = 0; i < 10; i++){

        x_ni = pwl_custom( m1pf, m2pf, b1pf, apf, b2pf, x_n );
        x_n = x_ni;
       
        fprintf(fpointer,"%.16lx\n", x_n  );
    }
    
	fclose(fpointer);								// Cerrar archivo de texto
	return 0;
}
// gcc -o simulation simulation.c
// ./simulation 
// gnuplot -e "filename='salida.txt'" graph.gnu
````



Salida

```
m1=0066666666666668
m2=0280000000000000
b1=0200000000000000
a=0280000000000000
b2=0c80000000000000
x0=000ccccccccccccd
```



```
000ccccccccccccd
f3c0000000000001
f83333333333330c
fbc28f5c28f5c257
fe9ba5e353f7ce9e
058a3d70a3d70916
026e978d4fdf3a89
ffa8f5c28f5c24ad
0accccccccccb761
06a3d70a3d7092d6
034fdf3b645a0f26
```





## 7. VHDL codes

A continuación se muestran todos los bloques:

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	generic( n : integer := 64 );
	port(
        T1,T2	 : in   std_logic_vector(n-1 downto 0);
        S1	     : out  std_logic_vector(n-1 downto 0) 
	);
end;	

architecture arch of adder is
begin	
	S1 <= std_logic_vector( signed(T1) + signed(T2) );
end arch;										
```

**Código: adder.vhd**





```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sub is
	generic( n : integer := 64 );
	port(
        T1,T2	 : in   std_logic_vector(n-1 downto 0);
        S1	     : out  std_logic_vector(n-1 downto 0) 
	);
end;	

architecture arch of sub is
begin	
	S1 <= std_logic_vector( signed(T1) - signed(T2) );
end arch;											
```

**Código: sub.vhd**





```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult is
    generic( n  :   integer := 64);
    port(
        A   : in    std_logic_vector(n-1 downto 0);
        B   : in    std_logic_vector(n-1 downto 0);
        M   : out   std_logic_vector(n-1 downto 0)
    );
end;    

architecture arch of mult is
signal temp : std_logic_vector(2*n-1 downto 0);
begin   												  
    temp <= std_logic_vector(signed(A)*signed(B));
    M <= temp(118 downto 55);
end arch;

-- El formato es  A(a ,b ) = (8,55)
--               Ap(ap,bp) = (16,110)
-- lim_izq = bp + a = 110 + 8 = 118
-- lim_der = bp - b = 110 - 55 = 55								
```

**Código: mult.vhd**





```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity ff_hab is
	generic(n : integer := 64);
	port(
		RST	:	in	std_logic;
		CLK	:	in	std_logic; 
		HAB	:	in	std_logic_vector(1 downto 0);
		D	:	in	std_logic_vector(n-1 downto 0);
		Q	:	out	std_logic_vector(n-1 downto 0)
	);	
end;

architecture ff of ff_hab is
signal Qn, Qp : std_logic_vector(n-1 downto 0);
begin		 
--	Qn <= Qp when HAB = '0' else D;	 
	with HAB select
	Qn <=  	                 (others => '0') when "00",	  -- Reset
										   D when "01",	  -- Pasar
										  Qp when others; -- Mantener
	process(RST, CLK)
	begin
		if RST = '1' then
			Qp <= (others => '0');
		elsif rising_edge(CLK) then
			Qp <= Qn;
		end if;
	end process; 
	Q <= Qp;
end ff;
```

**Código: ff_hab.vhd**





```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity rom is
	generic( n : integer := 64 ); 		 -- tamaño de palabra
	port(
		m1,m2,b1,b2,a,x0: out	std_logic_vector(n-1 downto 0)
	);	
end rom;					 

architecture arch of rom is
begin	  	
 m1 <= "0000000001100110011001100110011001100110011001100110011001101000";	 --      0.800 
 m2 <= "0000001010000000000000000000000000000000000000000000000000000000";	 --      5.000 
 b1 <= "0000001000000000000000000000000000000000000000000000000000000000";	 --      4.000 
 b2 <= "0000110010000000000000000000000000000000000000000000000000000000";	 --     25.000 
  a <= "0000001010000000000000000000000000000000000000000000000000000000";	 --      5.000 
 x0 <= "0000000000001100110011001100110011001100110011001100110011001101";	 --      0.100
	 
	 
end arch;

```

**Código: rom.vhd**





```vhdl
library ieee;
use ieee.std_logic_1164.all;               

entity mux is
    generic( n : integer := 64);  -- Tamanio de palabra
    port(
        X0  : in std_logic_vector(n-1 downto 0);
        Xn_1: in std_logic_vector(n-1 downto 0);       
        SEL : in std_logic;
        Xn  : out std_logic_vector(n-1 downto 0)
    );
end;              

architecture arch of mux is
begin
    Xn <= X0 when SEL = '0' else Xn_1;
end arch;
```

**Código: mux.vhd**





```vhdl
library IEEE;
use IEEE.std_logic_1164.all;  

entity mux_4_1 is  
	generic(n : integer :=32 ); --- arquitectura de n-bits
	port( 
		f0,f1,f2,f3:in std_logic_vector(n-1 downto 0);	
		SEL: in std_logic_vector(1 downto 0);
		F_OUT:out std_logic_vector(n-1 downto 0)
	);
end;  
--Arquitectura
architecture arch of mux_4_1 is	 
constant zero: std_logic_vector(n-1 downto 0):=(others=>'0');

begin							 
	
F_OUT<=     f0 when SEL="00" else 
			f1 when SEL="01" else 
			f2 when SEL="10" else
			f3 when SEL="11" else 
		    zero;
	
end;
              
```

**Código: mux_4_1.vdl**





```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity encoder is
	port(
	cond 		: 	in 	std_logic_vector(3 downto 0);	--valores del condicional
	sel	        : 	out	std_logic_vector(1 downto 0) --valores del selector
	);
end;		 

architecture arch of encoder is
begin
	with cond select

	sel <=   "00" when "0001", --  "1"     
			 "01" when "0010", --  "2" 
			 "10" when "0100", --  "4" 
			 "11" when "1000", --  "8" 
			 "00" when others;
					 
end arch;
```

**Código: encoder.vdl**



```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comp is
	generic( n : integer := 64 );
	port(
	A,X	 : in   std_logic_vector(n-1 downto 0);
     C	 : out  std_logic_vector(3 downto 0)
	);
end;	

architecture arch of comp is
signal zero : std_logic_vector(n-1 downto 0) := (others =>'0');
begin
		C(0) <= '1' when signed(X) <= -signed(A) else '0';
		C(1) <= '1' when ( -signed(A) < signed(X)  ) and (signed(x) < signed(zero))  else '0';	
		C(2) <= '1' when (signed(zero) <= signed(X)) and (signed(x) < signed(A)   )  else '0';	   
		C(3) <= '1' when (signed(x) >= signed(A))  else '0';
end arch;		
```

**Código: comp.vdl**



### 7.1. Diseño de maquina de estado

Los registros funcionan con la siguiente lógica:

| HAB         | Accion        |
| ----------- | ------------- |
| `00`        | Reset         |
| `01`        | Pasar dato    |
| `10` o `11` | Mantener dato |

Los mux funcionan con la siguiente lógica:

| SEL  | Salida            |
| ---- | ----------------- |
| `0`  | Condición inicial |
| `1`  | Retroalimentación |



<img src="images\fsm.svg" alt="fsm" style="zoom:100%;" />

La maquina de estado funciona teniendo en cuenta la señal de entrada `START` la cual el usuario controla con un switch de la FPGA o puede utilizarse como señal interna de comienzo para interconectarse con otros sistemas. Al encenderse el sistema, `SEL` esta en `0` y `HAB` en `00`, por tanto en la salida de los multiplaxores se encuentra la condición inicial y los registros inicializan con cero, casi instantaneamente se realizan todas las operaciones del sistema en paralelo pero no es hasta que `START` este en `1` que pasa al siguiente estado y se almacenan los resultados en los registros, `SEL` se mantiene en `0` para no alterar la operación actual. Despues de esa primera iteración se pasa al siguiente estado donde `SEL` es igual a`1` y `HAB` a `11`, los registros pasan a mantener su estado actual, y a la salida de los multiplexores ahora tenemos los valores de los registros, otra vez, de manera casi inmediata se realiza el cálculo y dependiendo si `START` es igual `1` o `0` se guada el resultado en los registros o mantiene su valor. De esta manera podemos calcular cada iteración dependiendo unicamente de la señal `START`, 

```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity cu is
  port(
    RST     : in   std_logic;
    CLK     : in   std_logic;
    START   : in   std_logic;
    HAB     : out  std_logic_vector(1 downto 0);
    SEL     : out  std_logic
  );
end;

architecture fsm of cu is
    signal Qp, Qn  : std_logic_vector(1 downto 0); -- porque son 6 estados
begin
  
  process(Qp,START) 
  begin
    case Qp is
     when "00" => SEL <= '0'; HAB <= "00";           -- espera 1 
        if START = '1' then 
          Qn <= "01";
        else 
          Qn <= Qp;
        end if;
     when "01" => SEL <= '0'; HAB <= "01";           -- habilita 1         
          Qn <= "10";
     when "10" => SEL <= '1'; HAB <= "11";           -- espera 2
        if START = '1' then 
          Qn <= "11";
        else 
          Qn <= Qp;
        end if;
     when "11" => SEL <= '1'; HAB <= "01";            -- habilita 2
        Qn <= "10";
     when others => SEL <= '0';  HAB <= "11";         -- default
        Qn <= "00";
    end case;
  end process;

  -- Registros para estados
  process(RST,CLK)
  begin
    if RST = '1' then
      Qp <= (others => '0');
    elsif rising_edge(CLK) then
      Qp <= Qn;
    end if;
  end process;

end fsm;
```

**Código: cu.vhd**



```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is 
	generic( n : integer := 64);  -- Tamanio de palabra
	port(	
		CLK   : in  std_logic;
		RST   : in  std_logic;
		START : in  std_logic;
		XOUT  : out std_logic_vector(n-1 downto 0)
);
end;

architecture Behavioral of top is		 
	signal SEL :std_logic;
	signal SEL2, HAB: std_logic_vector(1 downto 0);	 
	signal C1 : std_logic_vector(3 downto 0);
	signal Xn,Xn_1,M1,M2,S1,S2,A1,A2,Fx: std_logic_vector(n-1 downto 0);
	signal m1_rom, m2_rom, b1_rom, b2_rom, a_rom, x0_rom : std_logic_vector(n-1 downto 0);
begin		

	
--Bloque Mux1 para escoger entre condicion inicial y xn
comp_mux01  : entity work.mux generic map(n => 64) port map(x0_rom,Xn_1,SEL,Xn);

--Bloque de la maquina de estados	 
comp_cu: entity work.cu port map(RST,CLK,START,HAB,SEL);   
	
--Bloque comparador para determinar el intervalo donde se encuentra Xn
comp_comp  : entity work.comp generic map(n => 64) port map(a_rom,Xn,C1);		
	
--Bloque del segundo selector para determinar el valor de f	 
 comp_cod  : entity work.encoder  port map(C1,SEL2);	 
	 
--Bloque para guardar los valores de los parametros
comp_rom : entity work.rom generic map(n => 64) port map(m1_rom,m2_rom,b1_rom,b2_rom,a_rom,x0_rom);	
	
--BLoques multiplicadores 
 comp_mult01   : entity work.mult generic map(n => 64) port map(m1_rom,Xn,M1);
 
 comp_mult02   : entity work.mult generic map(n => 64) port map(m2_rom,Xn,M2);

--Bloques sumadores
 comp_adder01  : entity work.adder generic map(n => 64) port map(M1,b1_rom,A1); 	  
	 
 comp_adder02  : entity work.adder generic map(n => 64) port map(M2,b2_rom,A2); 
	 
--Bloques restadores	
 comp_sub01    : entity work.sub generic map(n => 64) port map(M1,b1_rom,S1);	
	
 comp_sub02    : entity work.sub generic map(n => 64) port map(M2,b2_rom,S2);

	 
 --Bloque para escoger el umbral adecuado	 	 				
comp_mux_PWL  : entity work.mux_4_1 generic map(n => 64) port map(A1,A2,S2,S1,SEL2,Fx);  
	
--Bloque de registro que permite obtener las iteraciones o pararlas	 
comp_ff_hab: entity work.ff_hab generic map(n => 64)  port map(RST,CLK,HAB,Fx,Xn_1);	
	
--Salida  
XOUT <= Xn_1;	

end Behavioral;

```

**Código: top.vhd**



```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity tb_pwl is
	generic(n : integer := 64);
end entity;

architecture tb of tb_pwl is
	signal		RST,CLK,START	:	std_logic := '0';
	signal		xn			    :	std_logic_vector(n-1 downto 0);
begin 
	
	UUT	: entity work.top generic map(n => 64) port map(CLK,RST,START,xn);
	RST <= '1', '0' after 20 ns;
	CLK <= not CLK after 10 ns;				-- La mitad del perido que es 20 ns
	
	
	START <= '1' after 200 ns, '0' after 200000 ns;
	
	-- NOTA: Simular por almenos 1000 ns	   
	-- wait for 10 ns;
end architecture;
```

**Código: tb_pwl .vhd**



## 8. Simulación VHDL

Los valores de las condiciones iniciales y de los parametros en hexadecimal son los siguientes

<img src="images\hex_param.png" alt="hex_param" style="zoom:80%;" />



<img src="images\vhdl_simu.png" alt="vhdl_simu" style="zoom:150%;" />

Estos son las primeras iteraciones la simulación en C en hexadecimal, como podemos notar son exactamente los mismos resultados, por lo tanto la arquitectura esta lista para pasarse a la FPGA.

```
000ccccccccccccd
f3c0000000000001
f83333333333330c
fbc28f5c28f5c257
fe9ba5e353f7ce9e
058a3d70a3d70916as
026e978d4fdf3a89
ffa8f5c28f5c24ad
0accccccccccb761
06a3d70a3d7092d6
034fdf3b645a0f26
```



## 9. Notas personales

* Para poder realizar verdaderamente un analisis de punto fijo del sistema es necesario analizar operación por operación para descubrir cuales son los límites máximos y mínimos, además de eso ejecutar el programa un tiempo razonable, no basta con analizar los límites de las variables de estado, por esta razón modifique el programa de análisis de punto fijo de matlab, además, noté que cambiar el orden de las operaciones modifica ligeramente el atractor, afortunadamente no su cualidad de ser caótico, por lo anterior también se modifican los límites máximos y mínimos ligeramente. Una vez determinados los límites se selecciona el mínimo número de bits para la parte entera, en este caso particular el límite es |1583| por lo tanto se seleccionaron 11 bits para la parte entera, la parte fraccionaria se elige seleccionando una arquitectura, de 16, 32 o 64 bits y despues restando la parte entera y el bit de signo a la arquitectura seleccionada. Esto es conveniente porque nos permite hacer una simulación en C antes de saltar a la descripción de VHDL y evitar perder tiempo buscando errores. Se pueden cometer errores de sintaxis, los cuales se solucionan facilmente pero no errores de diseño.
* En el código de **mult.vhd** estan las ecuaciones para no perder tiempo al extraer los bit en punto fijo,

