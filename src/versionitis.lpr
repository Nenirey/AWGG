program versionitis;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils
  { you can add units after this };
var tmpstr, tmplb, newlb, contenido, majorstr, minorstr, revisionstr, buildstr, versioninfo, versionback:string;
    proyecto:TStringList;
    p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14:integer;
{$R *.res}

begin
//writeln('Implementacion multiplataforma de versiones de aplicaciones GUI');
proyecto:=TStringList.Create;
proyecto.LoadFromFile('awgg.lpi');
contenido:=proyecto.Text;
p1:=Pos('<VersionInfo>',contenido)+13;
p2:=Pos('</VersionInfo>',contenido);
versioninfo:=Copy(contenido,p1,p2-p1);

p3:=Pos('<MajorVersionNr Value="',versioninfo);
if p3<>0 then
begin
p3+=23;
tmpstr:=Copy(versioninfo,p3,Length(versioninfo));
p4:=Pos('"/>',tmpstr);
majorstr:=Copy(tmpstr,0,p4-1);
end
else
majorstr:='0';

p5:=Pos('<MinorVersionNr Value="',versioninfo);
if p5<>0 then
begin
p5+=23;
tmpstr:=Copy(versioninfo,p5,Length(versioninfo));
p6:=Pos('"/>',tmpstr);
minorstr:=Copy(tmpstr,0,p6-1);
end
else
minorstr:='0';

p7:=Pos('<RevisionNr Value="',versioninfo);
if p7<>0 then
begin
p7+=19;
tmpstr:=Copy(versioninfo,p7,Length(versioninfo));
p8:=Pos('"/>',tmpstr);
revisionstr:=Copy(tmpstr,0,p8-1);
end
else
revisionstr:='0';

p9:=Pos('<BuildNr Value="',versioninfo);
if p9<>0 then
begin
p9+=16;
tmpstr:=Copy(versioninfo,p9,Length(versioninfo));
p10:=Pos('"/>',tmpstr);
buildstr:=Copy(tmpstr,0,p10-1);
end
else
buildstr:='0';

versioninfo:=majorstr+'.'+minorstr+'.'+revisionstr+'.'+buildstr;

//writeln('Version:',majorstr);
//writeln('MinorVersion:',minorstr);
//writeln('Revision:',revisionstr);
//writeln('Bulid:',buildstr);
//writeln('Complete version: ',versioninfo);
proyecto.Free;
proyecto:=TStringList.Create;
proyecto.Add('unit versionitis;');
proyecto.Add('interface');
proyecto.Add('var version:string='''+versioninfo+''';');
proyecto.Add('var fpcversion:string='''+{$I %FPCVERSION%}+''';');
proyecto.Add('var targetcpu:string='''+{$I %FPCTARGETCPU%}+''';');
proyecto.Add('var targetos:string='''+{$I %FPCTARGETOS%}+''';');
proyecto.Add('implementation');
proyecto.Add('begin');
proyecto.Add('end.');
proyecto.SaveToFile('versionitis.pas');
proyecto.Free;
if Paramstr(1) = '-verbose' then
begin
writeln('Actualizando desde version:',tmpstr,' hacia la version:',versioninfo);
sleep(3000);
end;
end.
