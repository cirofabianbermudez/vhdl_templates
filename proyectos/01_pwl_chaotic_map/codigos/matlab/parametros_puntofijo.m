clear; close all; clc;

format longG
m1 = 0.8; m2 = 5.0; b1 = 4; a = b1/m1; b2 = a*m2; 
param = [m1 m2 b1 b2 a];
text = ["m1","m2","b1","b2","a"];
% 32 bits
entera = 8;
fraccionaria = 64 - 1 - entera;
rango = [-2^entera 2^entera-2^(-fraccionaria)];
disp(rango);

for i = 1:size(param,2)
    a = dectobin(param(i),entera,fraccionaria);
    aStr = sprintf('%d', a);
    aReal = bintodec(a,entera,fraccionaria);
    fprintf(' %2s <= "%s";\t -- %10.3f \n',text(i),aStr,aReal);
end

param = [0.1];
text = ["x0"];

for i = 1:size(param,2)
    a = dectobin(param(i),entera,fraccionaria);
    aStr = sprintf('%d', a);
    aReal = bintodec(a,entera,fraccionaria);
    fprintf(' %2s <= "%s";\t -- %10.3f \n',text(i),aStr,aReal);
end

