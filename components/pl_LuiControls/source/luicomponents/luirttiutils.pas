unit LuiRTTIUtils;

{
  Auxiliary RTTI functions

  Copyright (C) 2010 Luiz Américo Pereira Câmara

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure SetObjectProperties(Instance: TObject; const Properties: array of const);

implementation

uses
  typinfo;

function VarRecToString(const VarRec: TVarRec): String;
begin
  case VarRec.VType of
    vtAnsiString: Result := AnsiString(VarRec.VAnsiString);
    vtPChar: Result := String(VarRec.VPChar);
    vtString: Result := VarRec.VString^;
  else
    raise Exception.Create('Type mismatch: is not possible convert TVarRec to String');
  end;
end;

function VarRecToInteger(const VarRec: TVarRec): Integer;
begin
  case VarRec.VType of
    vtInteger: Result := VarRec.VInteger;
  else
    raise Exception.Create('Type mismatch: is not possible convert TVarRec to Integer');
  end;
end;

function VarRecToInt64(const VarRec: TVarRec): Int64;
begin
  case VarRec.VType of
    vtInteger: Result := VarRec.VInteger;
    vtInt64: Result := (VarRec.VInt64)^;
  else
    raise Exception.Create('Type mismatch: is not possible convert TVarRec to Int64');
  end;
end;

function VarRecToFloat(const VarRec: TVarRec): Double;
begin
  case VarRec.VType of
    vtInteger: Result := VarRec.VInteger;
    vtInt64: Result := (VarRec.VInt64)^;
    vtExtended: Result := (VarRec.VExtended)^;
  else
    raise Exception.Create('Type mismatch: is not possible convert TVarRec to Double');
  end;
end;


function VarRecToObject(const VarRec: TVarRec): TObject;
begin
  case VarRec.VType of
    vtObject: Result := VarRec.VObject;
  else
    raise Exception.Create('Type mismatch: is not possible convert TVarRec to TObject');
  end;
end;

function VarRecToInterface(const VarRec: TVarRec): Pointer;
begin
  case VarRec.VType of
    vtInterface: Result := VarRec.VInterface;
  else
    raise Exception.Create('Type mismatch: is not possible convert TVarRec to Interface');
  end;
end;

function VarRecToBoolean(const VarRec: TVarRec): Integer;
begin
  case VarRec.VType of
    vtBoolean: Result := Integer(VarRec.VBoolean);
  else
    raise Exception.Create('Type mismatch: is not possible convert TVarRec to Boolean');
  end;
end;

procedure SetObjectProperties(Instance: TObject; const Properties: array of const);
var
  i, PropCount: Integer;
  PropInfo: PPropInfo;
  ClassInfo: PTypeInfo;
  PropertyName, PropertyValue: TVarRec;
begin
  PropCount := Length(Properties);
  if PropCount = 0 then
    Exit;
  if odd(PropCount) then
    raise Exception.Create('SetObjectProperties - Properties must of even length');
  if Instance = nil then
    raise Exception.Create('SetObjectProperties - Instance is nil');
  ClassInfo := Instance.ClassInfo;
  for i := Low(Properties) to PropCount - 2 do
  begin
    //param names are at an even index and should of ansistring type
    PropertyName := Properties[i];
    if odd(i) or (PropertyName.VType <> vtAnsiString) then
      continue;
    //todo: optimize - use GetPropInfos to get all properties at once
    PropInfo := GetPropInfo(ClassInfo, AnsiString(PropertyName.VAnsiString));
    if PropInfo <> nil then
    begin
      PropertyValue := Properties[i + 1];
      case PropInfo^.PropType^.Kind of
        tkAString, tkSString:
          SetStrProp(Instance, PropInfo, VarRecToString(PropertyValue));
        tkInteger:
          SetOrdProp(Instance, PropInfo, VarRecToInteger(PropertyValue));
        tkInt64:
          SetInt64Prop(Instance, PropInfo, VarRecToInt64(PropertyValue));
        tkFloat:
          SetFloatProp(Instance, PropInfo, VarRecToFloat(PropertyValue));
        tkClass:
          SetObjectProp(Instance, PropInfo, VarRecToObject(PropertyValue));
        tkInterface:
          SetInterfaceProp(Instance, PropInfo, IInterface(VarRecToInterface(PropertyValue)));
        tkInterfaceRaw:
          SetRawInterfaceProp(Instance, PropInfo, VarRecToInterface(PropertyValue));
        tkBool:
          SetOrdProp(Instance, PropInfo, VarRecToBoolean(PropertyValue));
      else
        raise Exception.CreateFmt('SetObjectProperties - Error setting %s: kind %s is not supported',
          [PropInfo^.Name, GetEnumName(TypeInfo(TTypeKind), Integer(PropInfo^.PropType^.Kind))]);
      end;
    end;
  end;
end;

end.

