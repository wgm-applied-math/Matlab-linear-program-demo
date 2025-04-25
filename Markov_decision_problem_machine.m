%% Markov decision process - machine example from chapter 19

% States:
% i=1: machine in state 0, good as new
% i=2: machine in state 1, minor deterioration
% i=3: machine in state 2, major deterioration
% i=4: machine in state 3, inoperable

% Allowed decisions:
% k=1: do nothing for machine in state 0, 1, 2
% k=2: overhaul machine in state 2, returns it to state 1
% k=3: replace machine in state 3, returns it to state 0

% Cost matrix:
% C(i, k) = cost of decision k | in state i
% in thousands of dollars
% -1 marks disallowed combinations
cost = [  0  -1  -1
          1  -1   6
          3   4   6
         -1  -1   6];

allowed = cost >= 0;

% Transitions:
% p(state now, state next, decision)
p_nothing = [ 0  7/8  1/16  1/16
              0  3/4  1/8   1/8
              0  0    1/2   1/2
              0  0    0     1    ];

p_overhaul = [ 0  7/8  1/16  1/16
               0  3/4  1/8   1/8
               0  1    0     0
               0  0    0     1    ];

p_replace = [ 0  7/8  1/16  1/16
              1  0    0     0
              1  0    0     0
              1  0    0     0    ];


p = cat(3, p_nothing, p_overhaul, p_replace);

% Unknonws:
% y_{ik} = probability state is i and decision k is made
y = optimvar('y', size(cost), LowerBound=0);


% Objective:
% Minimize long term average cost per time step
Z = sum(cost .* allowed .* y, 'all');
prob = optimproblem(Objective=Z, ObjectiveSense='min');

% Constraints:

% Probability mass
prob.Constraints.PM = sum(y, 'all') == 1;

% Long-term transition equilibrium
prob.Constraints.Transition = [];
for j = 1:size(y, 1)
    lhs = sum(y(j,:));
    for k = 1:size(y, 2)
        for i = 1:size(y, 1)
            lhs = lhs - y(i,k) * p(i, j, k);
        end
    end
    prob.Constraints.Transition(j) = lhs == 0;
end

% Disallowed decisions
prob.Constraints.Disallowed = (~allowed .* y == 0);

[y_sol, fval, exitflag, output, lambda] = solve(prob);

% D(i,k) = prob decision k | state i
% but the y array should end up being all 0s except for one 1 in each row
D_sol = y_sol.y ./ sum(y_sol.y, 2);

% And this agrees with what's in the book.


%% Assemble overall transition matrix

P_overall = zeros([4, 4]);
for i = 1:4
    [one, k] = max(D_sol(i,:));
    P_overall(i, :) = p(i, :, k);
end

%% Double check the long-term-average cost

C_col = [ 0 ; 1000 ; 4000 ; 6000 ];

[V, D, W] = eig(P_overall);
[d, ind] = sort(diag(abs(D)));
w_unscaled = W(:,ind(end))';
w = w_unscaled / sum(w_unscaled);

ltavgCost = w * C_col;