unit WizardControls;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, ExtCtrls, Buttons, fgl, VirtualPages;

const
  WizardPageIntfID = 'lui_wizardpage';
  WizardManagerIntfID = 'lui_wizardmanager';

type
  TWizardButton = (wbPrevious, wbNext, wbFinish, wbCancel, wbHelp);

  TWizardAction = (waPrevious, waNext, waFinish, waCancel, waHelp, waCustom);

  TWizardDirection = (wdNext, wdPrevious);

  TWizardPage = class;

  TWizardButtons = set of TWizardButton;

  TWizardPageInfo = record
    Caption: String;
    Description: String;
    VisibleButtons: TWizardButtons;
    EnabledButtons: TWizardButtons;
    NextOffset: Cardinal;
    PreviousOffset: Cardinal;
  end;

  {$INTERFACES CORBA}

  { IWizardManager }

  IWizardManager = interface
    [WizardManagerIntfID]
    function GetPageCount: Integer;
    function MoveBy(Offset: Integer): Boolean;
    procedure PageStateChanged;
  end;

  { IWizardPage }

  IWizardPage = interface
    [WizardPageIntfID]
    procedure GetPageInfo(var PageInfo: TWizardPageInfo);
    //function HandleActionRequest(AnAction: TWizardAction; var Data: PtrInt): Boolean;
  end;

  IWizardObserver = interface
    procedure PageChanged(Page: TWizardPage);
    procedure PageStateChanged(Page: TWizardPage);
  end;

const
  WizardDefaultButtons = [wbPrevious, wbNext, wbCancel];
  AllWizardButtons = [wbPrevious, wbNext, wbFinish, wbCancel, wbHelp];

type

  TWizardManager = class;

  TWizardButtonPanel = class;

  { TWizardPage }

  TWizardPage = class(TVirtualPage)
  private
    FDescription: String;
    FEnabledButtons: TWizardButtons;
    FNextOffset: Cardinal;
    FPageIntf: IWizardPage;
    FPreviousOffset: Cardinal;
    FVisibleButtons: TWizardButtons;
    procedure UpdatePageInfo;
  protected
    procedure ControlChanged; override;
  public
    constructor Create(ACollection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Description: String read FDescription write FDescription;
    property EnabledButtons: TWizardButtons read FEnabledButtons write FEnabledButtons default WizardDefaultButtons;
    property NextOffset: Cardinal read FNextOffset write FNextOffset default 1;
    property PreviousOffset: Cardinal read FPreviousOffset write FPreviousOffset default 1;
    property VisibleButtons: TWizardButtons read FVisibleButtons write FVisibleButtons default WizardDefaultButtons;
  end;

  { TWizardPages }

  TWizardPages = class(TVirtualPages)
  private
    FOwner: TWizardManager;
    function GetItem(Index: Integer): TWizardPage;
  protected
    procedure DoPageHide(Page: TVirtualPage); override;
    procedure DoPageLoad(Page: TVirtualPage); override;
    procedure DoPageShow(Page: TVirtualPage); override;
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TWizardManager);
    property Items[Index: Integer]: TWizardPage read GetItem; default;
  end;

  TWizardPageEvent = procedure(Sender: TObject; Page: TWizardPage) of object;

  TWizardObserverList = specialize TFPGList <IWizardObserver>;

  { TWizardManager }

  TWizardManager = class(TComponent, IWizardManager)
  private
    FObserverList: TWizardObserverList;
    FOnPageHide: TWizardPageEvent;
    FOnPageLoad: TWizardPageEvent;
    FOnPageShow: TWizardPageEvent;
    FOnPageStateChange: TWizardPageEvent;
    FPageIndex: Integer;
    FPages: TWizardPages;
    function GetDisplayOptions: TControlDisplayOptions;
    procedure SetDisplayOptions(AValue: TControlDisplayOptions);
    procedure SetPageIndex(AValue: Integer);
    procedure SetPages(const Value: TWizardPages);
  protected
    procedure DoPageHide(Page: TWizardPage);
    procedure DoPageLoad(Page: TWizardPage);
    procedure DoPageShow(Page: TWizardPage);
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //IWizardManager
    function GetPageCount: Integer;
    function MoveBy(Offset: Integer): Boolean;
    procedure PageStateChanged;
    procedure DoAction(Action: TWizardAction);
    function PageByName(const PageName: String): TWizardPage;
    procedure RegisterObserver(Value: IWizardObserver);
  published
    property DisplayOptions: TControlDisplayOptions read GetDisplayOptions write SetDisplayOptions;
    property OnPageHide: TWizardPageEvent read FOnPageHide write FOnPageHide;
    property OnPageLoad: TWizardPageEvent read FOnPageLoad write FOnPageLoad;
    property OnPageShow: TWizardPageEvent read FOnPageShow write FOnPageShow;
    property OnPageStateChange: TWizardPageEvent read FOnPageStateChange write FOnPageStateChange;
    property PageIndex: Integer read FPageIndex write SetPageIndex default -1;
    property Pages: TWizardPages read FPages write SetPages;
  end;

  { TWizardPanelBitBtn }

  TWizardPanelBitBtn = class(TCustomBitBtn)
  private
    FButtonType: TWizardButton;
  public
    constructor Create(AOwner: TComponent); override;
    property ButtonType: TWizardButton read FButtonType;
  published
    property Caption stored True;
    property Left stored False;
    property Top stored False;
    property Width;
    property Height;
    property Enabled;
    property Font;
    property Glyph;
    property GlyphShowMode;
    property Kind;
    property ModalResult;
    property Name stored True;
    property ShowHint;
  end;

  { TWizardButtonPanel }

  TWizardButtonPanelButtonClick = procedure(Sender: TObject; ButtonType: TWizardButton) of object;

  TWizardButtonPanel = class(TCustomPanel, IWizardObserver)
  private
    FBevel: TBevel;
    FCancelButton: TWizardPanelBitBtn;
    FManager: TWizardManager;
    FFinishButton: TWizardPanelBitBtn;
    FNextButton: TWizardPanelBitBtn;
    FOnButtonClick: TWizardButtonPanelButtonClick;
    FPreviousButton: TWizardPanelBitBtn;
    FShowBevel: Boolean;
    procedure ButtonClick(Sender: TObject);
    function CreateButton(ButtonType: TWizardButton): TWizardPanelBitBtn;
    procedure SetManager(const Value: TWizardManager);
    procedure SetShowBevel(const Value: Boolean);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateButtons(Page: TWizardPage);
  protected
    procedure DoOnResize; override;
  public
    procedure PageChanged(Page: TWizardPage);
    procedure PageStateChanged(Page: TWizardPage);
  published
    property Manager: TWizardManager read FManager write SetManager;
    property CancelButton: TWizardPanelBitBtn read FCancelButton;
    property FinishButton: TWizardPanelBitBtn read FFinishButton;
    property NextButton: TWizardPanelBitBtn read FNextButton;
    property PreviousButton: TWizardPanelBitBtn read FPreviousButton;
    property ShowBevel: Boolean read FShowBevel write SetShowBevel default false;
    //events
    property OnButtonClick: TWizardButtonPanelButtonClick read FOnButtonClick write FOnButtonClick;
    //
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BevelInner;
    property BevelOuter default bvNone;
    property BevelWidth;
    property BidiMode;
    property BorderWidth;
    property BorderStyle;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FullRepaint;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
    property OnClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnGetDockCaption;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation

