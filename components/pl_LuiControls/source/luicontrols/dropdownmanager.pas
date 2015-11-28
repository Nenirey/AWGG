unit DropDownManager;

{$mode objfpc}{$H+}

interface

uses
  Controls, LMessages, Forms, Classes, SysUtils;

type

  { TCustomDropDownManager }

  //todo:
  // make use of window shadow

  TDropDownOption = (ddoUsePopupForm);

  TDropDownOptions = set of TDropDownOption;

  TDropDownCreateControl = procedure(Sender: TObject; Control: TControl) of object;

  TCustomDropDownManager = class(TComponent)
  private
    FControl: TWinControl;
    FControlClass: TWinControlClass;
    FMasterControl: TControl;
    FOnCreateControl: TDropDownCreateControl;
    FOnHide: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FOptions: TDropDownOptions;
    FPopupForm: TForm;
    function ControlGrabsFocus(AControl: TControl): Boolean;
    procedure ControlNeeded;
    procedure FocusChangeHandler(Sender: TObject; LastControl: TControl);
    function GetVisible: Boolean;
    procedure RemoveHandlers;
    procedure SetState(DoEvents: Boolean);
    procedure SetVisible(const Value: Boolean);
    procedure UserInputHandler(Sender: TObject; Msg: Cardinal);
  protected
    procedure DoHide; virtual;
    procedure DoShow; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property Control: TWinControl read FControl write FControl;
    property MasterControl: TControl read FMasterControl write FMasterControl;
    property Options: TDropDownOptions read FOptions write FOptions;
    property OnCreateControl: TDropDownCreateControl read FOnCreateControl write FOnCreateControl;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure UpdateState;
    property ControlClass: TWinControlClass read FControlClass write FControlClass;
    property Visible: Boolean read GetVisible write SetVisible;
  end;

  TDropDownManager = class (TCustomDropDownManager)
  published
    property Control;
    property MasterControl;
    property Options;
    property OnCreateControl;
    property OnHide;
    property OnShow;
  end;

implementation

{ TCustomDropDownManager }

function TCustomDropDownManager.ControlGrabsFocus(AControl: TControl): Boolean;
begin
  Result := (AControl <> nil) and (AControl <> FControl) and (AControl <> FMasterControl) and
    not FControl.IsParentOf(AControl) and ((ddoUsePopupForm in FOptions) or (GetParentForm(FControl) = GetParentForm(AControl)));
end;

procedure TCustomDropDownManager.ControlNeeded;
begin
  if FControl = nil then
  begin
    if FControlClass <> nil then
    begin
      FControl := FControlClass.Create(Self);
      if ddoUsePopupForm in FOptions then
      begin
        if FPopupForm = nil then
        begin
          FPopupForm := TForm.Create(nil);
          FPopupForm.BorderStyle := bsNone;
          FPopupForm.PopupMode := pmAuto;
        end;
        FPopupForm.SetBounds(FPopupForm.Left, FPopupForm.Top, FControl.Width, FControl.Height);
        FControl.Parent := FPopupForm;
      end
      else
      begin
        FControl.Visible := False;
        if FMasterControl <> nil then
        begin
          FControl.Parent := FMasterControl.Parent;
          FControl.AnchorParallel(akLeft, 0, FMasterControl);
          FControl.AnchorToNeighbour(akTop, 2, FMasterControl);
        end;
      end;
      if Assigned(FOnCreateControl) then
        FOnCreateControl(Self, FControl);
    end;
    if FControl = nil then
      raise Exception.Create('TDropDownWindow: Control not defined');
  end;
end;

procedure TCustomDropDownManager.FocusChangeHandler(Sender: TObject; LastControl: TControl);
begin
  if ControlGrabsFocus(Application.MouseControl) then
    Visible := False;
end;

function TCustomDropDownManager.GetVisible: Boolean;
begin
  if FControl <> nil then
    Result := FControl.Visible
  else
    Result := False;
end;

procedure TCustomDropDownManager.RemoveHandlers;
begin
  Application.RemoveOnUserInputHandler(@UserInputHandler);
  Screen.RemoveHandlerActiveControlChanged(@FocusChangeHandler);
end;

procedure TCustomDropDownManager.SetState(DoEvents: Boolean);
var
  IsControlVisible: Boolean;
begin
  if (ddoUsePopupForm in FOptions) and (FPopupForm <> nil) then
    IsControlVisible := FPopupForm.Visible
  else
    IsControlVisible := FControl.Visible;
  if IsControlVisible then
  begin
    if FControl.CanFocus then
      FControl.SetFocus;
    if DoEvents then
      DoShow;
    Application.AddOnUserInputHandler(@UserInputHandler);
    Screen.AddHandlerActiveControlChanged(@FocusChangeHandler);
  end
  else
  begin
    RemoveHandlers;
    if DoEvents then
      DoHide;
  end;
end;

procedure TCustomDropDownManager.SetVisible(const Value: Boolean);
var
  P: TPoint;
begin
  if (FControl = nil) and not Value then
    Exit;
  ControlNeeded;
  if (ddoUsePopupForm in FOptions) then
  begin
    if FPopupForm.Visible = Value then
      Exit;
    if Value then
    begin
      if FMasterControl <> nil then
      begin
        P := Point(0, FMasterControl.Height);
        P := FMasterControl.ClientToScreen(P);
        FPopupForm.SetBounds(P.x, p.y + 2, FPopupForm.Width, FPopupForm.Height);
      end;
      FPopupForm.Show;
    end
    else
      FPopupForm.Hide;
  end
  else
  begin
    if FControl.Visible = Value then
      Exit;
    FControl.Visible := Value;
  end;
  SetState(True);
end;

procedure TCustomDropDownManager.UserInputHandler(Sender: TObject; Msg: Cardinal);
begin
  case Msg of
    LM_LBUTTONDOWN, LM_LBUTTONDBLCLK, LM_RBUTTONDOWN, LM_RBUTTONDBLCLK,
    LM_MBUTTONDOWN, LM_MBUTTONDBLCLK, LM_XBUTTONDOWN, LM_XBUTTONDBLCLK:
    begin
      if ControlGrabsFocus(Application.MouseControl) then
        Visible := False;
    end;
  end;
end;

procedure TCustomDropDownManager.DoHide;
begin
  if Assigned(FOnHide) then
    FOnHide(Self);
end;

procedure TCustomDropDownManager.DoShow;
begin
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

procedure TCustomDropDownManager.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FControl then
      FControl := nil
    else if AComponent = FMasterControl then
      FMasterControl := nil;
  end;
end;

destructor TCustomDropDownManager.Destroy;
begin
  RemoveHandlers;
  FPopupForm.Free;
  inherited Destroy;
end;

procedure TCustomDropDownManager.Assign(Source: TPersistent);
begin
  if Source is TCustomDropDownManager then
  begin
    FControl := TCustomDropDownManager(Source).FControl;
    FControlClass := TCustomDropDownManager(Source).FControlClass;
    FMasterControl := TCustomDropDownManager(Source).FMasterControl;
    FOptions := TCustomDropDownManager(Source).FOptions;
    FOnCreateControl := TCustomDropDownManager(Source).FOnCreateControl;
    FOnHide := TCustomDropDownManager(Source).FOnHide;
    FOnShow := TCustomDropDownManager(Source).FOnShow;
  end
  else
    inherited Assign(Source);
end;

procedure TCustomDropDownManager.UpdateState;
begin
  if FControl <> nil then
    SetState(False);
end;

end.

