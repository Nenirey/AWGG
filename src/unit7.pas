{
   AWGG
   -------------------------------------------------------------------------
   Licence  : GNU GPL v 2.0
   Copyright (C) 2014 Reinier Romero Mir (nenirey@gmail.com)

   Confirm Dialog window

}
unit Unit7;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TdlgForm }

  TdlgForm = class(TForm)
    dlgbtnyes: TButton;
    dlgbtnno: TButton;
    dlgtext: TLabel;
    procedure dlgbtnnoClick(Sender: TObject);
    procedure dlgbtnyesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  dlgForm: TdlgForm;
  dlgcuestion:boolean;
implementation

{$R *.lfm}

{ TdlgForm }

procedure TdlgForm.dlgbtnyesClick(Sender: TObject);
begin
  dlgcuestion:=true;
  dlgForm.Close;
end;

procedure TdlgForm.FormCreate(Sender: TObject);
begin
  dlgcuestion:=false;
end;

procedure TdlgForm.dlgbtnnoClick(Sender: TObject);
begin
  dlgcuestion:=false;
  dlgForm.Close;
end;

end.

