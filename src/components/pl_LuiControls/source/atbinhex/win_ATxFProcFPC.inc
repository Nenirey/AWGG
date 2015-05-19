function FGetFileSize(Handle: THandle): Int64;
var
  Size: Int64;
  SizeRec: TInt64Rec absolute Size;
begin
  SizeRec.Lo:= GetFileSize(Handle, @SizeRec.Hi);
  if (SizeRec.Lo=$FFFFFFFF) and (GetLastError<>NO_ERROR)
    then Result:= -1
    else Result:= Size;
end;

