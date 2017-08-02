awk '
/^p/ {  
    nv=$3; ne=$4
    print "num_vertices=" nv ";"
    print "num_edges=" ne ";"
    print "adj_matrix=[" 
    for (i=1; i<=nv; i++) { for (j=1; j<=nv; j++) { adj[i][j] = 0 } } 
}

/^e/ {  adj[$2][$3]=1; adj[$3][$2]=1 }

END {
    for (i=1; i<=nv; i++) { 
        printf "|"
        for (j=1; j<=nv; j++) { 
            printf adj[i][j]
            if (j!=nv) printf "," 
        } 
        printf "\n" 
    }
    print "|];"
}
'
