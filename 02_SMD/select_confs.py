import sys

with open('summary_distances.dat', 'r') as fin:
    spacing = 0.2 
    #spacing = float(sys.argv[1]) 
    series = []
    for i, line in enumerate(fin):
        iframe, com = int(line.strip().split()[0]), float(line.strip().split()[1])
        series.append([iframe, com])

#print(series)
p = 1
rounded_series = list(map(lambda x:[x[0],round(x[1], p)], series))

#print(rounded_series)
landmark_pls_ndr = rounded_series[0][1] + spacing
snap_no      = [rounded_series[0][0]]

i = 0
for iframe, rounded_com in rounded_series:

    if rounded_com >= landmark_pls_ndr: 
        print(i, iframe, rounded_com) 
        snap_no.append(iframe)
        landmark_pls_ndr += spacing
        i += 1

with open('list_selected_confs.txt','w') as fout:
    for i, iframe in enumerate(snap_no):
        fout.write('{}\n'.format(iframe))

