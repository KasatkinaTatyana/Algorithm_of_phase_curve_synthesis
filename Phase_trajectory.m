clear all
close all
clc

global constr
% 1) y' < constr

Y_0 = [0.1 0.2 2];
Y_end = [0.6 0.5 0.5];

% Строится кривая, которая соединяет точки Y_0 и Y_end в виде
% y' = c0 + c1*(y - y0) + c2*(y - y0)^2 + c3*(y - y0)^3

N = 1000;
dy = (Y_end(1) - Y_0(1)) / N;

Psi = curve_synthesis(Y_0, Y_end, dy, 0);

figure();
hold on; grid on;
 
y=Y_0(1):dy:Y_end(1);
plot(y,Psi);

h_d = 0.01;
d_min = -148.4;
d_max = 0;

constr = 0.9;

is_exist = true;
Y_l = Y_0;
Y_r = Y_end;

current_d = 0;

ind = 1;
while (is_exist==true)
    Y_b = find_borders(Y_l, Y_r, N, 0, 0, current_d); % Определяю границы интервала по y, на котором нарушается ограничение
    
    Y_12 = PointDef(Y_l, Y_r, N, current_d); % Нахожу точки вида [y  y'  y''], которые представляют собой новые граничные точки
    % отрезок, на котором строится функция сужается
    
    Y_1 = Y_12(1,:);
    Y_2 = Y_12(2,:);
    
    dy = (Y_2(1) - Y_1(1))/N;
    
    % --- Эта часть верна для случая, когда алгоритм сходится за 2 итерации
    replace_part = curve_synthesis(Y_1, Y_2, dy, d_min);
    
    y = Y_1(1):dy:Y_2(1);
    if (ind == 1)
        plot(y,replace_part,'g')
    end
    
    if (ind == 2)
        plot(y,replace_part,'r');
    end
    % ---------------------------------------------------------------------
    
    
    is_exist = false;
    count = 0;
    for d=d_min:h_d:d_max
        
        Y_dec = find_borders(Y_1, Y_2, N, 0, 0, d); % Определяю границы интервала по y, на котором нарушается ограничение
        
        if (Y_dec == 0)
            break;
        end
        
        % если отрезок, на котором кривая выходит за ограничение, сужается,
        % тогда все в порядке
        % сохраняется то d, при котором этот отрезок имеет минимальную
        % длину
        if ( Y_dec(2,1) < (Y_b(2,1) - 0) ) && (Y_dec(1,1) > (Y_b(1,1) + 0) )
            count = count + 1;
            is_exist = true;

            if (count == 1)
                M_y_lims = Y_dec;
                current_d = d;
            end

            if (is_exist)&&( (Y_dec(2,1) - Y_dec(1,1)) < (M_y_lims(2,1) - M_y_lims(1,1)) )
                M_y_lims = Y_dec;
                current_d = d;
            end
        end
    end
    
    if (Y_dec == 0)
        break;
    end
    if (is_exist == true) % Если текущая итерация отработала хорошо, то есть сужение отрезка, 
        % на котором кривая выходит ограничение, было найдено, то... 
        Y_l = Y_1;
        Y_r = Y_2;
    end
    ind = ind + 1;
end
