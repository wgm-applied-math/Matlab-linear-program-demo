% Wyndor glass problem
% problem style

% Maximize Z = 3 x1 + 5 x2
x1 = optimvar('x1', LowerBound=0);
x2 = optimvar('x2', LowerBound=0);
prob = optimproblem(Objective=3*x1 + 5*x2, ObjectiveSense='max');

% Subject to
%   x1        <= 4
%        2 x2 <= 12
% 3 x1 + 2 x2 <= 18

prob.Constraints.c1 = x1 <= 4;
prob.Constraints.c2 = 2*x2 <= 12;
prob.Constraints.c3 = 3*x1 + 2*x2 <= 18;


% Solve
% Either of these works:

% 1. Convert the problem specification to a problem structure
% problem = prob2struct(prob);
%
% [x, fval, exitflag, output, lambda] = linprog(problem);
%
% Matlabism: We specified a maximization problem,
% but the coversion changes it to minimizing the negative
% of the objective function and linprog() DOES NOT apply
% the negation needed to convert it back.

% 2. Use solve() on the problem specification object.
% solve() detects that the problem is to maximize something,
% converts the problem into minimizing the negative of the objective
% function, and it DOES apply the negation needed to convert the result
% back.
[x_sol, fval, exitflag, output, lambda] = solve(prob);
