import sys

fn = sys.argv[1]
with open(fn) as f:
    lines_list = f.readlines()
f.close()

line1 = lines_list[0].split()
f = open(fn+".dzn", "w")
f.write("num_vertices = " + line1[2] + ";\n")
f.write("num_edges = " + line1[3] + ";\n")

matrix = []

for i in range(1, len(lines_list)):
    print(lines_list[i])
