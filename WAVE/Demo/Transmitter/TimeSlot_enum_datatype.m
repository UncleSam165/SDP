classdef TimeSlot_enum_datatype < Simulink.IntEnumType
  enumeration
    TimeSlot0(0)
    TimeSlot1(1)
    Either(2) 
  end
  methods (Static)
    function retVal = getDefaultValue()
      retVal = TimeSlot_enum_datatype.Either;
    end
  end
end