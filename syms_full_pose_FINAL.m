syms Lx Ly Lz real
syms Ax Ay Az Bx By Bz Cx Cy Cz real
syms Apx Apy Bpx Bpy Cpx Cpy real

% [ q1^2              q1*q2                q1*q3          q1*q4       q2^2               q2*q3             q2*q4         q3^2            q3*q4         q4^2    Lx  Ly  Lz  ]
EQN = ...
[( Ax+Apx*Az), (2*Az-2*Apx*Ax),            2*Ay,      -2*Apx*Ay , (-Ax-Apx*Az),       2*Apx*Ay ,           2*Ay , (Apx*Az-Ax),  (2*Az+2*Apx*Ax), ( Ax-Apx*Az),  1, 0, Apx; % == 0 -> eq1    
 ( Ay+Apy*Az),       -2*Apy*Ax,           -2*Ax, (2*Az-2*Apy*Ay), ( Ay-Apy*Az), (2*Az+2*Apy*Ay),           2*Ax , (Apy*Az-Ay),         2*Apy*Ax, (-Ay-Apy*Az),  0, 1, Apy; % == 0 -> eq2
 ( Bx+Bpx*Bz), (2*Bz-2*Bpx*Bx),            2*By,      -2*Bpx*By , (-Bx-Bpx*Bz),       2*Bpx*By ,           2*By , (Bpx*Bz-Bx),  (2*Bz+2*Bpx*Bx), ( Bx-Bpx*Bz),  1, 0, Bpx; % == 0 -> eq3    
 ( By+Bpy*Bz),       -2*Bpy*Bx,           -2*Bx, (2*Bz-2*Bpy*By), ( By-Bpy*Bz), (2*Bz+2*Bpy*By),           2*Bx , (Bpy*Bz-By),         2*Bpy*Bx, (-By-Bpy*Bz),  0, 1, Bpy; % == 0 -> eq4
 ( Cx+Cpx*Cz), (2*Cz-2*Cpx*Cx),            2*Cy,      -2*Cpx*Cy , (-Cx-Cpx*Cz),       2*Cpx*Cy ,           2*Cy , (Cpx*Cz-Cx),  (2*Cz+2*Cpx*Cx), ( Cx-Cpx*Cz),  1, 0, Cpx; % == 0 -> eq5    
 ( Cy+Cpy*Cz),       -2*Cpy*Cx,           -2*Cx, (2*Cz-2*Cpy*Cy), ( Cy-Cpy*Cz), (2*Cz+2*Cpy*Cy),           2*Cx , (Cpy*Cz-Cy),         2*Cpy*Cx, (-Cy-Cpy*Cz),  0, 1, Cpy; % == 0 -> eq6
            1,               0,               0,               0,            1,               0,               0,           1,                0,            1,  0,  0, 0] % == 1 -> eq7
%%    
% Versão simplificada % [ q1^2   q1*q2    q1*q3    q1*q4   Lx  Ly  Lz  = 1]
EQN2 = [EQN(:,1:4),EQN(:,11:13), [zeros(6,1); 1]]
% Versão completa
EQN6 = [EQN(:,:) , [zeros(6,1); 1]]

%%
% Versão simplificada
EQN3 = [EQN2(3,:) - EQN2(1,:);
        EQN2(4,:) - EQN2(2,:);
        EQN2(5,:) - EQN2(1,:);
        EQN2(6,:) - EQN2(2,:);
        EQN2(7,:)]
% Versão completa    
EQN7 = [EQN6(3,:) - EQN6(1,:);
        EQN6(4,:) - EQN6(2,:);
        EQN6(5,:) - EQN6(1,:);
        EQN6(6,:) - EQN6(2,:);
        EQN6(7,:)]
    
%%    
% Versão simplificada
EQN4 = [EQN3(1,:)/EQN3(1,end-1);
        EQN3(2,:)/EQN3(2,end-1);
        EQN3(3,:)/EQN3(3,end-1);
        EQN3(4,:)/EQN3(4,end-1);
        EQN3(5,:)]
