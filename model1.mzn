include "globals.mzn";
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Constants
int: num_vertices;
int: num_edges;

set of int: VERTICES = 1..num_vertices;
set of int: EDGES = 1..num_edges;

array[VERTICES] of set of int: node_edges;

set of int: COLORS = 1..max([card(v) | v in node_edges])*2;

% Decision variables
array[EDGES] of var COLORS: edge_col;

% Auxiliary variables
array[VERTICES] of var int: incident;
array[VERTICES] of var int: min_col;
array[VERTICES] of var int: max_col;

constraint forall(v in VERTICES) (
  min_col[v]  = min([edge_col[i] | i in node_edges[v]]) /\
  max_col[v]  = max([edge_col[i] | i in node_edges[v]]) /\
  incident[v] = card(node_edges[v])
);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
constraint forall(v in VERTICES) (
  alldifferent([edge_col[i] | i in node_edges[v]])
);

% constraint edge_col[1] = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var int: obj = sum(v in VERTICES)(max_col[v] - min_col[v] + 1 - incident[v]);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve::int_search(edge_col, dom_w_deg, indomain_median, complete) minimize obj;
 
output ["z=" ++ show(obj) ++ "\n"]