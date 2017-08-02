include "globals.mzn";


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Constants
int: num_vertices;
int: num_edges;

set of int: VERTICES = 1..num_vertices;
set of int: EDGES = 1..num_edges;
set of int: COLORS = 1..num_vertices;
set of int: COLORS0 = 0..num_vertices;

array[VERTICES, VERTICES] of 0..1: adj_matrix;

% Auxiliary variables
array[VERTICES] of var int: incident;
constraint forall(v in VERTICES)(
  incident[v] = sum(row(adj_matrix, v))
);

% Decision variables
array[VERTICES, VERTICES] of var COLORS0: edges_cols;
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
constraint forall(v in VERTICES)(
  alldifferent_except_0(row(edges_cols, v))
);

constraint forall(v in VERTICES)(
  alldifferent_except_0(col(edges_cols, v))
);

constraint forall(v1, v2 in VERTICES)(
  edges_cols[v1, v2] = edges_cols[v2, v1]
);

constraint forall(v1, v2 in VERTICES)(
  if adj_matrix[v1, v2] == 0
  then edges_cols[v1, v2] == 0
  else edges_cols[v1, v2] != 0
  endif
);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objectives
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var int: obj =
  sum(v in VERTICES)(
    max(row(edges_cols, v)) - min([row(edges_cols, v)[i] | i in VERTICES where row(adj_matrix, v)[i] != 0]) + 1 - incident[v]
  );

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%solve::int_search(edges_cols, dom_w_deg, indomain_random, complete) minimize obj;
solve minimize obj;
 
output ["z=" ++ show(obj) ++ "\n"]