% Versão completa    
EQN8 = [EQN7(1,:)/EQN7(1,end-1);
        EQN7(2,:)/EQN7(2,end-1);
        EQN7(3,:)/EQN7(3,end-1);
        EQN7(4,:)/EQN7(4,end-1);
        EQN7(5,:)]
    
%%    
% Versão simplificada
EQN5 = [EQN4(2,:) - EQN4(1,:);
        EQN4(3,:) - EQN4(1,:);
        EQN4(4,:) - EQN4(3,:);
        EQN4(5,:)]
% Versão completa 
EQN9 = [EQN8(2,:) - EQN8(1,:);
        EQN8(3,:) - EQN8(1,:);
        EQN8(4,:) - EQN8(3,:);
        EQN8(5,:)]
        
%% Test
clc

%posição inicial
k = 0.1 * sqrt(5)/5 * 1.0;

Ax =  0.0;  
Ay = -4*k;
Az =  0.0;
Bx =  0.0;
By =  0.0;
Bz = -2*k;
Cx =  0.0;
Cy =    k;
Cz =  0.0;


% Deslocamento
Lx =  0.00;
Ly =  0.00;
Lz = -0.50;

% Attitude
pitch = 5;  %[º]
yaw =  10;   %[º]
roll = 15;   %[º]

[pitch, yaw, roll];
q = angle2quat(deg2rad(pitch),deg2rad(yaw),deg2rad(roll))

q1 = q(1);
q2 = q(2);
q3 = q(3);
q4 = q(4);

DCM = [q1^2+q4^2-q2^2-q3^2,     2*(q4*q2+q3*q1),     2*(q4*q3+q2*q1);
           2*(q4*q2-q3*q1), q1^2-q4^2+q2^2-q3^2,     2*(q2*q3+q4*q1);
           2*(q4*q3-q2*q1),     2*(q2*q3-q4*q1), q1^2-q4^2-q2^2+q3^2];
       
P_0 = [Ax Bx Cx;
       Ay By Cy;
       Az Bz Cz];

Delta = [Lx Lx Lx;
         Ly Ly Ly;
         Lz Lz Lz];
     
     
P_f = DCM * P_0 + Delta;

A_f = P_f(:,1);
B_f = P_f(:,2);
C_f = P_f(:,3);

% Apx = -A_f(1)/A_f(3)
% Apy = -A_f(2)/A_f(3)
% Bpx = -B_f(1)/B_f(3)
% Bpy = -B_f(2)/B_f(3)
% Cpx = -C_f(1)/C_f(3)
% Cpy = -C_f(2)/C_f(3)

Apx = -0.0688;
Apy = -0.3560;
Bpx = -0.0389;
Bpy = -0.0131;
Cpx =  0.0169;
Cpy =  0.0874;

A(1,1) =     (Ay - By + Apy*Az - Bpy*Bz)/(Apy - Bpy) - (Ax - Bx + Apx*Az - Bpx*Bz)/(Apx - Bpx);
A(1,2) = - (2*Apy*Ax - 2*Bpy*Bx)/(Apy - Bpy) - (2*Az - 2*Bz - 2*Apx*Ax + 2*Bpx*Bx)/(Apx - Bpx);
A(1,3) =                               - (2*Ax - 2*Bx)/(Apy - Bpy) - (2*Ay - 2*By)/(Apx - Bpx);
A(1,4) =   (2*Apx*Ay - 2*Bpx*By)/(Apx - Bpx) + (2*Az - 2*Bz - 2*Apy*Ay + 2*Bpy*By)/(Apy - Bpy);
A(2,1) =                 (Ax - Cx + Apx*Az - Cpx*Cz)/(Apx - Cpx) - (Ax - Bx + Apx*Az - Bpx*Bz)/(Apx - Bpx);
A(2,2) = (2*Az - 2*Cz - 2*Apx*Ax + 2*Cpx*Cx)/(Apx - Cpx) - (2*Az - 2*Bz - 2*Apx*Ax + 2*Bpx*Bx)/(Apx - Bpx);
A(2,3) =                                             (2*Ay - 2*Cy)/(Apx - Cpx) - (2*Ay - 2*By)/(Apx - Bpx);
A(2,4) =                             (2*Apx*Ay - 2*Bpx*By)/(Apx - Bpx) - (2*Apx*Ay - 2*Cpx*Cy)/(Apx - Cpx);
A(3,1) =     (Ay - Cy + Apy*Az - Cpy*Cz)/(Apy - Cpy) - (Ax - Cx + Apx*Az - Cpx*Cz)/(Apx - Cpx);
A(3,2) = - (2*Apy*Ax - 2*Cpy*Cx)/(Apy - Cpy) - (2*Az - 2*Cz - 2*Apx*Ax + 2*Cpx*Cx)/(Apx - Cpx);
A(3,3) =                               - (2*Ax - 2*Cx)/(Apy - Cpy) - (2*Ay - 2*Cy)/(Apx - Cpx);
A(3,4) =   (2*Apx*Ay - 2*Cpx*Cy)/(Apx - Cpx) + (2*Az - 2*Cz - 2*Apy*Ay + 2*Cpy*Cy)/(Apy - Cpy);
A(4,1:4) = [1, 0, 0, 0];

