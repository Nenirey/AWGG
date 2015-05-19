unit VirtualPages;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LCLType, Controls, VarRecUtils;

type

  TVirtualPage = class;

  TVirtualPageEvent = procedure(Sender: TObject; Page: TVirtualPage) of object;

  { TControlDisplayOptions }

  TControlDisplayOptions = class(TPersistent)
  private
    FBorderSpacing: TControlBorderSpacing;
    FParent: TWinControl;
    FHeight: Integer;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FAlign: TAlign;
    procedure SetBorderSpacing(AValue: TControlBorderSpacing);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure SetControlBounds(Control: TControl);
  published
    property Align: TAlign read FAlign write FAlign default alClient;
    property BorderSpacing: TControlBorderSpacing read FBorderSpacing write SetBorderSpacing;
    property Height: Integer read FHeight write FHeight default -1;
    property Left: Integer read FLeft write FLeft default -1;
    property Parent: TWinControl read FParent write FParent;
    property Top: Integer read FTop write FTop default -1;
    property Width: Integer read FWidth write FWidth default -1;
  end;

  { TVirtualPage }

  TVirtualPage = class(TCollectionItem)
  private
    FCaption: String;
    FControl: TControl;
    FControlClass: TControlClass;
    FControlClassName: String;
    FName: String;
    FProperties: TConstArray;
    procedure SetControl(Value: TControl);
  protected
    procedure ControlChanged; virtual;
    function GetDisplayName: String; override;
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure SetProperties(const Elements: array of const);
    property ControlClass: TControlClass read FControlClass write FControlClass;
    property Properties: TConstArray read FProperties;
  published
    property Caption: String read FCaption write FCaption;
    property Control: TControl read FControl write SetControl;
    property ControlClassName: String read FControlClassName write FControlClassName;
    property Name: String read FName write FName;
  end;

  { TVirtualPages }

  TVirtualPages = class(TCollection)
  private
    FDisplayOptions: TControlDisplayOptions;
    function GetItems(Index: Integer): TVirtualPage;
    procedure SetDisplayOptions(AValue: TControlDisplayOptions);
  protected
    procedure DoPageHide(Page: TVirtualPage); virtual;
    procedure DoPageLoad(Page: TVirtualPage); virtual;
    procedure DoPageShow(Page: TVirtualPage); virtual;
    procedure UpdateActivePage(OldPageIndex, NewPageIndex: Integer);
  public
    constructor Create(AItemClass: TCollectionItemClass);
    destructor Destroy; override;
    procedure AssignTo(Dest: TPersistent); override;
    procedure Add(const Name, Caption: String; Control: TControl);
    procedure Add(const Name, Caption: String; ControlClass: TControlClass; const Properties: array of const);
    procedure Add(const Name, Caption, ControlClassName: String; const Properties: array of const);
    function FindPage(const PageName: String): TVirtualPage;
    function PageByName(const PageName: String): TVirtualPage;
    property DisplayOptions: TControlDisplayOptions read FDisplayOptions write SetDisplayOptions;
    property Items[Index: Integer]: TVirtualPage read GetItems; default;
  end;

  { TVirtualPageList }

  TVirtualPageList = class(TVirtualPages)
  private
    FOnPageHide: TVirtualPageEvent;
    FOnPageLoad: TVirtualPageEvent;
    FOnPageShow: TVirtualPageEvent;
    FPageIndex: Integer;
    procedure SetPageIndex(AValue: Integer);
  protected
    procedure DoPageHide(Page: TVirtualPage); override;
    procedure DoPageLoad(Page: TVirtualPage); override;
    procedure DoPageShow(Page: TVirtualPage); override;
  public
    constructor Create;
    property OnPageHide: TVirtualPageEvent read FOnPageHide write FOnPageHide;
    property OnPageLoad: TVirtualPageEvent read FOnPageLoad write FOnPageLoad;
    property OnPageShow: TVirtualPageEvent read FOnPageShow write FOnPageShow;
    property PageIndex: Integer read FPageIndex write SetPageIndex;
  end;

  { TVirtualPageManager }

  TVirtualPageManager = class(TComponent)
  private
    FOnPageHide: TVirtualPageEvent;
    FOnPageLoad: TVirtualPageEvent;
    FOnPageShow: TVirtualPageEvent;
    FPageIndex: Integer;
    FPages: TVirtualPages;
    function GetDisplayOptions: TControlDisplayOptions;
    procedure SetDisplayOptions(AValue: TControlDisplayOptions);
    procedure SetPageIndex(AValue: Integer);
    procedure SetPages(AValue: TVirtualPages);
  protected
    procedure DoPageHide(Page: TVirtualPage);
    procedure DoPageLoad(Page: TVirtualPage);
    procedure DoPageShow(Page: TVirtualPage);
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CallMethod(const AMethodName: String; AllPages: Boolean);
    function PageByName(const PageName: String): TVirtualPage;
  published
    property DisplayOptions: TControlDisplayOptions read GetDisplayOptions write SetDisplayOptions;
    property OnPageHide: TVirtualPageEvent read FOnPageHide write FOnPageHide;
    property OnPageLoad: TVirtualPageEvent read FOnPageLoad write FOnPageLoad;
    property OnPageShow: TVirtualPageEvent read FOnPageShow write FOnPageShow;
    property PageIndex: Integer read FPageIndex write SetPageIndex default -1;
    property Pages: TVirtualPages read FPages write SetPages;
  end;

