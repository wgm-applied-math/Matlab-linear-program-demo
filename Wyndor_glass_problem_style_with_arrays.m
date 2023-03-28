% Wyndor glass problem
% problem style

% Maximize Z = 3 x1 + 5 x2
x = optimvar('x', 2, LowerBound=0);
prob = optimproblem(Objective=[3 5] * x , ObjectiveSense='max');

% Subject to
%   x1        <= 4
%        2 x2 <= 12
% 3 x1 + 2 x2 <= 18

constr_mat = [ 1 0 
               0 2
               3 2 ];

constr_val = [ 4; 12; 18 ];

prob.Constraints.C = constr_mat * x <= constr_val;


% Solve
[x_sol, fval, exitflag, output, lambda] = solve(prob);
