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

assert(min(size(A.dl) == size(A.ds)), ...
    'Invalid input structure, fields "dl" and "ds" do not have the same size!')

obj = struct('dl', A.dl, 'ds', A.ds);
aux = struct('i',A.most_related_iteration,...
    'pred',A.most_related_predicate_index);

end
