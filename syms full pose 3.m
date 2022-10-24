%% Posição Inicial
clc
k = 0.1 * sqrt(5)/5 * 1.0;
Ax =  2*k;  
Ay = -4*k;
Az =  0.0;
Bx =  2*k;   
By =  0.0;
Bz = -2*k;
Cx =  2*k;   
Cy =    k;
Cz =  0.0;
Dx = -2*k;  
Dy = -4*k;
Dz =  0.0;
Ex = -2*k;   
Ey =  0.0;
Ez = -2*k;
Fx = -2*k;   
Fy =    k;
Fz =  0.0;
% Ax = randn()/10;  
% Ay = randn()/10;
% Az = randn()/10;
% Bx = randn()/10;  
% By = randn()/10;
% Bz = randn()/10;
% Cx = randn()/10;
% Cy = randn()/10;
% Cz = randn()/10;
% Dx = randn()/10;  
% Dy = randn()/10;
% Dz = randn()/10;
% Ex = randn()/10;   
% Ey = randn()/10;
% Ez = randn()/10;
% Fx = randn()/10;   
% Fy = randn()/10;
% Fz = randn()/10;

LEDS = [Ax Bx Cx Dx Ex Fx;
        Ay By Cy Dy Ey Fy;
        Az Bz Cz Dz Ez Fz]
% Deslocamento
Lx =  0.20;
Ly =  0.10;
Lz = -0.50;


% Attitude
yaw = 15;   %[º]
pitch = 15;  %[º]
roll = 0;   %[º]
q = angle2quat(deg2rad(pitch),deg2rad(yaw),deg2rad(roll))';

q1 = q(1);
q2 = q(2);
q3 = q(3);
q4 = q(4);



% Apx
% Apy
% Bpx
% Bpy
% Cpx
% Cpy
% Dpx
% Dpy
% Epx
% Epy
% Fpx
% Fpy


DCM = [q1^2+q4^2-q2^2-q3^2,     2*(q4*q2+q3*q1),     2*(q4*q3+q2*q1);
           2*(q4*q2-q3*q1), q1^2-q4^2+q2^2-q3^2,     2*(q2*q3+q4*q1);
           2*(q4*q3-q2*q1),     2*(q2*q3-q4*q1), q1^2-q4^2-q2^2+q3^2];
       
P_0 = [Ax Bx Cx Dx Ex Fx;
       Ay By Cy Dy Ey Fy;
       Az Bz Cz Dz Ez Fz];

Delta = [Lx Lx Lx Lx Lx Lx;
         Ly Ly Ly Ly Ly Ly;
         Lz Lz Lz Lz Lz Lz];
     
     
P_f = DCM * P_0 + Delta;

A_f = P_f(:,1);
B_f = P_f(:,2);
C_f = P_f(:,3);
D_f = P_f(:,4);
E_f = P_f(:,5);
F_f = P_f(:,6);

Apx = -A_f(1)/A_f(3);
Apy = -A_f(2)/A_f(3);
Bpx = -B_f(1)/B_f(3);
Bpy = -B_f(2)/B_f(3);
Cpx = -C_f(1)/C_f(3);
Cpy = -C_f(2)/C_f(3);
Dpx = -D_f(1)/D_f(3);
Dpy = -D_f(2)/D_f(3);
Epx = -E_f(1)/E_f(3);
Epy = -E_f(2)/E_f(3);
Fpx = -F_f(1)/F_f(3);
Fpy = -F_f(2)/F_f(3);

