import csv

outF = open("img_list.txt", "w")

img_path = 'D:/mobio/'
f = csv.reader(open('0_final_detected_bbox_list_20481.csv', 'rb'))
for row in f:
    name = row[0]
    if name == 'name':
        continue
    x1 = row[1]
    y1 = row[2]
    width = str(int(row[3]) - int(row[1]))
    height = str(int(row[4]) - int(row[2]))

    line = img_path + name + ' ' + x1 + ' ' + y1 + ' ' + width + ' ' + height
    outF.write(line)
    outF.write("\n")

outF.close()