b = [0; 0; 0; 1];
q = (A\b)';
q = q/norm(q)  % Solução aproximada grosseira

% b2 = [0; 0; 0; (1 - (qq(2)^2+qq(3)^2+qq(4)^2)/2)^2];
% qq2 = (A\b2)';
% qq3 = qq2/norm(qq2);
% [p,y,r] = quat2angle(qq3);
% rad2deg([p,y,r])


A2(1,1) =   (Ax - Bx + Apx*Az - Bpx*Bz)/(Apx - Bpx) + (Ay - By - Apy*Az + Bpy*Bz)/(Apy - Bpy);
A2(1,2) = (2*Az - 2*Bz + 2*Apy*Ay - 2*Bpy*By)/(Apy - Bpy) - (2*Apx*Ay - 2*Bpx*By)/(Apx - Bpx);
A2(1,3) =                               (2*Ax - 2*Bx)/(Apy - Bpy) - (2*Ay - 2*By)/(Apx - Bpx);
A2(1,4) =   (Ax - Bx - Apx*Az + Bpx*Bz)/(Apx - Bpx) - (Ay - By - Apy*Az + Bpy*Bz)/(Apy - Bpy);
A2(1,5) = (2*Apy*Ax - 2*Bpy*Bx)/(Apy - Bpy) - (2*Az - 2*Bz + 2*Apx*Ax - 2*Bpx*Bx)/(Apx - Bpx);
A2(1,6) = - (Ax - Bx - Apx*Az + Bpx*Bz)/(Apx - Bpx) - (Ay - By + Apy*Az - Bpy*Bz)/(Apy - Bpy);
A2(2,1) =                 (Ax - Bx + Apx*Az - Bpx*Bz)/(Apx - Bpx) - (Ax - Cx + Apx*Az - Cpx*Cz)/(Apx - Cpx);
A2(2,2) =                             (2*Apx*Ay - 2*Cpx*Cy)/(Apx - Cpx) - (2*Apx*Ay - 2*Bpx*By)/(Apx - Bpx);
A2(2,3) =                                             (2*Ay - 2*Cy)/(Apx - Cpx) - (2*Ay - 2*By)/(Apx - Bpx);
A2(2,4) =                 (Ax - Bx - Apx*Az + Bpx*Bz)/(Apx - Bpx) - (Ax - Cx - Apx*Az + Cpx*Cz)/(Apx - Cpx);
A2(2,5) = (2*Az - 2*Cz + 2*Apx*Ax - 2*Cpx*Cx)/(Apx - Cpx) - (2*Az - 2*Bz + 2*Apx*Ax - 2*Bpx*Bx)/(Apx - Bpx);
A2(2,6) =                 (Ax - Cx - Apx*Az + Cpx*Cz)/(Apx - Cpx) - (Ax - Bx - Apx*Az + Bpx*Bz)/(Apx - Bpx);
A2(3,1) =   (Ax - Cx + Apx*Az - Cpx*Cz)/(Apx - Cpx) + (Ay - Cy - Apy*Az + Cpy*Cz)/(Apy - Cpy);
A2(3,2) = (2*Az - 2*Cz + 2*Apy*Ay - 2*Cpy*Cy)/(Apy - Cpy) - (2*Apx*Ay - 2*Cpx*Cy)/(Apx - Cpx);
A2(3,3) =                               (2*Ax - 2*Cx)/(Apy - Cpy) - (2*Ay - 2*Cy)/(Apx - Cpx);
A2(3,4) =   (Ax - Cx - Apx*Az + Cpx*Cz)/(Apx - Cpx) - (Ay - Cy - Apy*Az + Cpy*Cz)/(Apy - Cpy);
A2(3,5) = (2*Apy*Ax - 2*Cpy*Cx)/(Apy - Cpy) - (2*Az - 2*Cz + 2*Apx*Ax - 2*Cpx*Cx)/(Apx - Cpx);
A2(3,6) = - (Ax - Cx - Apx*Az + Cpx*Cz)/(Apx - Cpx) - (Ay - Cy + Apy*Az - Cpy*Cz)/(Apy - Cpy);
A2(4,:) = [1, 0, 0, 1, 0, 1];


