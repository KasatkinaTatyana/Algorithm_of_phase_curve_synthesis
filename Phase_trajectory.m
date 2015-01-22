clear all
close all
clc

global constr

Y_0 = [0.1 0.2 2];
Y_end = [0.6 0.5 0.5];

N = 1000;

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

Expr = c0 + c1*delta + c2*delta^2 + c3*delta^3;

Expr_1 = c1 + 2*c2*delta + 3*c3*delta^2;

d = 0;

figure();
hold on; grid on;

dy = (Y_end(1) - Y_0(1)) / N;

y=Y_0(1):dy:Y_end(1);
Psi = c0 + c1*(y - Y_0(1)) + c2*(y - Y_0(1)).^2 + c3*(y - Y_0(1)).^3;

plot(y,Psi);

h_d = 0.01;
d_min = -148.4;
d_max = 0;

N_shift_left = 45;
N_shift_right = 100;
constr = 0.9;

is_exist = true;
Y_l = Y_0;
Y_r = Y_end;

current_d = 0;

ind = 1;
while (is_exist==true)
    Y_b = find_borders(Y_l, Y_r, N, 0, 0, current_d);
    
    Y_12 = PointDef(Y_l, Y_r, N, current_d);
    
    Y_1 = Y_12(1,:);
    Y_2 = Y_12(2,:);
    
    dy = (Y_2(1) - Y_1(1))/N;
    
    replace_part = curve_synthesis(Y_1, Y_2, dy, d_min);
    
    y = Y_1(1):dy:Y_2(1);
    if (ind == 1)
        plot(y,replace_part,'g')
    end
    
    if (ind == 2)
        plot(y,replace_part,'r');
    end
    
    
    is_exist = false;
    count = 0;
    for d=d_min:h_d:d_max
        
        Y_dec = find_borders(Y_1, Y_2, N, 0, 0, d);
        
        if (Y_dec == 0)
            break;
        end
    
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
    if (is_exist == true)
        Y_l = Y_1;
        Y_r = Y_2;
    end
    ind = ind + 1;
end


dy = (Y_end(1) - Y_0(1))/N;
replace_part = curve_synthesis(Y_0, Y_end, dy, d_min);

disp(Y_r(1) - Y_l(1));
% 
% replace_part = curve_synthesis(y_left, y_right, dy, d);

% Psi = zeros(1,N);
% 
% for d=80:0.01:100
%     i = 1;
%     flag = 0;
%     for y = Y_0(1):dy:Y_end(1)
%         Psi(i) = c0 + c1*(y - Y_0(1)) + c2*(y - Y_0(1))^2 + c3*(y - Y_0(1))^3 + ...
%             d*(y - Y_0(1))^2*(y - Y_end(1))^2;
%         if ((Psi(i) >= 1.05)||(Psi(i) <= 0))
%             flag = 1;
%         end
%         i = i + 1;
%     end
%     if (flag == 1)
%         x = Y_0(1):dy:Y_end(1);
%         plot(x,Psi);
%         break;
%     end
% end
% 
% d
% 
% N_shift = 1;
% 
% cond = false;
% 
% while not(cond)
%     flag = 0;
%     for i=1:(N+1)
%         if ((flag == 0)&&(Psi(i) >= 1.05))
%             y_left(1) = Y_0(1) + (i-1 - N_shift)*dy;  % ��������� 3 ���� ����� �� ����������� �����
%             y_left(2) = Psi(i - N_shift);
%             y_left(3) = (c1 + 2*c2*(y_left(1) - Y_0(1)) + 3*c3*(y_left(1) - Y_0(1))^2)*y_left(2);
%             flag = 1;
%         end
%         if ((flag==1)&&(Psi(i) < 1.05))
%             y_right(1) = Y_0(1) + (i-1 + N_shift)*dy;
%             y_right(2) = Psi(i + N_shift);
%             y_right(3) = (c1 + 2*c2*(y_right(1) - Y_0(1)) + 3*c3*(y_right(1) - Y_0(1))^2)*y_right(2);
%             break;
%         end
%     end
%     
%     cond = IsCurveExist(y_left, y_right, dy, d);
%     
%     if not(cond)
%         N_shift = N_shift + 1;
%     end
% end
% 
% if (cond)
%     d_lims = d_interval(y_left, y_right, dy, d);
%     replace_part = curve_synthesis(y_left, y_right, dy, d_lims(2));
%     x = y_left(1):dy:y_right(1);
%     plot(x,replace_part,'r');
% else
%     disp('�������� �������� ���� ������');
% end




