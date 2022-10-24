clear 
syms q1 q2 q3 q4 real positive
% syms Dx Dy Dz real
% syms Ay Bz Cy Apx Apy Bpx Bpy Cpx Cpy real
syms a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16 real 

assume(q1 <= 1)
assume(q2 <= 1)
assume(q3 <= 1)
assume(q4 <= 1)

% a1 = Bpx*Bz/(Bpx - Apx);
% a2 = Apx*Ay/(Bpx - Apx);
% a3 =     Ay/(Bpx - Apx);
% a4 =     Bz/(Bpx - Apx);
% 
% a5 = Bpy*Bz/(Bpy - Apy);
% a6 = Apy*Ay/(Bpy - Apy);
% a7 = Ay/(Bpy - Apy);
% a8 = Bz/(Bpy - Apy);
% 
% a9  = Cpx*Cy/(Cpx - Apx);
% a10 = Apx*Ay/(Cpx - Apx);
% a11 = Ay/(Cpx - Apx);
% a12 = Cy/(Cpx - Apx);
% 
% a13 = Cpy*Cy/(Cpy - Apy);
% a14 = Apy*Ay/(Cpy - Apy);
% a15 = Ay/(Cpy - Apy);
% a16 = Cy/(Cpy - Apy);

% -Dx == -Apx*Ay*(2*q1*q4-2*q2*q3) + Apx*Dz+Ay*(2*q1*q2+2*q3*q4)
% -Dy == -Apy*Ay*(2*q1*q4-2*q2*q3) + Apy*Dz-Ay*(q1^2-q2^2+q3^2-q4^2)

% eq1 =   (Bpx - Apx)*Dz == Bpx*Bz*(q1^2+q2^2-q3^2-q4^2) - Apx*Ay*(2*q1*q4-2*q2*q3) + Ay*( 2*q1*q2 + 2*q3*q4 ) - Bz*( 2*q1*q3 + 2*q2*q4 );
% eq2 =   (Bpy - Apy)*Dz == Bpy*Bz*(q1^2+q2^2-q3^2-q4^2) - Apy*Ay*(2*q1*q4-2*q2*q3) - Ay*(q1^2-q2^2+q3^2-q4^2) - Bz*( 2*q1*q4 + 2*q2*q3 );
% eq3 =   (Cpx - Apx)*Dz == Cpx*Cy*( 2*q1*q4 - 2*q2*q3 ) - Apx*Ay*(2*q1*q4-2*q2*q3) + Ay*( 2*q1*q2 + 2*q3*q4 ) - Cy*( 2*q1*q2 + 2*q3*q4 );
% eq4 =   (Cpy - Apy)*Dz == Cpy*Cy*( 2*q1*q4 - 2*q2*q3 ) - Apy*Ay*(2*q1*q4-2*q2*q3) - Ay*(q1^2-q2^2+q3^2-q4^2) + Cy*(q1^2-q2^2+q3^2-q4^2);
% eq5 =                1 == q1^2 + q2^2 + q3^2 + q4^2 ;

%  Dz == a1*(q1^2+q2^2-q3^2-q4^2) - a2*(2*q1*q4-2*q2*q3) + a3*( 2*q1*q2 + 2*q3*q4 ) - a4*( 2*q1*q3 + 2*q2*q4 )

eq1 =   a5*(q1^2+q2^2-q3^2-q4^2) -  a6*(2*q1*q4-2*q2*q3) -  a7*(q1^2-q2^2+q3^2-q4^2) -  a8*( 2*q1*q4 + 2*q2*q3 ) == a1*(q1^2+q2^2-q3^2-q4^2) - a2*(2*q1*q4-2*q2*q3) + a3*( 2*q1*q2 + 2*q3*q4 ) - a4*( 2*q1*q3 + 2*q2*q4 );
eq2 =   a9*( 2*q1*q4 - 2*q2*q3 ) - a10*(2*q1*q4-2*q2*q3) + a11*( 2*q1*q2 + 2*q3*q4 ) - a12*( 2*q1*q2 + 2*q3*q4 ) == a1*(q1^2+q2^2-q3^2-q4^2) - a2*(2*q1*q4-2*q2*q3) + a3*( 2*q1*q2 + 2*q3*q4 ) - a4*( 2*q1*q3 + 2*q2*q4 );
eq3 =  a13*( 2*q1*q4 - 2*q2*q3 ) - a14*(2*q1*q4-2*q2*q3) - a15*(q1^2-q2^2+q3^2-q4^2) + a16*(q1^2-q2^2+q3^2-q4^2) == a1*(q1^2+q2^2-q3^2-q4^2) - a2*(2*q1*q4-2*q2*q3) + a3*( 2*q1*q2 + 2*q3*q4 ) - a4*( 2*q1*q3 + 2*q2*q4 );
eq4 =                                                                                  q1^2 + q2^2 + q3^2 + q4^2 == 1;

eqns = [eq1, eq2, eq3, eq4];
S = solve(eqns,[q1 q2 q3 q4], 'ReturnConditions', true)