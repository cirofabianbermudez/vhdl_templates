clear; close all; clc,

arch = 64;
entera = 8;
frac = arch - entera - 1;

minimo = -2^entera;
maximo = 2^entera - 2^(-frac);

fprintf('[%f, %f]\n', minimo, maximo);

