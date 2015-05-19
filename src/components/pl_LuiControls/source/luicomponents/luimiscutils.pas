unit LuiMiscUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

function CallMethod(Instance: TObject; const MethodName: String): Boolean;

implementation

function CallMethod(Instance: TObject; const MethodName: String): Boolean;
var
  Method: procedure of object;
begin
  TMethod(Method).Data := Instance;
  TMethod(Method).Code := Instance.MethodAddress(MethodName);
  Result := Assigned(Method);
  if Result then
    Method;
end;


end.

