clear 
syms q1 q2 q3 q4 real positive
assume(q1 <= 1)
assume(q2 <= 1)
assume(q3 <= 1)
assume(q4 <= 1)
syms Lx Ly Lz real
syms Ax Ay Az Bx By Bz Cx Cy Cz real
syms Apx Apy Bpx Bpy Cpx Cpy real
syms Dx Dy Dz Ex Ey Ez Fx Fy Fz real
syms Dpx Dpy Epx Epy Fpx Fpy real

% % Posição Inicial
% cte = 0.1 * sqrt(5)/5;
% Ax =  0.000;  
% Ay = -4*cte;
% Az =  0.000;
% Bx =  0.000;   
% By =  0.000;
% Bz = -2*cte;
% Cx =  0.000;   
% Cy =    cte;
% Cz =  0.000;


DCM = [q1^2+q4^2-q2^2-q3^2,     2*(q4*q2+q3*q1),     2*(q4*q3+q2*q1);
           2*(q4*q2-q3*q1), q1^2-q4^2+q2^2-q3^2,     2*(q2*q3+q4*q1);
           2*(q4*q3-q2*q1),     2*(q2*q3-q4*q1), q1^2-q4^2-q2^2+q3^2];
       
% Caso geral
P_0 = [Ax Bx Cx;
       Ay By Cy;
       Az Bz Cz];

% % Caso simplicado com os leds inicialmente posicionados nos eixos
% Ax = 0;
% Az = 0;
% Bx = 0;
% By = 0;
% Cy = 0;
% Cz = 0;
% Ex = 0;
% Ey = 0;
% Ez = 0;

% P_0 = [ 0  0  0;
%        Ay  0 Cy;
%         0 Bz  0];

Delta = [Lx Lx Lx;
         Ly Ly Ly;
         Lz Lz Lz];

% Rotaciona e translada
P_f = DCM * P_0 + Delta;

A_f = P_f(:,1);
B_f = P_f(:,2);
C_f = P_f(:,3);

%%

% Interseção da reta que passa pela origem(camera) e os pontos (A_f,B_f,C_f) no plano z=-1
eq1 =   A_f(1) + Apx*A_f(3) == 0;
eq2 =   A_f(2) + Apy*A_f(3) == 0;
eq3 =   B_f(1) + Bpx*B_f(3) == 0;
eq4 =   B_f(2) + Bpy*B_f(3) == 0;
eq5 =   C_f(1) + Cpx*C_f(3) == 0;
eq6 =   C_f(2) + Cpy*C_f(3) == 0;

eq11 =   1 == q1^2 + q2^2 + q3^2 + q4^2;

%%
collect(expand(eq1), [q1, q2 q3 q4])
collect(expand(eq2), [q1, q2 q3 q4])
collect(expand(eq3), [q1, q2 q3 q4])
collect(expand(eq4), [q1, q2 q3 q4])


% eqns = [eq1, eq2, eq3, eq4, eq5, eq6, eq7];
% S = solve(eqns,[Lx Ly Lz q1 q2 q3 q4])

%% [ q1^2            q1*q2                q1*q3          q1*q4       q2^2               q2*q3           q2*q4         q3^2            q3*q4         q4^2      Lx  Ly  Lz   1 ] == state_vector^T
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
