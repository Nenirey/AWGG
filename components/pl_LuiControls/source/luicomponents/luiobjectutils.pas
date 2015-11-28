unit LuiObjectUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl, contnrs;

type

  {
  //todo: implement as generic when fpc is fixed
  TCreateObjectEvent<T> = procedure(var Instance: T) of object;

  TObjectPool<T> = class
  public
    function Acquire: T;
    procedure Release(Instance: T);
  end;
  }


  TCreateObjectEvent = procedure(var Instance: TObject; const ProfileId: String) of object;

  TNotifyObjectEvent = procedure(Instance: TObject; const ProfileId: String) of object;

  TObjectToStringMap = specialize TFPGMap<PtrInt, String>;

  TStringToObjectMap = specialize TFPGMap<String, PtrInt>;

  { TCustomObjectPool }

  TCustomObjectPool = class
  private
    FActiveList: TObjectToStringMap;
    FAvailableList: TStringToObjectMap;
    FBaseClass: TClass;
    FOnAcquireObject: TNotifyObjectEvent;
    FOnReleaseObject: TNotifyObjectEvent;
    //FProfileList: TFPHashObjectList;
  protected
    procedure DoAcquireObject(Instance: TObject; const ProfileId: String); virtual;
    procedure DoCreateObject(var Instance: TObject; const ProfileId: String); virtual; abstract;
    procedure DoReleaseObject(Instance: TObject; const ProfileId: String); virtual;
    property BaseClass: TClass read FBaseClass write FBaseClass;
    property OnAcquireObject: TNotifyObjectEvent read FOnAcquireObject write FOnAcquireObject;
    property OnReleaseObject: TNotifyObjectEvent read FOnReleaseObject write FOnReleaseObject;
  public
    constructor Create;
    destructor Destroy; override;
    function Acquire(const ProfileId: string = ''): TObject;
    //procedure RegisterProfile(const ProfileId: String);
    procedure Release(Instance: TObject);
  end;

  { TObjectPool }

  TObjectPool = class(TCustomObjectPool)
  private
    FOnCreateObject: TCreateObjectEvent;
  protected
    procedure DoCreateObject(var Instance: TObject; const ProfileId: String); override;
  public
    property BaseClass;
    property OnAcquireObject;
    property OnCreateObject: TCreateObjectEvent read FOnCreateObject write FOnCreateObject;
    property OnReleaseObject;
  end;


implementation

{ TObjectPool<T> }

{

function TObjectPool<T>.Acquire: T;
begin

end;

procedure TObjectPool<T>.Release(Instance: T);
begin

end;

}


procedure TObjectPool.DoCreateObject(var Instance: TObject; const ProfileId: String);
begin
  if Assigned(FOnCreateObject) then
    FOnCreateObject(Instance, ProfileId);
end;

{ TCustomObjectPool }

procedure TCustomObjectPool.DoAcquireObject(Instance: TObject; const ProfileId: String);
begin
  if Assigned(FOnAcquireObject) then
    FOnAcquireObject(Instance, ProfileId);
end;

procedure TCustomObjectPool.DoReleaseObject(Instance: TObject;
  const ProfileId: String);
begin
  if Assigned(FOnReleaseObject) then
    FOnReleaseObject(Instance, ProfileId);
end;

constructor TCustomObjectPool.Create;
begin
  FAvailableList := TStringToObjectMap.Create;
  FActiveList := TObjectToStringMap.Create;
  FBaseClass := TObject;
end;

destructor TCustomObjectPool.Destroy;
var
  i: Integer;
  Obj: TObject;
begin
  for i := 0 to FAvailableList.Count - 1 do
  begin
    Obj := TObject(FAvailableList.Data[i]);
    Obj.Free;
  end;
  FAvailableList.Destroy;
  //todo warn about free of active object
  for i := 0 to FActiveList.Count - 1 do
  begin
    Obj := TObject(FActiveList.Keys[i]);
    Obj.Free;
  end;
  FActiveList.Destroy;
  //FProfileList.Free;
  inherited Destroy;
end;

function TCustomObjectPool.Acquire(const ProfileId: string = ''): TObject;
var
  i: Integer;
  //Profile: TObjectProfile;
begin
  i := FAvailableList.IndexOf(ProfileId);
  if i > -1 then
  begin
    // return an object from pool
    Result := TObject(FAvailableList.Data[i]);
    FAvailableList.Delete(i);
    FActiveList.Add(PtrInt(Result), ProfileId);
  end
  else
  begin
    // create an new object
    Result := nil;
    {
    if FProfileList <> nil then
    begin
      Profile := TObjectProfile(FProfileList.Find(ProfileId));
      //todo add option to exception if not found
    end;
    }
    DoCreateObject(Result, ProfileId);
    if Result = nil then
      raise Exception.Create('ObjectPool.Acquire: Object not created');
    if not Result.InheritsFrom(BaseClass) then
      raise Exception.Create('ObjectPool.Acquire: Instance does not inherits from BaseClass');
    FActiveList.Add(PtrInt(Result), ProfileId);
  end;
  DoAcquireObject(Result, ProfileId);
end;

{
procedure TCustomObjectPool.RegisterProfile(const ProfileId: String);
begin
  if FProfileList = nil then
    FProfileList := TFPHashObjectList.Create(True);
  FProfileList.Add(ProfileId, TObjectProfile.Create(Params));
end;
}

procedure TCustomObjectPool.Release(Instance: TObject);
var
  i: Integer;
  ProfileId: String;
begin
  i := FActiveList.IndexOf(PtrInt(Instance));
  if i > -1 then
  begin
    ProfileId := FActiveList.Data[i];
    FActiveList.Delete(i);
    FAvailableList.Add(ProfileId, PtrInt(Instance));
    DoReleaseObject(Instance, ProfileId);
  end
  else
    raise Exception.Create('ObjectPool.Release: Instance not active');
end;

end.