uses
  LuiRTTIUtils;

const
  WizardButtonNames: array[TWizardButton] of String = (
    'Previous',
    'Next',
    'Finish',
    'Cancel',
    'Help'
  );

{ TWizardManager }

function TWizardManager.GetDisplayOptions: TControlDisplayOptions;
begin
  Result := FPages.DisplayOptions;
end;

procedure TWizardManager.SetDisplayOptions(AValue: TControlDisplayOptions);
begin
  FPages.DisplayOptions := AValue;
end;

procedure TWizardManager.SetPageIndex(AValue: Integer);
var
  OldPageIndex: Integer;
begin
  if (FPageIndex = AValue) or (AValue >= FPages.Count)
    or (csLoading in ComponentState) then
    Exit;
  OldPageIndex := FPageIndex;
  FPageIndex := AValue;
  FPages.UpdateActivePage(OldPageIndex, AValue);
end;

procedure TWizardManager.SetPages(const Value: TWizardPages);
begin
  FPages.Assign(Value);
end;

procedure TWizardManager.DoPageHide(Page: TWizardPage);
begin
  if Assigned(FOnPageHide) then
    FOnPageHide(Self, Page);
end;

procedure TWizardManager.DoPageLoad(Page: TWizardPage);
begin
  if Assigned(FOnPageLoad) then
    FOnPageLoad(Self, Page);
end;

procedure TWizardManager.DoPageShow(Page: TWizardPage);
var
  i: Integer;
begin
  if Assigned(FOnPageShow) then
    FOnPageShow(Self, Page);
  Page.UpdatePageInfo;
  for i := 0 to FObserverList.Count - 1 do
    FObserverList[i].PageChanged(Page);
end;