implementation

uses
  RtlConsts, LuiRTTIUtils, LuiMiscUtils, Math, Forms;

type

  { TManagedPages }

  TManagedPages = class(TVirtualPages)
  private
    FManager: TVirtualPageManager;
  protected
    procedure DoPageHide(Page: TVirtualPage); override;
    procedure DoPageLoad(Page: TVirtualPage); override;
    procedure DoPageShow(Page: TVirtualPage); override;
    function GetOwner: TPersistent; override;
  public
    constructor Create(AManager: TVirtualPageManager);
  end;

{ TVirtualPageList }

procedure TVirtualPageList.SetPageIndex(AValue: Integer);
begin
  if FPageIndex = AValue then Exit;
  UpdateActivePage(FPageIndex, AValue);
  FPageIndex := AValue;
end;

procedure TVirtualPageList.DoPageHide(Page: TVirtualPage);
begin
  if Assigned(FOnPageHide) then
    FOnPageHide(Self, Page);
end;

procedure TVirtualPageList.DoPageLoad(Page: TVirtualPage);
begin
  if Assigned(FOnPageLoad) then
    FOnPageLoad(Self, Page);
end;

procedure TVirtualPageList.DoPageShow(Page: TVirtualPage);
begin
  if Assigned(FOnPageShow) then
    FOnPageShow(Self, Page);
end;

constructor TVirtualPageList.Create;
begin
  inherited Create(TVirtualPage);
  FPageIndex := -1;
end;

{ TManagedPages }

procedure TManagedPages.DoPageHide(Page: TVirtualPage);
begin
  FManager.DoPageHide(Page);
end;

procedure TManagedPages.DoPageLoad(Page: TVirtualPage);
begin
  FManager.DoPageLoad(Page);
end;

procedure TManagedPages.DoPageShow(Page: TVirtualPage);
begin
  FManager.DoPageShow(Page);
end;

function TManagedPages.GetOwner: TPersistent;
begin
  Result := FManager;
end;

constructor TManagedPages.Create(AManager: TVirtualPageManager);
begin
  inherited Create(TVirtualPage);
  FManager := AManager;
end;

{ TVirtualPageManager }

procedure TVirtualPageManager.SetPages(AValue: TVirtualPages);
begin
  FPages.Assign(AValue);
end;

procedure TVirtualPageManager.DoPageHide(Page: TVirtualPage);
begin
  if Assigned(FOnPageHide) then
    FOnPageHide(Self, Page);
end;

procedure TVirtualPageManager.DoPageLoad(Page: TVirtualPage);
begin
  if Assigned(FOnPageLoad) then
    FOnPageLoad(Self, Page);
end;

procedure TVirtualPageManager.DoPageShow(Page: TVirtualPage);
begin
  if Assigned(FOnPageShow) then
    FOnPageShow(Self, Page);
end;

procedure TVirtualPageManager.Loaded;
begin
  inherited Loaded;
  if (DisplayOptions.Parent = nil) and (Owner is TWinControl) then
    DisplayOptions.Parent := TWinControl(Owner);
  if FPageIndex > -1 then
    FPages.UpdateActivePage(-1, FPageIndex);
end;

procedure TVirtualPageManager.SetPageIndex(AValue: Integer);
begin
  if (FPageIndex = AValue) or (AValue >= FPages.Count)
    or (csLoading in ComponentState) then
    Exit;
  FPages.UpdateActivePage(FPageIndex, AValue);
  FPageIndex := AValue;
end;

procedure TVirtualPageManager.SetDisplayOptions(AValue: TControlDisplayOptions);
begin
  FPages.DisplayOptions := AValue;
end;

