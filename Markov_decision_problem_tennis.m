% This is the Markov decision process from chapter 19

% States:
% i=1: 0, before the first serve
% i=2: 1, one failed serve, before the second serve

% Decisions:
% k=1: attempt an ace
% k=2: attempt a lob

% Cost matrix:
% C(i, k) = cost of decision k | in state i
cost = [  -1/8  7/24
           1/2  10/24 ];

% Transitions:
% p(state now, state next, decision)
p_ace = [ 3/8  5/8
            1    0 ];

p_lob = [ 7/8  1/8
            1    0 ];

p = cat(3, p_ace, p_lob);

% Unknonws:
% y_{ik} = probability state is i and decision k is made
y = optimvar('y', size(cost), LowerBound=0);


% Objective:
% Minimize long term average cost per time step
Z = sum(cost .* y, 'all');
prob = optimproblem(Objective=Z, ObjectiveSense='min');

% Constraints:

% Probability mass
prob.Constraints.PM = sum(y, 'all') == 1;

% Long-term transition equilibrium
prob.Constraints.Transition = [];
for j = 1:size(y, 1)
    lhs = sum(y(j,:));
    for k = 1:size(p, 3)
        for i = 1:size(y, 1)
            lhs = lhs - y(i,k) * p(i, j, k);
        end
    end
    prob.Constraints.Transition(j) = lhs == 0;
end

[y_sol, fval, exitflag, output, lambda] = solve(prob);

% D(i,k) = prob decision k | state i
% but the y array should end up being all 0s except for one 1 in each row
D_sol = y_sol.y ./ sum(y_sol.y, 2);
