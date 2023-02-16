% Wyndor glass problem
% solver style

% Maximize Z = 3 x1 + 5 x2
% (The - is because matlab's linprog minimizes)
f = -[3 5];

% Subject to
%   x1        <= 4
%        2 x2 <= 12
% 3 x1 + 2 x2 <= 18

A = [ 1  0
      0  2
      3  2 ];

b = [4 12 18];

% Solve
[x, fval, exitflag, output, lambda] = linprog(f, A, b);

% Note that the resulting fval is the negative of the value
% we're actually, looking for,
% because we had to use negation to convert the maximization problem
% to minimization.