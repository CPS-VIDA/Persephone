classdef Persephone
    % PERSEPHONE An umbrella class for the Persephone toolbox
    %
    % This class acts as a wrapper around the tools provided by the Persephone
    % toolbox. Most of the independent functions that will be used are defined
    % as "Static" methods.
    %
    % For example, to run the TQTL monitoring on a sequence (stream) of states
    % `SeqS`, against a TQTL specification defined by `phi` and `Pred` you
    % would run:
    %       [rob, aux] = Persephone.monitor(phi, Pred, SeqS)
    %
    %
    %   TQTL specifications:
    %
    % phi := p | (phi) | !phi | phi \/ phi | phi /\ phi |
    %          | phi -> phi | phi <-> phi |
    %          | X phi | phi U phi | phi R phi | <> phi | [] phi
    %          | @ Var_a | ... | @ Var_z |
    %          | { Var_a <= r } | { Var_a < r } | { Var_a == r } |
    %          | { Var_z >= r } | { Var_z > r }
    %   where:
    %         p      is a predicate. Its first character must be a lowercase
    %                 letter and it may contain numeric digits.
    %                 Examples:
    %                     pred1, isGateOpen2
    %         !      is 'Not'
    %         \/     is 'Or'
    %         /\     is 'And'
    %         ->     is 'Implies'
    %         <->    if 'If and only if'
    %         X      is the 'Next' operator. It means that the next event
    %                 should occur.
    %         U      is the 'Until' operator.
    %         R      is the 'Release' operator.
    %         <>     is the 'Eventually' operator.
    %         []     is the 'Always' operator.
    %         @ Var_a  is the 'Freeze time operator' for Var_a time variable.
    %         { Var_a <= r },{ Var_a < r },{ Var_a == r },{ Var_z >= r },
    %         { Var_z > r }
    %                 are the 'time constraints' of TPTL. Time constraints
    %                 must be represented inside curly brackets { tc }. Time
    %                 constraints must be of the form { x ~ r } where x is a
    %                 time variable, r is a real value, and ~ is a relational
    %                 operator.
    %
    %   Examples:
    %       * Bounded response:
    %           Always 'a' implies eventually 'b' within 1 time unit
    %           phi = '[](a -> @ Var_x <>( b /\ { Var_x <= 1 }))';
    %
    %           MTL equivalent: Use dp_taliro to compute the robusntees of
    %           phi_MTL = '[](a -> <>_[0,1] b)';
    %
    %       * Bounded response (TPTL):
    %           Any occurrence of a problem 'p' will eventually trigger
    %           alarm 'a' and then eventually enter failsafe mode 'f'
    %           within at most 5 time units.
    %           phi = '[](p -> @ Var_x <>( a /\ <>(f /\ { Var_x <= 5} )))';
    %
    %       * 'a' is true until 'b' becomes true after 4 and before 7.5
    %         time units
    %           phi = '@ Var_x ( a U (b /\{ Var_x < 4 }/\{ Var_x < 7.5 })';
    %
    %           MTL equivalent: Use dp_taliro to compute the robusntees of
    %           phi_MTL = 'a U_(4,7.5) b';
    %
    %       * 'p1' eventually will become true between 0.1 and 3.6
    %         time units
    %           phi = '@ Var_x <>(p1 /\{ Var_x <= 0.1 }/\{ Var_x < 3.6 })';
    %
    %           MTL equivalent: Use dp_taliro to compute the robusntees of
    %           phi_MTL = '<>_[0.1,3.6) p1';
    %
    %
    % Pred - The mapping of the predicates to their respective states.
    %
    %         Pred(i).str : the predicate name as a string
    %         Pred(i).A, Pred(i).b : a constraint of the form Ax<=b
    %         Pred(i).loc : is a vector with the control locations on which
    %             the predicate should hold in case of trajectories of hybrid
    %             systems. If the control location vector is empty, then the
    %             predicate should hold in any location, i.e., this is
    %             equivalent with including in loc all the Hybrid Automaton
    %             locations.
    %         Pred(i).Normalized : 0 - No normalization
    %                             1 - normalize robusntess to range [-1,1]
    %         Pred(i).NormBounds : A 1D or 2D array that contains the bounds
    %             on the distance for normalization.
    %             Pred(i).NormBounds(1) : The maximum absolute robustenss
    %                 value for Euclidean distances.
    %                 E.g., if Pred(i).NormBounds = 2.5, then any
    %                 robustness value will be first saturated to the
    %                 interval [-2.5,2.5] and then mapped to the interval
    %                 [-1,1].
    %             Pred(i).NormBounds(2) : The maximum path distance on the
    %                 control location graph.
    %             Remarks:
    %             (1) Normalization does not affect +/- inf values returned
    %                 due to violations of the real-time constraints of
    %                 the temporal operators.
    %             (2) If normalization of hybrid distances is requested, then
    %                 the return robustness value is going to be HyDis object
    %                 where the path component is 0 and the Euclidean
    %                 component stores the normalized hybrid distance.
    %
    % Most of this code is based on code written by Georgios Fainekos
    % (Arizon State University) and Adel Dokhanchi (Arizona State University)
    % for S-TaLiRo toolbox for Matlab.
    
    methods (Static)
        function [rob, aux] = monitor(phi, Pred, seqS, seqT)
            % Compute the robustness estimate for data streams against TQTL formulas.
            %
            % Inputs:
            %
            %   phi - String containing TQTL formula (see Persephone)
            %
            %   Pred - Struct containing predicate definitions (see Persephone)
            %
            %   seqS - The sequence of states from a Euclidean space X. Each row must
            %          be a different sampling instance and each column a different
            %	       dimension in the state space.
            %
            %	       For example, a 2D signal sampled at 3 time instances is:
            %
            %               seqS = [0.1  0.2;
            %                       0.15 0.19;
            %                       0.14 0.18];
            %
            %   seqT - The time-stamps of the trace. It must be a column vector.
            %          For example:
            %               seqT = [0 0.1 0.2]';
            %          It should be a monotonically increasing sequence.
            %          Enter [] or ignore if you are interested only about LTL
            %          properties.
            %
            % Outputs:
            %
            %   rob - the robustness estimate. This is a HyDis object for hybrid system
            %	      trajectory robustness. To get the continuous state robustness
            %	      type get(rob,2).
            %
            %   aux - information about the most related iteration and most related
            %         predicate.
            %         aux.i indicates the most related iteration of the rob
            %         aux.pred indicates the most related predicate index of the rob
            %
            %         Example for aux:
            %           c_pred = get_predicate_index(aux.pred,pred);
            %           SignedDist(x(aux.i,:),c_pred.A,c_pred.b) == monitor(phi,pred,X,T);
            %
            %
            % See also PERSEPHONE
            clear TQMonitor
            
            seqS = double(seqS);
            if nargin==3 || (nargin==4 && isempty(seqT))
                [tmp_rob,aux] = tq_casting(TQMonitor(phi,Pred,seqS));
                rob = tmp_rob.ds;
            elseif nargin==4
                [tmp_rob,aux] = tq_casting(TQMonitor(phi,Pred,seqS,seqT));
                rob = tmp_rob.ds;
            end
            
            % TODO(anand): While this is based on the TP-Taliro code, the Hybrid
            % automata arguments have been intentionally ommited, as there
            % doesn't seem to be any use in providing that functionality for
            % monitoring perceptual systems using TQTL (yet!).
            clear TQMonitor
        end
    end
end


function [obj, aux] = tq_casting(A)
% TQ_CASTING    Instantiates tq_casting objects for hybrid distance
% robustness and best iteration and best predicate computations.
%
%   [OBJ,AUX] = TQ_CASTING(A)
%
%
% A is struct containing fields for hybrid  distance
% robustness, most_related_iteration, and most_related_predicate_index,
% this function outputs two objects:
%
%   OBJ: struct representing hybrid distance robustness.
%   AUX: struct containing Best Iteration and Best Predicate.

assert(isa(A, 'struct'), 'Input structure is not a struct')

hydis_fields = {'dl', 'ds',...
    'most_related_iteration', 'most_related_predicate_index'};
assert(min(isfield(A, hydis_fields)), ...
    'Invalid input structure, needs fields: %s, %s, %s, %s', hydis_fields{:})

assert(min(size(A.dl)) == size(A.ds), ...
    'Invalid input structure, fields "dl" and "ds" do not have the same size!')

obj = struct('dl', A.dl, 'ds', A.ds);
aux = struct('i',A.most_related_iteration,...
    'pred',A.most_related_predicate_index);

end