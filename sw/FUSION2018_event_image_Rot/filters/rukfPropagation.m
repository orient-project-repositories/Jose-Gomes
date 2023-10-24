function [S] = rukfPropagation(dt,chi,chiAnt,omega_b,S,omega,Qc,g)
% Right-UKF on Lie Groups
q = length(S);
S_aug = blkdiag(S,Qc);
N_aug = length(S_aug);

% scaled unsented transform
W0 = 1-N_aug/3;
Wj = (1-W0)/(2*N_aug);
gamma = sqrt(N_aug/(1-W0));

% Prediction
ichi = invSE3(chi);
omega = omega-omega_b; % unbiased inputs
% acc = acc-a_b;
X = gamma*[zeros(N_aug,1) S_aug' -S_aug'];% sigma-points
X(4:6,:) = X(4:6,:)+X(q+4:q+6,:)*dt; % add bias noise
for j = 2:2*N_aug+1
    xi_j = X([1:3,7:q],j); % not bias
    w_j = X(q+1:N_aug,j);
    omega_bj = X(4:6,j);
%     a_bj = X(13:15,j);
    chi_j = exp_multiSE3(xi_j)*chiAnt;
    Rot = chi_j(1:3,1:3)*expSO3((omega+w_j(1:3)-omega_bj)*dt);
%     v = chi_j(1:3,4)+(Rot*(acc+w_j(4:6)-a_bj)+g)*dt;
%     x = chi_j(1:3,5)+v*dt;
    chi = state2chi(Rot,chi_j(1:3,4:end));
    Xi_j = chi*ichi;
    X([1:3,7:q],j) = log_multiSE3(Xi_j); % propagated sigma points
end
X = sqrt(Wj)*X;
[~,Rs] = qr(X(1:q,2:2*N_aug+1)');
S = Rs(1:q,1:q);
end
