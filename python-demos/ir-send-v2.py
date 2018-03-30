# IRLibCP by Chris Young. See copyright.txt and license.txt
# Sample program for sending one value of NEC protocol.
import board
import time
import IRLib_P01_NECs

mySend=IRLib_P01_NECs.IRsendNEC(board.REMOTEOUT)
Address=0x6
Data=int('0xff00ff') #0x1a0708f

while True:
  print("Sending NEC code with address={}, and data={}".format(hex(Address),hex(Data)))
  mySend.send(Data, Address)
  time.sleep(5)
