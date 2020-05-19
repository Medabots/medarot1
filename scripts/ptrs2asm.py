import os, sys
from shutil import copyfile
sys.path.append(os.path.join(os.path.dirname(__file__), 'common'))
from common import utils

if __name__ == '__main__':
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    with open(output_file, 'w') as f:
    	t = utils.read_table(input_file, keystring=True)
    	for k in t:
    		f.write("c{:<5}           EQU ${:04X}\n".format(k, int(t[k],16)))
