function F = find_borders(Y_0, Y_end, N, N_shift_left, N_shift_right, d)
% Находится граничные точки y_left, y_right вида [y   y'   y''], для
% которых кривая выходит за ограничение; N_shift_left, N_shift_right -
% сдвиг влево и вправо на соответствующее количество шагов. N - количество
% разбиений исходного отрезка по y
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
        y_left(1) = Y_0(1) + (i-1 - N_shift_left)*dy;  % отступили N_shift шагов назад от критической точки
        y_left(2) = Psi(i - 1 - N_shift_left);
        y_left(3) = (c1 + 2*c2*(y_left(1) - Y_0(1)) + 3*c3*(y_left(1) - Y_0(1))^2 + ...
            2*d*(y_left(1) - Y_0(1))*(y_left(1) - Y_end(1))^2 + ...
            2*d*(y_left(1) - Y_0(1))^2*(y_left(1) - Y_end(1)) )*y_left(2);
        flag = 1;
    end
    if ((flag==1)&&(Psi(i) < constr))
        y_right(1) = Y_0(1) + (i + N_shift_right)*dy;
        y_right(2) = Psi(i + N_shift_right);
        y_right(3) = (c1 + 2*c2*(y_right(1) - Y_0(1)) + 3*c3*(y_right(1) - Y_0(1))^2 + ...
            2*d*(y_right(1) - Y_0(1))*(y_right(1) - Y_end(1))^2 + ...
            2*d*(y_right(1) - Y_0(1))^2*(y_right(1) - Y_end(1)) )*y_right(2);
        break;
    end
end

if (flag == 1)
    F = [y_left; y_right];
else 
    F = 0;
end