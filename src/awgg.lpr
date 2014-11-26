program awgg;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads, cmem,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, Unit2, Unit3, Unit4, Unit5, Unit6,
  Unit7, Unit8;

{$R *.res}

begin
  Application.Title:='AWGG';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TrsForm, rsForm);
  Application.CreateForm(TdlgForm, dlgForm);
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.

