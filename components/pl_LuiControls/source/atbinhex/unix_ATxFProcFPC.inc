function FGetFileSize(Handle: THandle): Int64;
var
  St: Stat;
begin
  Result:= FpFStat(Handle,St);
  if Result <> -1 then
    Result:=St.st_size;
end;