procedure TWizardManager.Loaded;
begin
  inherited Loaded;
  if (DisplayOptions.Parent = nil) and (Owner is TWinControl) then
    DisplayOptions.Parent := TWinControl(Owner);
  if FPageIndex > -1 then
    FPages.UpdateActivePage(-1, FPageIndex);
end;

constructor TWizardManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPages := TWizardPages.Create(Self);
  FPageIndex := -1;
  FObserverList := TWizardObserverList.Create;
end;

destructor TWizardManager.Destroy;
begin
  FObserverList.Destroy;
  FPages.Destroy;
  inherited Destroy;
end;

function TWizardManager.GetPageCount: Integer;
begin
  Result := FPages.Count;
end;

function TWizardManager.MoveBy(Offset: Integer): Boolean;
var
  NewIndex: Integer;
begin
  NewIndex := FPageIndex + Offset;
  PageIndex := NewIndex;
  Result := NewIndex = FPageIndex;
end;

procedure TWizardManager.PageStateChanged;
var
  ActivePage: TWizardPage;
  i: Integer;
begin
  if FPageIndex <> -1 then
  begin
    ActivePage := FPages[FPageIndex];
    ActivePage.UpdatePageInfo;
    for i := 0 to FObserverList.Count - 1 do
      FObserverList[i].PageStateChanged(ActivePage);
    if Assigned(FOnPageStateChange) then
      FOnPageStateChange(Self, ActivePage);
  end;
end;

procedure TWizardManager.DoAction(Action: TWizardAction);
var
  ActivePage: TWizardPage;
  Offset: Integer;
begin
  if FPageIndex <> -1 then
  begin
    ActivePage := FPages[FPageIndex];
    case Action of
      waNext:
        begin
          Offset := ActivePage.NextOffset;
          if MoveBy(Offset) then
          begin
            //set the PreviousOffset of the new activepage
            ActivePage := FPages[FPageIndex];
            ActivePage.PreviousOffset := Offset;
          end;
        end;
      waPrevious: MoveBy(-ActivePage.PreviousOffset);
    end;
  end;
end;

function TWizardManager.PageByName(const PageName: String): TWizardPage;
begin
  Result := TWizardPage(FPages.PageByName(PageName));
end;

procedure TWizardManager.RegisterObserver(Value: IWizardObserver);
begin
  if Value = nil then
    Exit;
  FObserverList.Add(Value);
end;

{ TWizardPage }

procedure TWizardPage.UpdatePageInfo;
var
  PageInfo: TWizardPageInfo;
begin
  if FPageIntf = nil then
    Exit;
  PageInfo.Caption := Caption;
  PageInfo.Description := Description;
  PageInfo.EnabledButtons := EnabledButtons;
  PageInfo.VisibleButtons := VisibleButtons;
  PageInfo.NextOffset := NextOffset;
  PageInfo.PreviousOffset := PreviousOffset;

  FPageIntf.GetPageInfo(PageInfo);

  Caption := PageInfo.Caption;
  Description := PageInfo.Description;
  EnabledButtons := PageInfo.EnabledButtons;
  VisibleButtons := PageInfo.VisibleButtons;
  PreviousOffset := PageInfo.PreviousOffset;
  NextOffset := PageInfo.NextOffset;
end;

procedure TWizardPage.ControlChanged;
begin
  inherited ControlChanged;
  if Control <> nil then
  begin
    Control.GetInterface(WizardPageIntfID, FPageIntf);
    SetObjectProperties(Control, ['WizardManager', Collection.Owner as IWizardManager]);
  end
  else
    FPageIntf := nil;
end;

constructor TWizardPage.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FVisibleButtons := WizardDefaultButtons;
  FEnabledButtons := WizardDefaultButtons;
  FNextOffset := 1;
  FPreviousOffset := 1;
end;

procedure TWizardPage.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TWizardPage then
  begin
    FDescription := TWizardPage(Source).FDescription;
    FEnabledButtons := TWizardPage(Source).FEnabledButtons;
    FNextOffset := TWizardPage(Source).FNextOffset;
    FPreviousOffset := TWizardPage(Source).FPreviousOffset;
    FVisibleButtons := TWizardPage(Source).FVisibleButtons;
    FPageIntf := TWizardPage(Source).FPageIntf;
  end;
end;

{ TWizardPages }

function TWizardPages.GetItem(Index: Integer): TWizardPage;
begin
  Result := TWizardPage(inherited GetItem(Index));
end;

procedure TWizardPages.DoPageHide(Page: TVirtualPage);
begin
  FOwner.DoPageHide(TWizardPage(Page));
end;

procedure TWizardPages.DoPageLoad(Page: TVirtualPage);
begin
  FOwner.DoPageLoad(TWizardPage(Page));
