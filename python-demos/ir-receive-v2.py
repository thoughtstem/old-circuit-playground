import board
import time
import IRLibDecodeBase
import IRLib_P01_NECd
import IRLib_P02_Sonyd
import IRLib_P03_RC5d
import IRrecvPCI

class MyDecodeClass(IRLibDecodeBase.IRLibDecodeBase):
        def __init__(self):
                IRLibDecodeBase.IRLibDecodeBase.__init__(self)
        def  decode(self):
                if IRLib_P01_NECd.IRdecodeNEC.decode(self): 
                        return True
                else:
                        return False
                
myDecoder=MyDecodeClass()

myReceiver=IRrecvPCI.IRrecvPCI(board.REMOTEIN)
myReceiver.enableIRIn() 
print("send a signal")
while True:
   try:
        while (not myReceiver.getResults()):
                pass
        if myDecoder.decode():
                print("success")
        else:
                print("failed")
        #myDecoder.dumpResults(True)
        print("HEX?")
        print(hex(myDecoder.value))
        myReceiver.enableIRIn() 
   except:
        print("ERROR")
        time.sleep(2)
