unit PresentationManager;

{$mode objfpc}{$H+}

interface

uses
  Forms, Classes, SysUtils, contnrs;

type

  { TPresenter }

  TPresenter = class(TComponent)
  protected
    procedure Initialize; virtual;
    function GetViewCaption(const DesignCaption: String): String; virtual;
  public
  end;

  TPresenterClass = class of TPresenter;

  IPresentation = interface
    ['{5FFDE1D3-AA0B-43C9-8ED3-437E33806B15}']
    function SetProperties(const Properties: array of const): IPresentation;
    function ShowModal: IPresentation;
    function ShowModal(const Properties: array of const): TModalResult;
    function ModalResult: TModalResult;
  end;

  IPresentationManager = interface
    ['{25532926-50FF-42F3-800D-AB4A7B01B3BA}']
    function GetPresentation(const PresentationName: String): IPresentation;
    procedure Register(const PresentationName: String; ViewClass: TFormClass; PresenterClass: TPresenterClass = nil);
    property Items[const PresentationName: String]: IPresentation read GetPresentation; default;
  end;

  { TPresentationManager }

  TPresentationManager = class(TComponent, IPresentationManager)
  private
    FPresentationDefs: TFPHashObjectList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetPresentation(const PresentationName: String): IPresentation;
    procedure Register(const PresentationName: String; ViewClass: TFormClass; PresenterClass: TPresenterClass = nil);
    property Items[const PresentationName: String]: IPresentation read GetPresentation; default;
  end;

implementation

uses
  LuiRTTIUtils, typinfo;

type
  TPresentationDef = class
  private
    FPresenterClass: TPresenterClass;
    FViewClass: TFormClass;
  end;

  { TPresentation }

  TPresentation = class(TInterfacedObject, IPresentation)
  private
    FView: TForm;
    FPresenter: TPresenter;
    FModalResult: TModalResult;
    procedure CheckPresenterInstance;
    procedure InitializeProperties;
  public
    constructor Create(PresentationDef: TPresentationDef);
    destructor Destroy; override;
    function ModalResult: TModalResult;
    function SetProperties(const Properties: array of const): IPresentation;
    function ShowModal: IPresentation;
    function ShowModal(const Properties: array of const): TModalResult;
  end;


procedure TPresenter.Initialize;
begin
  //
end;

function TPresenter.GetViewCaption(const DesignCaption: String): String;
begin
  Result := DesignCaption;
end;

{ TPresenterPresentation }

{ TFormPresentation }

procedure TPresentation.CheckPresenterInstance;
begin
  if FPresenter = nil then
    raise Exception.CreateFmt('%s requires a presenter', [FView.ClassName]);
end;

procedure TPresentation.InitializeProperties;
var
  PropInfo: PPropInfo;
  TypeData: PTypeData;
  Intf: IInterface;
begin
  PropInfo := GetPropInfo(FView, 'Presenter');
  if PropInfo <> nil then
  begin
    //has a presenter property
    TypeData := GetTypeData(PropInfo^.PropType);
    case PropInfo^.PropType^.Kind of
      tkInterface:
        begin
          CheckPresenterInstance;
          if not FPresenter.GetInterface(TypeData^.GUID, Intf) then
            raise Exception.CreateFmt('%s requires a presenter that implements %s',
              [FView.ClassName, GUIDToString(TypeData^.GUID)]);
          SetInterfaceProp(FView, PropInfo, Intf);
        end;
      tkClass:
        begin
          CheckPresenterInstance;
          if not FPresenter.InheritsFrom(TypeData^.ClassType) then
            raise Exception.CreateFmt('%s requires a presenter that inherits from %s',
              [FView.ClassName, TypeData^.ClassType.ClassName]);
          SetObjectProp(FView, PropInfo, FPresenter);
        end;
      else
        raise Exception.CreateFmt('%s - Presenter property must be a COM interface or a class',
          [FView.ClassName]);
    end;
  end;
  //todo: check if presenter requires a view
end;

constructor TPresentation.Create(PresentationDef: TPresentationDef);
begin
  FView := PresentationDef.FViewClass.Create(nil);
  if PresentationDef.FPresenterClass <> nil then
    FPresenter := PresentationDef.FPresenterClass.Create(FView);
end;

destructor TPresentation.Destroy;
begin
  FView.Free;
  inherited Destroy;
end;

function TPresentation.ModalResult: TModalResult;
begin
  Result := FModalResult;
end;

function TPresentation.SetProperties(
  const Properties: array of const): IPresentation;
begin
  if FPresenter <> nil then
    SetObjectProperties(FPresenter, Properties)
  else
    SetObjectProperties(FView, Properties);
  Result := Self;
end;

function TPresentation.ShowModal: IPresentation;
begin
  InitializeProperties;
  if FPresenter <> nil then
  begin
    FPresenter.Initialize;
    FView.Caption := FPresenter.GetViewCaption(FView.Caption);
  end;
  //todo: add presenter afterviewshow?
  FModalResult := FView.ShowModal;
  Result := Self;
end;

function TPresentation.ShowModal(const Properties: array of const): TModalResult;
begin
  Result := SetProperties(Properties).ShowModal.ModalResult;
end;

{ TPresentationManager }

constructor TPresentationManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPresentationDefs := TFPHashObjectList.Create(True);
end;

destructor TPresentationManager.Destroy;
begin
  FPresentationDefs.Destroy;
  inherited Destroy;
end;

function TPresentationManager.GetPresentation(const PresentationName: String): IPresentation;
var
  PresentationDef: TPresentationDef;
begin
  PresentationDef := TPresentationDef(FPresentationDefs.Find(PresentationName));
  if PresentationDef = nil then
    raise Exception.CreateFmt('Presentation "%s" not found', [PresentationName]);
  Result := TPresentation.Create(PresentationDef);
end;

procedure TPresentationManager.Register(const PresentationName: String;
  ViewClass: TFormClass; PresenterClass: TPresenterClass);
var
  PresentationDef: TPresentationDef;
begin
  if ViewClass = nil then
    raise Exception.CreateFmt('Unable to register "%s" presentation: ViewClass must be <> nil', [PresentationName]);
  if FPresentationDefs.FindIndexOf(PresentationName) <> -1 then
    raise Exception.CreateFmt('Presentation "%s" already registered', [PresentationName]);
  PresentationDef := TPresentationDef.Create;
  PresentationDef.FViewClass := ViewClass;
  PresentationDef.FPresenterClass := PresenterClass;
  FPresentationDefs.Add(PresentationName, PresentationDef);
end;

end.