end;

procedure TWizardPages.DoPageShow(Page: TVirtualPage);
begin
  FOwner.DoPageShow(TWizardPage(Page));
end;

function TWizardPages.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

constructor TWizardPages.Create(AOwner: TWizardManager);
begin
  inherited Create(TWizardPage);
  FOwner := AOwner;
end;

{ TWizardButtonPanel }

procedure TWizardButtonPanel.ButtonClick(Sender: TObject);
begin
  if FManager = nil then
    Exit;
  with Sender as TWizardPanelBitBtn do
  begin
    case ButtonType of
      wbNext: FManager.DoAction(waNext);
      wbPrevious: FManager.DoAction(waPrevious);
    end;
    if Assigned(FOnButtonClick) then
      FOnButtonClick(Self, ButtonType);
  end;
end;

function TWizardButtonPanel.CreateButton(ButtonType: TWizardButton): TWizardPanelBitBtn;
begin
  Result := TWizardPanelBitBtn.Create(Self);
  Result.Parent := Self;
  Result.Anchors := [akRight, akTop];
  Result.FButtonType := ButtonType;
  Result.Caption := WizardButtonNames[ButtonType];
  Result.Name := WizardButtonNames[ButtonType] + 'Button';
  Result.OnClick := @ButtonClick;
end;

procedure TWizardButtonPanel.SetManager(const Value: TWizardManager);
begin
  if Value = FManager then
    Exit;
  FManager := Value;
  if Value <> nil then
    Value.RegisterObserver(Self as IWizardObserver);
end;

procedure TWizardButtonPanel.SetShowBevel(const Value: Boolean);
begin
  if FShowBevel = Value then exit;
  FShowBevel := Value;
  if Value then
  begin
    if FBevel = nil then
      FBevel := TBevel.Create(Self);
    FBevel.Parent := Self;
    FBevel.Height := 2;
    FBevel.Shape := bsTopLine;
    FBevel.Align := alTop;
    FBevel.Visible := True;
  end
  else
  begin
    if FBevel <> nil then
      FBevel.Visible := False;
  end;
end;

constructor TWizardButtonPanel.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  BevelOuter := bvNone;
  //create the buttons
  FCancelButton := CreateButton(wbCancel);
  FCancelButton.Kind := bkCancel;
  FCancelButton.AnchorParallel(akRight, 4, Self);
  FCancelButton.AnchorVerticalCenterTo(Self);

  FFinishButton := CreateButton(wbFinish);
  FFinishButton.Kind := bkOK;
  FFinishButton.AnchorVerticalCenterTo(Self);

  FNextButton := CreateButton(wbNext);
  FNextButton.AnchorVerticalCenterTo(Self);

  FPreviousButton := CreateButton(wbPrevious);
  FPreviousButton.AnchorVerticalCenterTo(Self);
end;

destructor TWizardButtonPanel.Destroy;
begin
  FNextButton.Destroy;
  FPreviousButton.Destroy;
  FCancelButton.Destroy;
  FFinishButton.Destroy;
  inherited Destroy;
end;

procedure TWizardButtonPanel.UpdateButtons(Page: TWizardPage);
var
  VisibleButtons, EnabledButtons: TWizardButtons;
begin
  VisibleButtons := Page.VisibleButtons;
  EnabledButtons := Page.EnabledButtons;

  FCancelButton.Visible := wbCancel in VisibleButtons;
  FFinishButton.Visible := wbFinish in VisibleButtons;
  FNextButton.Visible := wbNext in VisibleButtons;
  FPreviousButton.Visible := wbPrevious in VisibleButtons;

  FCancelButton.Enabled := wbCancel in EnabledButtons;
  FFinishButton.Enabled := wbFinish in EnabledButtons;
  FNextButton.Enabled := wbNext in EnabledButtons;
  FPreviousButton.Enabled := wbPrevious in EnabledButtons;
end;

procedure TWizardButtonPanel.DoOnResize;
begin
  inherited DoOnResize;
  FFinishButton.Left := FCancelButton.Left - FFinishButton.Width - 8;
  FNextButton.Left := FFinishButton.Left - FNextButton.Width - 8;
  FPreviousButton.Left := FNextButton.Left - FPreviousButton.Width - 2;
end;

procedure TWizardButtonPanel.PageChanged(Page: TWizardPage);
begin
  UpdateButtons(Page);
end;

procedure TWizardButtonPanel.PageStateChanged(Page: TWizardPage);
begin
  UpdateButtons(Page);
end;

{ TWizardPanelBitBtn }

constructor TWizardPanelBitBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetSubComponent(True);
end;

end.

