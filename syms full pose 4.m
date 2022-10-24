clear 
syms q1 q2 q3 q4 real positive
assume(q1 <= 1)
assume(q2 <= 1)
assume(q3 <= 1)
assume(q4 <= 1)
syms Lx Ly Lz real
syms Ax Ay Az Bx By Bz Cx Cy Cz real
syms Apx Apy Bpx Bpy Cpx Cpy real
%%
% syms A real;
% Ax = A;
% Ay = 0;
% Az = 0;
% Bx = -A;
% By = 0;
% Bz = 0;
% Cx = 0;
% Cy = A;
% Cz = 0;

% [   q1^2     q1*q2       q1*q3               q1*q4       q2^2               q2*q3          q2*q4         q3^2     q3*q4      q4^2      Lx  Ly  Lz ] == state_vector^T     
EQN = ...
[( Ax-Apx*Az), 2*Ay, (2*Az+2*Apx*Ax),      -2*Apx*Ay , (-Ax-Apx*Az),       2*Apx*Ay , (2*Az-2*Apx*Ax), (Apx*Az-Ax),  2*Ay, (Ax+Apx*Az),  1,  0, Apx; % == 0 -> eq1
 (-Ay-Apy*Az), 2*Ax,       2*Apy*Ax , (2*Az-2*Apy*Ay), ( Ay-Apy*Az), (2*Az+2*Apy*Ay),      -2*Apy*Ax , (Apy*Az-Ay), -2*Ax, (Ay+Apy*Az),  0,  1, Apy; % == 0 -> eq2
 ( Bx-Bpx*Bz), 2*By, (2*Bz+2*Bpx*Bx),      -2*Bpx*By , (-Bx-Bpx*Bz),       2*Bpx*By , (2*Bz-2*Bpx*Bx), (Bpx*Bz-Bx),  2*By, (Bx+Bpx*Bz),  1,  0, Bpx; % == 0 -> eq3
 (-By-Bpy*Bz), 2*Bx,       2*Bpy*Bx , (2*Bz-2*Bpy*By), ( By-Bpy*Bz), (2*Bz+2*Bpy*By),      -2*Bpy*Bx , (Bpy*Bz-By), -2*Bx, (By+Bpy*Bz),  0,  1, Bpy; % == 0 -> eq4
 ( Cx-Cpx*Cz), 2*Cy, (2*Cz+2*Cpx*Cx),      -2*Cpx*Cy , (-Cx-Cpx*Cz),       2*Cpx*Cy , (2*Cz-2*Cpx*Cx), (Cpx*Cz-Cx),  2*Cy, (Cx+Cpx*Cz),  1,  0, Cpx; % == 0 -> eq5
 (-Cy-Cpy*Cz), 2*Cx,       2*Cpy*Cx , (2*Cz-2*Cpy*Cy), ( Cy-Cpy*Cz), (2*Cz+2*Cpy*Cy),      -2*Cpy*Cx , (Cpy*Cz-Cy), -2*Cx, (Cy+Cpy*Cz),  0,  1, Cpy; % == 0 -> eq6
            1,    0,               0,               0,            1,               0,               0,           1,     0,           1,  0,  0,   0] % == 1 -> eq7
%%
% EQN_2 = [EQN(3,:) - EQN(1,:);
%          EQN(4,:) - EQN(2,:);
%          EQN(5,:) - EQN(1,:);
%          EQN(6,:) - EQN(2,:);
%          EQN(7,:)]
%%
% EQN_3 = [EQN_2(1,:)*EQN_2(2,13) - EQN_2(2,:)*EQN_2(1,13);
%          EQN_2(1,:)*EQN_2(3,13) - EQN_2(3,:)*EQN_2(1,13);
%          EQN_2(1,:)*EQN_2(4,13) - EQN_2(4,:)*EQN_2(1,13);
%          EQN(7,:)]

%% [                    q1^2           q1*q2                             q1*q3               q1*q4                       q2^2              q2*q3                            q2*q4                        q3^2          q3*q4                      q4^2  Lx Ly Lz]
% [            2*A*(Apy-Bpy), -4*A*(Apx-Bpx),           -4*A*(Apx*Bpy-Apy*Bpx),                  0,            -2*A*(Apy-Bpy),                 0,           4*A*(Apx*Bpy-Apy*Bpx),             -2*A*(Apy-Bpy), 4*A*(Apx-Bpx),             2*A*(Apy-Bpy), 0, 0, 0]
% [        A*(Apx+Bpx-2*Cpx),  2*A*(Apx-Bpx), -2*A*(Apx*Cpx-2*Apx*Bpx+Bpx*Cpx), -2*A*Cpx*(Apx-Bpx),        -A*(Apx+Bpx-2*Cpx), 2*A*Cpx*(Apx-Bpx), 2*A*(Apx*Cpx-2*Apx*Bpx+Bpx*Cpx),         -A*(Apx+Bpx-2*Cpx), 2*A*(Apx-Bpx),         A*(Apx+Bpx-2*Cpx), 0, 0, 0]
% [2*A*(Apy-Cpy)-A*(Apx-Bpx), -2*A*(Apx-Bpx), -2*A*(Apx*Cpy-2*Apy*Bpx+Bpx*Cpy), -2*A*Cpy*(Apx-Bpx), A*(Apx-Bpx)-2*A*(Apy-Cpy), 2*A*Cpy*(Apx-Bpx), 2*A*(Apx*Cpy-2*Apy*Bpx+Bpx*Cpy), -A*(Apx-Bpx)-2*A*(Apy-Cpy), 2*A*(Apx-Bpx), A*(Apx-Bpx)+2*A*(Apy-Cpy), 0, 0, 0]
% [                        1,              0,                                0,                  0,                         1,                 0,                               0,                          1,             0,                         1, 0, 0, 0]
     
%% [   q1^2, q1*q2=~q2, q1*q3=~q3, q1*q4=~q4, q2^2=~0, q2*q3=~0, q2*q4=~0, q3^2=~0, q3*q4=~0, q4^2=~0, Lx  Ly  Lz   1 ] == state_vector^T
Sol_aprox = [EQN(:,1:4),EQN(:,11:13)]