% [ q1^2              q1*q2                q1*q3          q1*q4       q2^2               q2*q3             q2*q4         q3^2            q3*q4         q4^2    Lx  Ly  Lz  ]
EQN = ...
[( Ax+Apx*Az), (2*Az-2*Apx*Ax),            2*Ay,      -2*Apx*Ay , (-Ax-Apx*Az),       2*Apx*Ay ,           2*Ay , (Apx*Az-Ax),  (2*Az+2*Apx*Ax), ( Ax-Apx*Az),  1, 0, Apx; % == 0 -> eq1    
 ( Ay+Apy*Az),       -2*Apy*Ax,           -2*Ax, (2*Az-2*Apy*Ay), ( Ay-Apy*Az), (2*Az+2*Apy*Ay),           2*Ax , (Apy*Az-Ay),         2*Apy*Ax, (-Ay-Apy*Az),  0, 1, Apy; % == 0 -> eq2
 ( Bx+Bpx*Bz), (2*Bz-2*Bpx*Bx),            2*By,      -2*Bpx*By , (-Bx-Bpx*Bz),       2*Bpx*By ,           2*By , (Bpx*Bz-Bx),  (2*Bz+2*Bpx*Bx), ( Bx-Bpx*Bz),  1, 0, Bpx; % == 0 -> eq3    
 ( By+Bpy*Bz),       -2*Bpy*Bx,           -2*Bx, (2*Bz-2*Bpy*By), ( By-Bpy*Bz), (2*Bz+2*Bpy*By),           2*Bx , (Bpy*Bz-By),         2*Bpy*Bx, (-By-Bpy*Bz),  0, 1, Bpy; % == 0 -> eq4
 ( Cx+Cpx*Cz), (2*Cz-2*Cpx*Cx),            2*Cy,      -2*Cpx*Cy , (-Cx-Cpx*Cz),       2*Cpx*Cy ,           2*Cy , (Cpx*Cz-Cx),  (2*Cz+2*Cpx*Cx), ( Cx-Cpx*Cz),  1, 0, Cpx; % == 0 -> eq5    
 ( Cy+Cpy*Cz),       -2*Cpy*Cx,           -2*Cx, (2*Cz-2*Cpy*Cy), ( Cy-Cpy*Cz), (2*Cz+2*Cpy*Cy),           2*Cx , (Cpy*Cz-Cy),         2*Cpy*Cx, (-Cy-Cpy*Cz),  0, 1, Cpy; % == 0 -> eq6
 ( Dx+Dpx*Dz), (2*Dz-2*Dpx*Dx),            2*Dy,      -2*Dpx*Dy , (-Dx-Dpx*Dz),       2*Dpx*Dy ,           2*Dy , (Dpx*Dz-Dx),  (2*Dz+2*Dpx*Dx), ( Dx-Dpx*Dz),  1, 0, Dpx; % == 0 -> eq7    
 ( Dy+Dpy*Dz),       -2*Dpy*Dx,           -2*Dx, (2*Dz-2*Dpy*Dy), ( Dy-Dpy*Dz), (2*Dz+2*Dpy*Dy),           2*Dx , (Dpy*Dz-Dy),         2*Dpy*Dx, (-Dy-Dpy*Dz),  0, 1, Dpy; % == 0 -> eq8
 ( Ex+Epx*Ez), (2*Ez-2*Epx*Ex),            2*Ey,      -2*Epx*Ey , (-Ex-Epx*Ez),       2*Epx*Ey ,           2*Ey , (Epx*Ez-Ex),  (2*Ez+2*Epx*Ex), ( Ex-Epx*Ez),  1, 0, Epx; % == 0 -> eq9    
 ( Ey+Epy*Ez),       -2*Epy*Ex,           -2*Ex, (2*Ez-2*Epy*Ey), ( Ey-Epy*Ez), (2*Ez+2*Epy*Ey),           2*Ex , (Epy*Ez-Ey),         2*Epy*Ex, (-Ey-Epy*Ez),  0, 1, Epy; % == 0 -> eq10
 ( Fx+Fpx*Fz), (2*Fz-2*Fpx*Fx),            2*Fy,      -2*Fpx*Fy , (-Fx-Fpx*Fz),       2*Fpx*Fy ,           2*Fy , (Fpx*Fz-Fx),  (2*Fz+2*Fpx*Fx), ( Fx-Fpx*Fz),  1, 0, Fpx; % == 0 -> eq11   
 ( Fy+Fpy*Fz),       -2*Fpy*Fx,           -2*Fx, (2*Fz-2*Fpy*Fy), ( Fy-Fpy*Fz), (2*Fz+2*Fpy*Fy),           2*Fx , (Fpy*Fz-Fy),         2*Fpy*Fx, (-Fy-Fpy*Fz),  0, 1, Fpy; % == 0 -> eq12
            1,               0,               0,               0,            1,               0,               0,           1,                0,            1,  0,  0, 0]; % == 1 -> eq13

SIS_aprox = [EQN(1:13,1:4),EQN(1:13,11:13)];
vector = [zeros(12,1); 1];


Sol_aprox = SIS_aprox\vector;

qq1 = sqrt(Sol_aprox(1));
qq2 = Sol_aprox(2)/qq1;
qq3 = Sol_aprox(3)/qq1;
qq4 = Sol_aprox(4)/qq1;

% [Sol_aprox, [qq1;qq2;qq3;qq4;Lx;Ly;Lz], Sol_aprox - [qq1;qq2;qq3;qq4;Lx;Ly;Lz]]

[p,y,r] = quat2angle([qq1,qq2,qq3,qq4]);
RES = [ [rad2deg(p); rad2deg(y); rad2deg(r); Sol_aprox(5:7)], [pitch; yaw; roll; Lx; Ly; Lz] ] ;
RES = [RES, RES(:,1)-RES(:,2)]

vector_2 = vector - EQN(:,5:10)*[ q2^2, q2*q3, q2*q4, q3^2, q3*q4, q4^2]';

Sol_aprox_2 = SIS_aprox\vector_2;

qq1_2 = sqrt(Sol_aprox_2(1));
qq2_2 = Sol_aprox_2(2)/qq1;
qq3_2 = Sol_aprox_2(3)/qq1;
qq4_2 = Sol_aprox_2(4)/qq1;

[p,y,r] = quat2angle([qq1_2,qq2_2,qq3_2,qq4_2]);
RES = [ [rad2deg(p); rad2deg(y); rad2deg(r); Sol_aprox(5:7)], [pitch; yaw; roll; Lx; Ly; Lz] ] ;
RES = [RES, RES(:,1)-RES(:,2)]