function TVirtualPageManager.GetDisplayOptions: TControlDisplayOptions;
begin
  Result := FPages.DisplayOptions;
end;

constructor TVirtualPageManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPages := TManagedPages.Create(Self);
  FPageIndex := -1;
end;

destructor TVirtualPageManager.Destroy;
begin
  FPages.Destroy;
  inherited Destroy;
end;

procedure TVirtualPageManager.CallMethod(const AMethodName: String; AllPages: Boolean);
var
  Page: TVirtualPage;
  i: Integer;
begin
  if AllPages then
  begin
    for i := 0 to FPages.Count -1 do
    begin
      Page := FPages[i];
      if Page.Control <> nil then
        LuiMiscUtils.CallMethod(Page.Control, AMethodName);
    end;
  end
  else
  begin
    if (FPageIndex > -1) and (FPageIndex < FPages.Count) then
    begin
     Page := FPages[FPageIndex];
     if Page.Control <> nil then
       LuiMiscUtils.CallMethod(Page.Control, AMethodName);
    end;
  end;
end;

function TVirtualPageManager.PageByName(const PageName: String): TVirtualPage;
begin
  Result := FPages.PageByName(PageName);
end;

{ TControlDisplayOptions }

procedure TControlDisplayOptions.SetBorderSpacing(AValue: TControlBorderSpacing);
begin
  FBorderSpacing.Assign(AValue);
end;

constructor TControlDisplayOptions.Create;
begin
  FBorderSpacing := TControlBorderSpacing.Create(nil);
  FAlign := alClient;
  FLeft := -1;
  FTop := -1;
  FWidth := -1;
  FHeight := -1;
end;

destructor TControlDisplayOptions.Destroy;
begin
  FBorderSpacing.Destroy;
  inherited Destroy;
end;

procedure TControlDisplayOptions.Assign(Source: TPersistent);
begin
  if Source is TControlDisplayOptions then
  begin
    FBorderSpacing.Assign(TControlDisplayOptions(Source).BorderSpacing);
    FAlign := TControlDisplayOptions(Source).FAlign;
    FHeight := TControlDisplayOptions(Source).FHeight;
    FLeft := TControlDisplayOptions(Source).FLeft;
    FTop := TControlDisplayOptions(Source).FTop;
    FWidth := TControlDisplayOptions(Source).FWidth;
  end
  else
    inherited Assign(Source);
end;

procedure TControlDisplayOptions.SetControlBounds(Control: TControl);
var
  NewLeft, NewTop, NewWidth, NewHeight: Integer;
begin
  NewLeft := IfThen(FLeft >= 0, FLeft, Control.Left);
  NewTop := IfThen(FTop >= 0, FTop, Control.Top);
  NewHeight := IfThen(FHeight >= 0, FHeight, Control.Height);
  NewWidth := IfThen(FWidth >= 0, FWidth, Control.Width);
  Control.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
end;

{ TVirtualPage }

procedure TVirtualPage.SetControl(Value: TControl);
begin
  if FControl = Value then
    Exit;
  FControl := Value;
  ControlChanged;
end;

procedure TVirtualPage.ControlChanged;
begin
  //
end;

function TVirtualPage.GetDisplayName: String;
begin
  if FCaption <> '' then
    Result := FCaption
  else
    Result := FName;
end;

destructor TVirtualPage.Destroy;
begin
  FinalizeConstArray(FProperties);
  inherited Destroy;
end;

procedure TVirtualPage.Assign(Source: TPersistent);
begin
  if Source is TVirtualPage then
  begin
    Control := TVirtualPage(Source).FControl;
    FCaption := TVirtualPage(Source).FCaption;
    FControlClass := TVirtualPage(Source).FControlClass;
    FControlClassName := TVirtualPage(Source).FControlClassName;
    FName := TVirtualPage(Source).FName;
    FProperties := TVirtualPage(Source).FProperties;
  end
  else
    inherited Assign(Source);
end;

procedure TVirtualPage.SetProperties(const Elements: array of const);
begin
  FinalizeConstArray(FProperties);
  FProperties := CreateConstArray(Elements);
end;

{ TVirtualPages }

function TVirtualPages.GetItems(Index: Integer): TVirtualPage;
begin
  Result := TVirtualPage(GetItem(Index));
end;

procedure TVirtualPages.SetDisplayOptions(AValue: TControlDisplayOptions);
begin
  FDisplayOptions.Assign(AValue);
end;

procedure TVirtualPages.DoPageHide(Page: TVirtualPage);
begin
  //
end;

