function F = PointDef(Y_0, Y_end, N, d)
% Находятся новые граничные точки y_left, y_right в виду [y  y'  y''].
% Таким образом что новое значение y_left(1) находится посредине между старым
% значением Y_0(1) и y (левым), при котором кривая выходит за ограничение.
% Новое значение y_right(1) ищется посредине между старым значением Y_end(1) 
% и правым концом отрезка, на котором кривая выходит за ограничение.  
global constr

delta = Y_end(1) - Y_0(1);

c0 = Y_0(2);
c1 = Y_0(3)/Y_0(2);

Ma = [delta^2     delta^3;
      2*delta     3*delta^2];
  
Mb = [Y_end(2) - c1*delta - c0;
      Y_end(3)/Y_end(2) - c1];
Mc = inv(Ma)*Mb;

c2 = Mc(1);
c3 = Mc(2);

dy = (Y_end(1) - Y_0(1))/N;

y=Y_0(1):dy:Y_end(1);
Psi = c0 + c1*(y - Y_0(1)) + c2*(y - Y_0(1)).^2 + c3*(y - Y_0(1)).^3+ ...
            d*((y - Y_0(1)).^2).*(y - Y_end(1)).^2;


flag = 0;
for i=1:(N+1)
    if ((flag == 0)&&(Psi(i) >= constr))
        i_1 = floor((i - 1)/2);
        
        flag = 1;
    end
    if ((flag==1)&&(Psi(i) < constr))
        i_2 = floor((N + 1  - i)/2 + i);
        break;
    end
end

if (flag == 1)
    y_left(1) = Y_0(1) + i_1*dy;  
    y_left(2) = Psi(i_1);
    y_left(3) = (c1 + 2*c2*(y_left(1) - Y_0(1)) + 3*c3*(y_left(1) - Y_0(1))^2 + ...
            2*d*(y_left(1) - Y_0(1))*(y_left(1) - Y_end(1))^2 + ...
            2*d*(y_left(1) - Y_0(1))^2*(y_left(1) - Y_end(1)) )*y_left(2);
        
    y_right(1) = Y_0(1) + i_2*dy;
    y_right(2) = Psi(i_2);
    y_right(3) = (c1 + 2*c2*(y_right(1) - Y_0(1)) + 3*c3*(y_right(1) - Y_0(1))^2 + ...
            2*d*(y_right(1) - Y_0(1))*(y_right(1) - Y_end(1))^2 + ...
            2*d*(y_right(1) - Y_0(1))^2*(y_right(1) - Y_end(1)) )*y_right(2);
        
    F = [y_left; y_right];
else 
    F = 0;
end