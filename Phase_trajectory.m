clear all
close all
clc

global constr
% 1) y' < constr

Y_0 = [0.1 0.2 2];
Y_end = [0.6 0.5 0.5];

% �������� ������, ������� ��������� ����� Y_0 � Y_end � ����
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
    Y_b = find_borders(Y_l, Y_r, N, 0, 0, current_d); % ��������� ������� ��������� �� y, �� ������� ���������� �����������
    
    Y_12 = PointDef(Y_l, Y_r, N, current_d); % ������ ����� ���� [y  y'  y''], ������� ������������ ����� ����� ��������� �����
    % �������, �� ������� �������� ������� ��������
    
    Y_1 = Y_12(1,:);
    Y_2 = Y_12(2,:);
    
    dy = (Y_2(1) - Y_1(1))/N;
    
    % --- ��� ����� ����� ��� ������, ����� �������� �������� �� 2 ��������
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
        
        Y_dec = find_borders(Y_1, Y_2, N, 0, 0, d); % ��������� ������� ��������� �� y, �� ������� ���������� �����������
        
        if (Y_dec == 0)
            break;
        end
        
        % ���� �������, �� ������� ������ ������� �� �����������, ��������,
        % ����� ��� � �������
        % ����������� �� d, ��� ������� ���� ������� ����� �����������
        % �����
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
    if (is_exist == true) % ���� ������� �������� ���������� ������, �� ���� ������� �������, 
        % �� ������� ������ ������� �����������, ���� �������, ��... 
        Y_l = Y_1;
        Y_r = Y_2;
    end
    ind = ind + 1;
end