b = [0; 0; 0; 1] - A2*[ q(2)^2; q(2)*q(3); q(2)*q(4); q(3)^2; q(3)*q(4); q(4)^2];

q = (A\b)';
q = q/norm(q) % Solução 

% [p,y,r] = quat2angle(q, 'XYZ')
% [rad2deg(p),rad2deg(y),rad2deg(r)]

%% Solução para a posição
clc;
M1 = [ Ax + Apx*Az, 2*Az - 2*Apx*Ax,  2*Ay,       -2*Apx*Ay, - Ax - Apx*Az,        2*Apx*Ay, 2*Ay, Apx*Az - Ax, 2*Az + 2*Apx*Ax,   Ax - Apx*Az;
       Ay + Apy*Az,       -2*Apy*Ax, -2*Ax, 2*Az - 2*Apy*Ay,   Ay - Apy*Az, 2*Az + 2*Apy*Ay, 2*Ax, Apy*Az - Ay,        2*Apy*Ax, - Ay - Apy*Az;
       Bx + Bpx*Bz, 2*Bz - 2*Bpx*Bx,  2*By,       -2*Bpx*By, - Bx - Bpx*Bz,        2*Bpx*By, 2*By, Bpx*Bz - Bx, 2*Bz + 2*Bpx*Bx,   Bx - Bpx*Bz;
       By + Bpy*Bz,       -2*Bpy*Bx, -2*Bx, 2*Bz - 2*Bpy*By,   By - Bpy*Bz, 2*Bz + 2*Bpy*By, 2*Bx, Bpy*Bz - By,        2*Bpy*Bx, - By - Bpy*Bz;
       Cx + Cpx*Cz, 2*Cz - 2*Cpx*Cx,  2*Cy,       -2*Cpx*Cy, - Cx - Cpx*Cz,        2*Cpx*Cy, 2*Cy, Cpx*Cz - Cx, 2*Cz + 2*Cpx*Cx,   Cx - Cpx*Cz;
       Cy + Cpy*Cz,       -2*Cpy*Cx, -2*Cx, 2*Cz - 2*Cpy*Cy,   Cy - Cpy*Cz, 2*Cz + 2*Cpy*Cy, 2*Cx, Cpy*Cz - Cy,        2*Cpy*Cx, - Cy - Cpy*Cz];

M2 = [1, 0, Apx;
      0, 1, Apy;
      1, 0, Bpx;
      0, 1, Bpy;
      1, 0, Cpx;
      0, 1, Cpy];

b1 = [q(1)^2; q(1)*q(2); q(1)*q(3); q(1)*q(4); q(2)^2; q(2)*q(3); q(2)*q(4); q(3)^2; q(3)*q(4); q(4)^2];

pos = (M2'*M2)\(M2'*(-M1*b1));

[Lx, Ly, Lz]
pos'
