unit ValidateEdit;

{$mode objfpc}{$H+}
{.Define DEBUG_DATEEDIT}

interface

uses
  Classes, SysUtils, DbCtrls, LMessages, Graphics, Dialogs
  {$ifdef DEBUG_DATEEDIT}, sharedlogger {$endif};

type

  //todo: implement RecoverMode
  //TRecoverMode = (rmNone, rmClear, rmRestore);

  TValidateDataEvent = procedure(Sender: TObject; var NewData: String; var IsValid: Boolean) of object;

  TValueChangeEvent = procedure(Sender: TObject; StateChanged: Boolean) of object;

  TDBValidateEditOption = (voNullValueAsError);

  TDBValidateEditOptions = set of TDBValidateEditOption;

  { TCustomDBValidateEdit }

  TCustomDBValidateEdit = class(TDBEdit)
  private
    FDataLink: TFieldDataLink;
    FInvalidValueColor: TColor;
    FInvalidValueMessage: String;
    FOldDataChange: TNotifyEvent;
    FOnValueChange: TValueChangeEvent;
    FOptions: TDBValidateEditOptions;
    //FRecoverMode: TRecoverMode;
    FValueIsValid: Boolean;
    procedure DataChange(Sender: TObject);
    procedure UpdateControlState(ValueState: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure UpdateDisplayText(const NewText: String);
  protected
    function DoValidateData(var NewData: String): Boolean; virtual; abstract;
    //events
    property OnValueChange: TValueChangeEvent read FOnValueChange write FOnValueChange;
  public
    constructor Create(AOwner: TComponent); override;
    property ValueIsValid: Boolean read FValueIsValid;
  published
    property InvalidValueColor: TColor read FInvalidValueColor write FInvalidValueColor default clWindow;
    property InvalidValueMessage: String read FInvalidValueMessage write FInvalidValueMessage;
    property Options: TDBValidateEditOptions read FOptions write FOptions default [];
    //property RecoverMode: TRecoverMode read FRecoverMode write FRecoverMode default rmNone;
  end;

  { TDBValidateEdit }

  TDBValidateEdit = class(TCustomDBValidateEdit)
  private
    FOnValidateData: TValidateDataEvent;
  protected
    function DoValidateData(var NewData: String): Boolean; override;
  published
    property OnValidateData: TValidateDataEvent read FOnValidateData write FOnValidateData;
    property OnValueChange;
  end;

  { TDBDateMaskEdit }

  TDBDateMaskEdit = class(TCustomDBValidateEdit)
  private
    procedure BuildEditMask;
  protected
    procedure CreateWnd; override;
    function DoValidateData(var NewData: String): Boolean; override;
  published
    property OnValueChange;
  end;

implementation

uses
  strutils;

{ TCustomDBValidateEdit }

procedure TCustomDBValidateEdit.DataChange(Sender: TObject);
begin
  UpdateControlState((FDataLink.Field = nil) or (FDataLink.Field.Value <> Null) or
    not (voNullValueAsError in FOptions));
  FOldDataChange(Sender);
end;

procedure TCustomDBValidateEdit.UpdateControlState(ValueState: Boolean);
begin
  FValueIsValid := ValueState;
  if FValueIsValid then
    Color := clWindow
  else
    Color := FInvalidValueColor;
end;

procedure TCustomDBValidateEdit.UpdateData(Sender: TObject);
var
  S: String;
  OldValueIsValid: Boolean;
begin
  S := Text;
  OldValueIsValid := FValueIsValid;
  FValueIsValid := DoValidateData(S);
  if Assigned(FOnValueChange) then
    FOnValueChange(Self, FValueIsValid <> OldValueIsValid);
  if FValueIsValid then
  begin
    FDataLink.Field.AsString := S;
    Color := clWindow;
  end
  else
  begin
    {$ifdef DEBUG_VALIDATEEDIT}
    Logger.Send('Before ShowMessage');
    {$endif}
    if FInvalidValueMessage <> '' then
      ShowMessage(AnsiReplaceText(FInvalidValueMessage, '$(NewValue)', S));
    {$ifdef DEBUG_VALIDATEEDIT}
    Logger.Send('After ShowMessage');
    {$endif}
    Color := FInvalidValueColor;
    //todo: implement RecoverMode
    {
    case FRecoverMode of
      rmNone:
        begin
          Color := FInvalidValueColor;
          //UpdateDisplayText();
        end;
      rmClear:
        begin
          UpdateDisplayText('');
          UpdateControlState(not (voNullValueAsError in FOptions));
        end;
      rmRestore: FDataLink.Reset;
    end;
    }
  end;
end;

procedure TCustomDBValidateEdit.UpdateDisplayText(const NewText: String);
begin
  //avoid calling the UpdateData event
  FDataLink.OnUpdateData := nil;
  try
    Text := NewText;
  finally
    FDataLink.OnUpdateData := @UpdateData;
  end;
end;

procedure TDBDateMaskEdit.BuildEditMask;
var
  S: String;
  i, FieldCount: Integer;
begin
  if csDesigning in ComponentState then
    Exit;
  S := '';
  FieldCount := 0;
  for i := 1 to Length(ShortDateFormat) do
  begin
    if ShortDateFormat[i] in ['M', 'm', 'D', 'd', 'Y', 'y'] then
    begin
      S := S + '9';
      Inc(FieldCount);
    end
    else
    begin
      //add an extra character to avoid date fields with only one character
      if FieldCount = 1 then
        S := S + '9';
      FieldCount := 0;
      S := S + DateSeparator;
    end;
  end;
  //the last field has only one character
  if FieldCount = 1 then
    S := S + '9';
  EditMask := '!' + S + ';1;_';
end;


procedure TDBDateMaskEdit.CreateWnd;
var
  OldText: String;
begin
  OldText := Text;
  //post pone mask build the maximum
  BuildEditMask;
  //Setting EditMask clears the text. Update again here and reset the mask
  DisableMask(OldText);
  inherited CreateWnd;
end;

function TDBDateMaskEdit.DoValidateData(var NewData: String): Boolean;
var
  D: TDateTime;
begin
  Result := TryStrToDate(NewData, D);
  //todo: remove spaces here to avoid a fpc bug ??
end;

constructor TCustomDBValidateEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink(Perform(CM_GETDATALINK, 0, 0));
  FOldDataChange := FDataLink.OnDataChange;
  FDataLink.OnDataChange := @DataChange;
  FDataLink.OnUpdateData := @UpdateData;
  //FRecoverMode := rmNone;
  FInvalidValueColor := clWindow;
  CustomEditMask := True;
end;

{ TDBValidateEdit }

function TDBValidateEdit.DoValidateData(var NewData: String): Boolean;
begin
  Result := True;
  if Assigned(FOnValidateData) then
    FOnValidateData(Self, NewData, Result);
end;

end.

