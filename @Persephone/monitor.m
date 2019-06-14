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

