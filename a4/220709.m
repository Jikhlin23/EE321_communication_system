%Nikhil Jain 220709
% Aim : To decode a BPSK signal using the Viterbi algorithm
% Vhannel's impulse response: h[0] = 3/2, h[1] = -1/2

% Input parameters
h = [3/2, -1/2];                        % Channel response: affects current and previous bit
y = [-1, 2, -2, 1.5, 2, 1, -2, 0.5, -1, 2]; % Matched filter outputs
states = [-1, 1];                       % BPSK bit values: -1 or +1
b0 = 1;                                 % b[0] = +1 (given)
b9 = 1;                                 % b[9] = +1 (given)
L = length(y) - 1;                      % We're decoding b[1] to b[8], so 8 unknown bits

% Set up the Viterbi trellis first
[path_metrics, prev_states, bit_decisions] = initialize_viterbi(L, states, b0); 


% Viterbi algorithmn
[path_metrics, prev_states, bit_decisions] = run_viterbi_algorithm(h, y, states, L, path_metrics, prev_states, bit_decisions); 
% Main Viterbi loop: loops through all bit possibilities, updates path metrics

% Backtrack to find the best sequence, starting from b[9] = +1
decoded_bits = trace_back(states, b9, L, bit_decisions, prev_states); 
% decoded_bits: Array to hold the decoded bits (b[1] to b[8])

% Show the decoded sequence for b[1] to b[8]
disp('Here are the decoded bits (b[1] to b[8]):');
disp(decoded_bits(1:8));



function [path_metrics, prev_states, bit_decisions] = initialize_viterbi(L, states, b0)
    % Initialize trellis matrices and set path metric for b[0] = +1
    path_metrics = inf(L+1, 2);             % Path metrics table, start with inf
    prev_states = zeros(L+1, 2);            % Tracks previous states for backtracking
    bit_decisions = zeros(L+1, 2);          % Stores the bit choices at each step
    path_metrics(1, states == b0) = 0;      % Set initial path metric for b[0] = +1
end

function [path_metrics, prev_states, bit_decisions] = run_viterbi_algorithm(h, y, states, L, path_metrics, prev_states, bit_decisions)
    % Viterbi decoding logic: predict y, compute metric, keep best path
    for n = 1:L
        for curr_state = 1:2                % Loop through possible current states
            current_bit = states(curr_state); % Grab the current bit (-1 or +1)
            for prev_state = 1:2            % Check all possible previous states
                prev_bit = states(prev_state); % Get the previous bit

                % Predict the matched filter output
                predicted_y = h(1)*current_bit + h(2)*prev_bit;

                % Compute the Euclidean distance (error) between actual and predicted
                curr_metric = path_metrics(n, prev_state) + (y(n) - predicted_y)^2;

                % Keep the path with the smallest metric (survivor path)
                if curr_metric < path_metrics(n+1, curr_state)
                    path_metrics(n+1, curr_state) = curr_metric; % Update the metric
                    prev_states(n+1, curr_state) = prev_state;  % Save the previous state
                    bit_decisions(n+1, curr_state) = current_bit; % Record the bit
                end
            end
        end
    end
end

function decoded_bits = trace_back(states, b9, L, bit_decisions, prev_states)
    % Traceback logic: starts at b[9] = +1 and walks backward
    decoded_bits = zeros(1, L);             % Array to hold the decoded bits
    current_state = find(states == b9);     % Start at the state for b[9]
    
    for n = L:-1:1
        decoded_bits(n) = bit_decisions(n+1, current_state); % Grab the bit
        current_state = prev_states(n+1, current_state);    % Move to the previous state
    end
end
