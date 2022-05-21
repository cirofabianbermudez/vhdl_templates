%%
clear; close all; clc;
m1 = 0.8;
m2 = 5;
b1 = 4;
a = b1/m1;
b2 = m2*a;
iter = 16;
x = 0.1;
r = zeros(1,iter);
r(1) = x;
for i = 2:iter
    r(i) = pwl_custom(m1,m2,b1,a,b2,r(i-1));
end

plot(r,'.k'); grid on; grid minor;


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
%         R(i) = mod( R(i), 2);
    end

end

