unit logtreeview;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Comctrls, Controls, MultiLog, LResources, Graphics;

type

  { TLogTreeView }

  TLogTreeView = class (TCustomTreeView)
  private
    FImgList: TImageList;
    FChannel: TLogChannel;
    FLastNode: TTreeNode;
    FParentNode: TTreeNode;
    FShowTime: Boolean;
    FTimeFormat: String;
    function GetChannel: TLogChannel;
  public
    constructor Create(AnOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddMessage (AMsg: TLogMessage);
    procedure Clear;
    property Channel: TLogChannel read GetChannel;
  published
    property Align;
    property Anchors;
    property AutoExpand;
    property BorderSpacing;
    //property BiDiMode;
    property BackgroundColor;
    property BorderStyle;
    property BorderWidth;
    property Color;
    property Constraints;
    property DefaultItemHeight;
    property DragKind;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ExpandSignType;
    property Font;
    property HideSelection;
    property HotTrack;
    //property Images;
    property Indent;
    //property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RightClickSelect;
    property RowSelect;
    property ScrollBars;
    property SelectionColor;
    property ShowButtons;
    property ShowHint;
    property ShowLines;
    property ShowRoot;
    property ShowTime: Boolean read FShowTime write FShowTime;
    property SortType;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property Tag;
    property TimeFormat: String read FTimeFormat write FTimeFormat;
    property ToolTips;
    property Visible;
    property OnAdvancedCustomDraw;
    property OnAdvancedCustomDrawItem;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnCollapsed;
    property OnCollapsing;
    property OnCompare;
    property OnContextPopup;
    property OnCustomCreateItem;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnDblClick;
    property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    property OnEdited;
    property OnEditing;
    //property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanded;
    property OnExpanding;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnSelectionChanged;
    property Options;
    //property OnStartDock;
    property OnStartDrag;
    //property Items;
    property TreeLineColor;
    property ExpandSignColor;
  end;

implementation

type
  { TLogTreeViewChannel }

  TLogTreeViewChannel = class (TLogChannel)
  private
    FControl: TLogTreeView;
  public
    constructor Create (AControl: TLogTreeView);
    procedure Clear; override;
    procedure Deliver(const AMsg: TLogMessage);override;
  end;

{ TLogTreeViewChannel }

constructor TLogTreeViewChannel.Create(AControl: TLogTreeView);
begin
  FControl:=AControl;
  Active:=True;
end;

procedure TLogTreeViewChannel.Clear;
begin
  FControl.Clear;
end;

procedure TLogTreeViewChannel.Deliver(const AMsg: TLogMessage);
begin
  FControl.AddMessage(AMsg);
end;

{ TLogTreeView }

function TLogTreeView.GetChannel: TLogChannel;
begin
  if FChannel = nil then
    FChannel:=TLogTreeViewChannel.Create(Self);
  Result:=FChannel;
end;

constructor TLogTreeView.Create(AnOwner: TComponent);
begin
  inherited Create(AnOwner);
  FTimeFormat := 'hh:nn:ss:zzz';
  FImgList:=TImageList.Create(nil);
  with FImgList do
  begin
    AddLazarusResource('info', clDefault);
    AddLazarusResource('error', clDefault);
    AddLazarusResource('warning', clDefault);
    AddLazarusResource('value', clDefault);
    AddLazarusResource('entermethod', clDefault);
    AddLazarusResource('exitmethod', clDefault);
    AddLazarusResource('whatisthis', clDefault);  //conditional
    AddLazarusResource('check', clDefault);
    AddLazarusResource('strings', clDefault);
    AddLazarusResource('callstack', clDefault);
    AddLazarusResource('object', clDefault);
    AddLazarusResource('error', clDefault);
    AddLazarusResource('image', clDefault);
    AddLazarusResource('whatisthis', clDefault);   //heap
    AddLazarusResource('whatisthis', clDefault);   //memory
    AddLazarusResource('whatisthis', clDefault);   //custom data
  end;
  Images:=FImgList;
end;

destructor TLogTreeView.Destroy;
begin
  FImgList.Destroy;
  FreeAndNil(FChannel);
  inherited Destroy;
end;

procedure TLogTreeView.AddMessage(AMsg: TLogMessage);

  procedure ParseStream(AStream:TStream);
  var
    i: Integer;
    AStrList: TStringList;
  begin
    //todo: Parse the String in Stream directly instead of using StringList ??
     AStrList:=TStringList.Create;
     AStream.Position:=0;
     AStrList.LoadFromStream(AStream);
     for i:= 0 to AStrList.Count - 1 do
       Items.AddChild(FLastNode,AStrList[i]);
     FLastNode.Text:=FLastNode.Text+' ('+IntToStr(AStrList.Count)+' Items)';
     AStrList.Destroy;
  end;
var
  TempStream:TStream;
  AText: String;
begin
  AText := AMsg.MsgText;
  if FShowTime then
    AText := FormatDateTime(FTimeFormat, Time) + ' ' + AText;
  with Items, AMsg do
  begin
    case AMsg.MsgType of
      ltEnterMethod:
        begin
          FLastNode:=AddChild(FParentNode,AText);
          FParentNode:=FLastNode;
        end;
      ltExitMethod:
        begin
          if FParentNode <> nil then
            FLastNode:=AddChild(FParentNode.Parent,AText)
          else
            FLastNode:=AddChild(nil,AText);
          FParentNode:=FLastNode.Parent;
        end;
       ltCallStack,ltStrings,ltHeapInfo,ltException:
         begin
           FLastNode:=AddChild(FParentNode,AText);
           if Assigned(Data) and (Data.Size>0) then
             ParseStream(Data)
           else
             FLastNode.Text:=FLastNode.Text+' (No Items)';
         end;
       ltObject:
         begin
           FLastNode:=AddChild(FParentNode,AText);
           if Assigned(Data) and (Data.Size>0) then
           begin
            Data.Position:=0;
            TempStream:=TStringStream.Create('');
            ObjectBinaryToText(Data,TempStream);
            ParseStream(TempStream);
            TempStream.Destroy;
           end;
         end;
       else
       begin
         FLastNode:=AddChild(FParentNode,AText);
       end;
    end;
  end;
  //todo: hook TCustomTreeView to auto expand
  if FLastNode.Parent <> nil then
    FLastNode.Parent.Expanded:=True;
  FLastNode.GetFirstChild;
  //todo: optimize painting
  FLastNode.ImageIndex:=AMsg.MsgType;
  FLastNode.SelectedIndex:=AMsg.MsgType;
end;

procedure TLogTreeView.Clear;
begin
  Items.Clear;
  FLastNode:=nil;
  FParentNode:=nil;
end;

initialization
  {$i logimages.lrs}
end.

.Parent.Expanded:=True;
  FLastNode.GetFirstChild;
  //todo: optimize painting
  FLastNode.ImageIndex:=AMsg.MsgType;
  FLastNode.SelectedIndex:=AMsg.MsgType;
end;

procedure TLogTreeView.Clear;
begin
  Items.Clear;
  FLastNode:=nil;
  FParentNode:=nil;
end;

initialization
  {$i logimages.lrs}
end.

