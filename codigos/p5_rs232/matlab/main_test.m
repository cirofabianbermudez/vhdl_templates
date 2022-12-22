%% Cleanup
clear; close all; clc;
%% Generar datos para FPGA
n = 1:1024;                 % Numero de muestras
tp = 2*pi/1023;             % Paso (final-inicial)/(2^(n_bits) -1 )
t = 0:tp:2*pi;              % Vector temporal
y = sinc(t);                 % Funcion senoidal
yn = round((255/2)*(y+1));  % Mapeo lineal
% plot(n,yn);
% grid on;
% grid minor;
%% Abrir comunicacion
sp = serial('COM4','BaudRate',9600,'DataBits',8,'Parity','even','StopBits',1,'ReadAsyncMode','continuous'); 
fopen(sp);
disp(sp);                   % Mostrar info de comunicacion
%% Escribir info en FPGA
% fwrite(sp,1,'uint8','sync');
for i = 1:1024
    fwrite(sp,yn(i),'uint8','sync');
end
disp('Fin de escritura');
%% Recibir info  de la FPGA
% DataC = zero(1,1024);
for i = 1:1024
    DataC(i) = fread(sp,1);
end
disp('Fin de lectura');
%% Cerrar comunicacion
fclose(sp);
delete(sp);
clear sp;


