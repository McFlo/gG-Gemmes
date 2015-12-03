function [ dX ] = ThreeSect_GoodwinKeenInfTayInv_system( t,X )

nu_1 = 4;
nu_2 = 4;
nu_3 = 4;
alpha = 0.025;
beta = 0.02;
delta_1 = 0.01;
delta_2 = 0.01;
delta_3 = 0.01;
a_11 = 0.0;
a_12 = 0.0;
a_13 = 0.0;
a_21 = 0.0;
a_22 = 0.0;
a_23 = 0.0;
a_31 = 0.0;
a_32 = 0.0;
a_33 = 0.0;
phi0 = 0.04/(1-0.04^2);
phi1 = 0.04^3/(1-0.04^2);
eta_1 = 0.1;
eta_2 = 0.1;
eta_3 = 0.1;
gamma = 0.8;
zeta_1 = 1/3;
zeta_2 = 1/3;
zeta_3 = 1/3;
rstar = 0.03; %"neutral" short term interest rate
istar = 0.005; %target inflation rate
u = 9.8813e-324; %auxiliary parameter to make the Taylor rule differentiable
phi_T = 1.5; %Taylor rule reactivity
sigma = 0.1; %adjustment speed parameter for allocation of investment

K_1 = X(1);
K_2 = X(2);
K_3 = X(3);
w = X(4);
al = X(5);
N = X(6);
D_1 = X(7);
D_2 = X(8);
D_3 = X(9);
p_1 = X(10);
p_2 = X(11);
p_3 = X(12);
theta_1 = X(13);
theta_2 = X(14);
theta_3 = X(15);

Q_1 = K_1/nu_1;
Q_2 = K_2/nu_2;
Q_3 = K_3/nu_3;
Y_1 = Q_1 - a_11*Q_1 - a_12*Q_2 - a_13*Q_3;
Y_2 = Q_2 - a_21*Q_1 - a_22*Q_2 - a_23*Q_3;
Y_3 = Q_3 - a_31*Q_1 - a_32*Q_2 - a_33*Q_3;
L_1 = al*Q_1;
L_2 = al*Q_2;
L_3 = al*Q_3;

r_1 = (p_1*Q_1 - p_1*a_11*Q_1 - p_2*a_21*Q_1 - p_3*a_31*Q_1 - w*L_1)/(p_1*K_1);
r_2 = (p_2*Q_2 - p_1*a_12*Q_2 - p_2*a_22*Q_2 - p_3*a_32*Q_2 - w*L_2)/(p_1*K_2);
r_3 = (p_3*Q_3 - p_1*a_13*Q_3 - p_2*a_23*Q_3 - p_3*a_33*Q_3 - w*L_3)/(p_1*K_3);
rbar = mean([r_1 r_2 r_3]);
d_p_1 = eta_1*p_1*nu_1*(rbar-r_1);
d_p_2 = eta_2*p_1*nu_2*(rbar-r_2);
d_p_3 = eta_3*p_1*nu_3*(rbar-r_3);
CPI = zeta_1*p_1 + zeta_2*p_2 + zeta_3*p_3;
inf = (zeta_1*d_p_1 + zeta_2*d_p_2 + zeta_3*d_p_3)/CPI;
iota = rstar + inf + phi_T*(inf-istar);
r = (iota + sqrt(iota^2 + u))/2;

Pi_1 = p_1*Q_1 - p_1*a_11*Q_1 - p_2*a_21*Q_1 - p_3*a_31*Q_1 - w*L_1 - r*D_1;
Pi_2 = p_2*Q_2 - p_1*a_12*Q_2 - p_2*a_22*Q_2 - p_3*a_32*Q_2 - w*L_2 - r*D_2;
Pi_3 = p_3*Q_3 - p_1*a_13*Q_3 - p_2*a_23*Q_3 - p_3*a_33*Q_3 - w*L_3 - r*D_3;
pi = (Pi_1+Pi_2+Pi_3) / (p_1*Y_1 + p_2*Y_2 + p_3*Y_3);
f_pi = -0.0065 + exp(-5)*exp(20*pi);
lambda = al/N*(Q_1+Q_2+Q_3);
phi_lambda = -phi0 + phi1/(1-lambda)^2;

d_K_1 = theta_1*f_pi*Y_1 - delta_1*K_1;
d_K_2 = theta_2*f_pi*Y_1 - delta_2*K_2;
d_K_3 = theta_3*f_pi*Y_1 - delta_3*K_3;
d_w = (phi_lambda + gamma*inf) * w;
d_al = - alpha * al;
d_N = beta * N;
d_D_1 = theta_1*f_pi*Y_1 - Pi_1;
d_D_2 = theta_2*f_pi*Y_1 - Pi_2;
d_D_3 = theta_3*f_pi*Y_1 - Pi_3;
d_theta_1 = sigma*theta_1*(theta_2*(r_1 - r_2)+theta_3*(r_1 - r_3));
d_theta_2 = sigma*theta_2*(theta_1*(r_2 - r_1)+theta_3*(r_2 - r_3));
d_theta_3 = sigma*theta_3*(theta_1*(r_3 - r_1)+theta_2*(r_3 - r_2));

dX = zeros(15,1);
dX(1) = d_K_1;
dX(2) = d_K_2;
dX(3) = d_K_3;
dX(4) = d_w;
dX(5) = d_al;
dX(6) = d_N;
dX(7) = d_D_1;
dX(8) = d_D_2;
dX(9) = d_D_3;
dX(10) = d_p_1;
dX(11) = d_p_2;
dX(12) = d_p_3;
dX(13) = d_theta_1;
dX(14) = d_theta_2;
dX(15) = d_theta_3;

end
