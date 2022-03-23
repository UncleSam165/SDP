from math import radians, cos, sin, asin, sqrt, modf


def nmea2deg(coordinate):
    splitCoordinate = str(coordinate).split(".")
    degree = splitCoordinate[0][0:-2]
    minutesCoordinate = splitCoordinate[0][-2:] + "." + splitCoordinate[1]
    division = float(minutesCoordinate) / 60
    division = '%.6f' % round(division, 6)
    return int(degree) + float(division)

