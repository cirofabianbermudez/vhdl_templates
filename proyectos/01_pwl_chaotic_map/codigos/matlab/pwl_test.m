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
%         R(i) = mod( R(i), 2);
    end

end
