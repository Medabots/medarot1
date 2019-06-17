import os, sys
from shutil import copyfile
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

if __name__ == '__main__':
    input_file1 = sys.argv[1]
    input_file2 = sys.argv[2]
    output_file = sys.argv[3]

    with open(output_file, 'w') as f:
    	t1 = utils.read_table(input_file1, keystring=True)
    	t2 = utils.read_table(input_file2, keystring=True)
    	for k in t1:
    		f.write("c{:<5}           EQU ${:04X}\n".format(k, int(t1[k],16)))
    		f.write("c{:<9}       EQU ${:04X}\n".format("%sSize" % k, int(t2[k],16)))
    		