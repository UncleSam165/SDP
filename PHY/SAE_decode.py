from pyasn1.codec.der import decoder as DERdecoder
from SAE_encode import *
import sys

def decodeBSM(encodedBSM):
    decoded = DERdecoder.decode(encodedBSM, asn1Spec=BasicSafetyMessage())
    return decoded[0]

def getMessageType(encodedMsg):
    try:
        decoded = DERdecoder.decode(encodedMsg)
        return "BSM"
    except Exception as err:
        return "STDMSG: " + str(err)

if __name__ == '__main__':
    #print(sys.argv[1])
    x = bytes.fromhex(sys.argv[1])
    print(decodeBSM(x))
