from SAE_decode import *
import time
from decimal import Decimal

# Random coordinates
Latitude = "7532.88"
Longitude= "13245.245"
Altitude = "13"
speed = "50"
vehicleWidth = "800"
vehicleLength = "120"
vehicleStatus = "NORM" 

encodedBSM = createBSM(vehicleStatus,Latitude,Longitude,Altitude, speed, vehicleWidth, vehicleLength)
print(encodedBSM.hex())
