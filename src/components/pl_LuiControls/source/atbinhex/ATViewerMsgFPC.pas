unit ATViewerMsgFPC;

{$mode objfpc}{$H+}

{
Original work by Alexey Torgashin
LCL port: Luiz Americo Pereira Camara
}


interface

uses
  Classes, SysUtils, LCLType, Dialogs;

var
  ATViewerMessagesEnabled: boolean = true;


  MsgViewerCaption: string = 'Viewer';
  MsgViewerErrCannotFindFile: string = 'File not found: %s';
  MsgViewerErrCannotOpenFile: string = 'Cannot open file: %s';
  MsgViewerErrCannotLoadFile: string = 'Cannot load file: %s';
  MsgViewerErrCannotReadFile: string = 'Cannot read file: %s';
  MsgViewerErrCannotReadStream: string = 'Cannot read stream';
  MsgViewerErrCannotReadPos: string = 'Read error at offset %s';
  MsgViewerErrImage: string = 'Unknown image format';
  MsgViewerErrMedia: string = 'Unknown multimedia format';
  MsgViewerErrMediaWMP: string = 'Cannot initialize Windows Media Player %s ActiveX';
  MsgViewerErrCannotCopyData: string = 'Cannot copy data to Clipboard';
  MsgViewerWlxException: string = 'Exception in plugin %s in function %s';
  MsgViewerWlxCannotUnload: string = 'Cannot unload plugin %s';
  MsgViewerWlxParentNotSpecified: string = 'Cannot load plugins: parent form not specified';


function MsgBox(const Msg, Title: WideString; Flags: integer; h: THandle = INVALID_HANDLE_VALUE): integer;
procedure MsgInfo(const Msg: WideString; h: THandle = INVALID_HANDLE_VALUE);
procedure MsgError(const Msg: WideString; h: THandle = INVALID_HANDLE_VALUE);


implementation


function MsgBox(const Msg, Title: WideString; Flags: integer; h: THandle = INVALID_HANDLE_VALUE): integer;
begin
  if not ATViewerMessagesEnabled then
    begin Result:= IDCANCEL; Exit end;

  //if h=INVALID_HANDLE_VALUE then
  //  h:= Application.MainForm.Handle;
  ShowMessage(String(Title));
end;

procedure MsgInfo(const Msg: WideString; h: THandle = INVALID_HANDLE_VALUE);
begin
  MsgBox(Msg, MsgViewerCaption, MB_OK or MB_ICONINFORMATION, h);
end;

procedure MsgError(const Msg: WideString; h: THandle = INVALID_HANDLE_VALUE);
begin
  MsgBox(Msg, MsgViewerCaption, MB_OK or MB_ICONERROR, h);
end;

end.

