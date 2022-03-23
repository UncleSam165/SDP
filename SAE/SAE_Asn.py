
from pyasn1.type import univ, namedtype, namedval, constraint, tag, char

# DSRCmsgID ::= ENUMERATED
class DSRCmsgID(univ.Enumerated):
    namedValues = namedval.NamedValues(
        ('reserved', 0),
        ('basicSafetyMessage', 1)
    )
    subtypeSpec = univ.Enumerated.subtypeSpec + constraint.SingleValueConstraint(0, 1)


# MsgCount ::= INTEGER (0..127)
class MsgCount(univ.Integer):
    subtypeSpec = univ.Integer.subtypeSpec + constraint.ValueRangeConstraint(0, 127)


# TemporaryID ::= OCTET STRING (SIZE(4))
class TemporaryID(univ.OctetString):
    subtypeSpec = constraint.ValueSizeConstraint(4, 4)


# DSecond ::= INTEGER (0..65535)
class DSecond(univ.Integer):
    subtypeSpec = univ.Integer.subtypeSpec + constraint.ValueRangeConstraint(0, 65535)


# Latitude ::= INTEGER (-900000000..900000001)
class Latitude(univ.Integer):
    subtypeSpec = univ.Integer.subtypeSpec + constraint.ValueRangeConstraint(-900000000, 900000001)


# Longitude ::= INTEGER (-1800000000..1800000001)
class Longitude(univ.Integer):
    subtypeSpec = univ.Integer.subtypeSpec + constraint.ValueRangeConstraint(-1800000000, 1800000001)

class Elevation(univ.OctetString):
    subtypeSpec = constraint.ValueSizeConstraint(2, 2)


class PositionalAccuracy(univ.OctetString):
    subtypeSpec = constraint.ValueSizeConstraint(4, 4)

class TransmissionState(univ.Enumerated):
    namedValues = namedval.NamedValues(
        ('neutral', 0),
        ('park', 1),
        ('forwardGears', 2),
        ('reverseGears', 3),
        ('reserved1', 4),
        ('reserved2', 5),
        ('reserved3', 6),
        ('unavailable', 7)
    )
    subtypeSpec = univ.Enumerated.subtypeSpec + constraint.SingleValueConstraint(0, 1, 2, 3, 4, 5, 6, 7)

class Speed(univ.Integer):
    subtypeSpec = univ.Integer.subtypeSpec + constraint.ValueRangeConstraint(0, 8191)

class TransmissionAndSpeed(univ.Sequence):
    componentType = namedtype.NamedTypes(
        namedtype.NamedType('state', TransmissionState()),
        namedtype.NamedType('speed', Speed())
    )
class Heading(univ.Integer):
    subtypeSpec = univ.Integer.subtypeSpec + constraint.ValueRangeConstraint(0, 28800)

class SteeringWheelAngle(univ.OctetString):
    subtypeSpec = constraint.ValueSizeConstraint(1, 1)

class AccelerationSet4Way(univ.OctetString):
    subtypeSpec = constraint.ValueSizeConstraint(7, 7)

class BrakeSystemStatus(univ.OctetString):
    subtypeSpec = constraint.ValueSizeConstraint(2, 2)

class VehicleWidth(univ.Integer):
    subtypeSpec = univ.Integer.subtypeSpec + constraint.ValueRangeConstraint(0, 1023)

class VehicleLength(univ.Integer):
    subtypeSpec = univ.Integer.subtypeSpec + constraint.ValueRangeConstraint(0, 16383)

class VehicleSize(univ.Sequence):
    componentType = namedtype.NamedTypes(
        namedtype.NamedType('width', VehicleWidth()),
        namedtype.NamedType('length', VehicleLength()),
    )

class BasicSafetyMessage(univ.Sequence):
    componentType = namedtype.NamedTypes(
        namedtype.NamedType('msgID', DSRCmsgID()),
        namedtype.NamedType('msgCnt', MsgCount()),
        namedtype.NamedType('id', TemporaryID()),
        namedtype.NamedType('secMark', DSecond()),
        namedtype.NamedType('lat', Latitude()),
        namedtype.NamedType('long', Longitude()),
        namedtype.NamedType('elev', Elevation()),
        namedtype.NamedType('accuracy', PositionalAccuracy()),
        namedtype.NamedType('speed', TransmissionAndSpeed()),
        namedtype.NamedType('heading', Heading()),
        namedtype.NamedType('angle', SteeringWheelAngle()),
        namedtype.NamedType('accelSet', AccelerationSet4Way()),
        namedtype.NamedType('brakes', BrakeSystemStatus()),
        namedtype.NamedType('size', VehicleSize())
    )

