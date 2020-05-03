# Utility script to dump free bytes at end of banks

from struct import unpack

with open('baserom.gbc', 'rb') as rom:
	for i in range(1, 0x20):
		rom.seek(i * 0x4000 + 0x3fff - 1)
		x = 0
		while unpack("B", rom.read(1))[0] == 0x00:
			x += 1
			rom.seek(-2, 1)
		pos = 0x4000 + rom.tell() % 0x4000
		print('SECTION "BANK{:02x}_END", ROMX[${:x}], BANK[${:x}]'.format(i, pos, i))
		print('BANK{:02x}_END::'.format(i))
		print('REPT ${:x}'.format(0x8000 - pos))
		print('  db 0')
		print('ENDR')
		print('')