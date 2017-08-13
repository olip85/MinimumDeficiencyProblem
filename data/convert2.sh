awk '
	/^p/ {  
		nv=$3; ne=$4
		print "num_vertices=" nv ";"
		print "num_edges=" ne ";"
		printf "node_edges=["

		arr_num=1
		for (i=1; i<=nv; i++) {node_edges[i]="{"}
	}

	/^e/ {
		if ($2>$3) {
			node_edges[$2] = node_edges[$2] NR-1 ","
			node_edges[$3] = node_edges[$3] NR-1 ","
		}
	}

	END {
		for (i=1; i<nv; i++) {print node_edges[i]}
		printf node_edges[nv]
		print "];"
	}
' | sed 's/,$/},/' | sed 's/,]/}]/'
