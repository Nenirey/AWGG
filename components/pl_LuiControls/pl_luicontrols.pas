{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit pl_luicontrols;

interface

uses
  allluicontrolsregister, ATBinHex, IniConfigProvider, LuiConfig, LuiDBUtils, 
  LuiJSONLCLViews, LuiJSONUtils, LuiLCLInterfaces, LuiLCLMessages, 
  LuiRTTIUtils, LuiStrUtils, VarRecUtils, AdvancedLabel, DropDownButton, 
  DropDownManager, FormMediator, JSONBooleanRadioButtonView, JSONMediators, 
  MenuButton, PresentationManager, SearchEdit, ToggleLabel, ValidateEdit, 
  VirtualPages, WizardControls, filechannel, ipcchannel, logtreeview, 
  multiloglcl, sharedlogger, UniqueInstance, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('allluicontrolsregister', @allluicontrolsregister.Register);
end;

initialization
  RegisterPackage('pl_luicontrols', @Register);
end.