procedure TVirtualPages.UpdateActivePage(OldPageIndex, NewPageIndex: Integer);
var
  Page: TVirtualPage;
  PageControl: TControl;
  PageControlClass: TControlClass;
  FoundClass: TPersistentClass;
begin
  if NewPageIndex >= Count then
    raise Exception.CreateFmt(SListIndexError, [NewPageIndex]);
  if OldPageIndex >= Count then
    raise Exception.CreateFmt(SListIndexError, [OldPageIndex]);
  if (NewPageIndex > -1) then
  begin
    Page := Items[NewPageIndex];
    PageControl := Page.Control;
    if (PageControl = nil) then
    begin
      PageControlClass := Page.ControlClass;
      if PageControlClass = nil then
      begin
        FoundClass := FindClass(Page.ControlClassName);
        if FoundClass.InheritsFrom(TControl) then
          PageControlClass := TControlClass(FoundClass);
      end;
      if (PageControlClass <> nil) and (FDisplayOptions.Parent <> nil) then
      begin
        //todo: use Fowner as Owner?
        PageControl := PageControlClass.Create(FDisplayOptions.Parent);
        PageControl.Name := 'VirtualPage' + IntToStr(NewPageIndex) + PageControlClass.ClassName;
        PageControl.Visible := False;
        //todo: see how avoid unecessary resizes
        FDisplayOptions.SetControlBounds(PageControl);
        PageControl.BorderSpacing := FDisplayOptions.BorderSpacing;
        PageControl.Align := FDisplayOptions.Align;
        PageControl.Parent := FDisplayOptions.Parent;
        Page.Control := PageControl;
        SetObjectProperties(PageControl, Page.Properties);
        DoPageLoad(Page);
        CallMethod(PageControl, 'PageLoad');
      end;
    end;
    if PageControl <> nil then
    begin
      PageControl.Visible := True;
      DoPageShow(Page);
      CallMethod(PageControl, 'PageShow');
    end;
  end;
  if (OldPageIndex > -1) then
  begin
   Page := Items[OldPageIndex];
   PageControl := Page.Control;
   if PageControl <> nil then
   begin
     DoPageHide(Page);
     CallMethod(PageControl, 'PageHide');
     PageControl.Visible := False;
   end;
  end;
end;

procedure TVirtualPages.DoPageLoad(Page: TVirtualPage);
begin
  //
end;

procedure TVirtualPages.DoPageShow(Page: TVirtualPage);
begin
  //
end;

constructor TVirtualPages.Create(AItemClass: TCollectionItemClass);
begin
  inherited Create(AItemClass);
  FDisplayOptions := TControlDisplayOptions.Create;
end;

destructor TVirtualPages.Destroy;
begin
  FDisplayOptions.Destroy;
  inherited Destroy;
end;

procedure TVirtualPages.AssignTo(Dest: TPersistent);
var
  i: Integer;
begin
  if Dest is TStrings then
  begin
    TStrings(Dest).Clear;
    for i := 0 to Count - 1 do
      TStrings(Dest).Add(Items[i].Caption);
  end
  else
    inherited AssignTo(Dest);
end;

procedure TVirtualPages.Add(const Name, Caption: String; Control: TControl);
var
  Page: TVirtualPage;
begin
  Page := TVirtualPage(inherited Add);
  Page.Caption := Caption;
  Page.Control := Control;
  Page.Name := Name;
end;

procedure TVirtualPages.Add(const Name, Caption: String; ControlClass: TControlClass;
  const Properties: array of const);
var
  Page: TVirtualPage;
begin
  Page := TVirtualPage(inherited Add);
  Page.Caption := Caption;
  Page.ControlClass := ControlClass;
  Page.Name := Name;
  Page.SetProperties(Properties);
end;

procedure TVirtualPages.Add(const Name, Caption, ControlClassName: String;
  const Properties: array of const);
var
  Page: TVirtualPage;
begin
  Page := TVirtualPage(inherited Add);
  Page.Caption := Caption;
  Page.ControlClassName := ControlClassName;
  Page.Name := Name;
  Page.SetProperties(Properties);
end;

function TVirtualPages.FindPage(const PageName: String): TVirtualPage;
var
  i: Integer;
begin
  for i := 0 to Count -1 do
  begin
    Result := Items[i];
    if SameText(PageName, Result.Name) then
      Exit;
  end;
  Result := nil;
end;

function TVirtualPages.PageByName(const PageName: String): TVirtualPage;
begin
  Result := FindPage(PageName);
  if Result = nil then
    raise Exception.CreateFmt('Page "%s" not found', [PageName]);
end;

end.

