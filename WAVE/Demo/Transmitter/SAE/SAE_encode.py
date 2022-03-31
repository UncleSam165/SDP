from pyasn1.codec.der import encoder as DERencoder
from SAE_Asn import *
from helper import nmea2deg

import datetime

BSMcounter = 0

def createBSM(status, nmealatitude, nmealongitude, altitude, speed, vehicleWidth, vehicleLength):
    BSM = BasicSafetyMessage()
    BSM.setComponentByName('msgID', 1)
    global BSMcounter
    BSM.setComponentByName('msgCnt', BSMcounter)
    BSM.setComponentByName('id', status)
    nowTime = datetime.datetime.now()
    timeMS = int(str(nowTime.microsecond)[0:4])
    newlat = nmea2deg(nmealatitude)
    newlon = nmea2deg(nmealongitude)
    newlat = str(newlat).replace(".", "")
    newlon = str(newlon).replace(".", "")
    BSM.setComponentByName('secMark', timeMS)
    BSM.setComponentByName('lat', newlat)
    BSM.setComponentByName('long', newlon)
    BSM.setComponentByName('elev', altitude)
    BSM.setComponentByName('accuracy', "0000")
    newSpeed = int(float(speed) * 100)
    transAndSpeed = TransmissionAndSpeed()
    transAndSpeed.setComponentByName('state', 7)
    transAndSpeed.setComponentByName('speed', newSpeed)
    BSM.setComponentByName('speed', transAndSpeed)
    BSM.setComponentByName('heading', 0)
    BSM.setComponentByName('angle', "0")
    BSM.setComponentByName('accelSet', "acceler")
    BSM.setComponentByName('brakes', "nn")
    vehicleSize = VehicleSize()
    vehicleSize.setComponentByName('width', vehicleWidth)
    vehicleSize.setComponentByName('length', vehicleLength)
    BSM.setComponentByName('size', vehicleSize)
    BSMcounter = BSMcounter + 1
    if (BSMcounter == 126):
         BSMcounter = 0
    encodedMessage = DERencoder.encode(BSM)
    return encodedMessage

