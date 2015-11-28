unit LuiLCLInterfaces;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, StdCtrls, Forms;

const
  FrameControllerIntfId = 'lui_lclcontroller';

type
  {$INTERFACES CORBA}

  IFrameController = interface
    [FrameControllerIntfId]
    procedure FrameMessage(Sender: TCustomFrame; const MessageId: String; Data: Variant);
  end;

implementation

end.

