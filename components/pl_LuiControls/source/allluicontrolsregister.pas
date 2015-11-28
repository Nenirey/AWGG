{**********************************************************************
                PilotLogic Software House.
                   
 Package pl_LuiControls.pkg
 This unit is part of CodeTyphon Project (http://www.pilotlogic.com/)
***********************************************************************}
unit allluicontrolsregister;

{$mode objfpc}{$H+}

interface

uses
 Classes,SysUtils,TypInfo,lresources,PropEdits,ComponentEditors,
 ATBinHex,
  LuiConfig,
  //LuiOrderedDataset,
  //LuiRecordBuffer,
  IniConfigProvider,
  LuiJSONLCLViews,
  JSONMediators,
  ToggleLabel, MenuButton, SearchEdit, ValidateEdit, WizardControls,
  DropDownManager, DropDownButton, AdvancedLabel,VirtualPages,
  uniqueinstance,
  logtreeview;

procedure Register;

implementation

  {$R allluicontrolsregister.res}
//==========================================================
procedure Register;
begin

  RegisterComponents ('LuiControls',[
                                     TToggleLabel,
                                     TAdvancedLabel,
                                     TMenuButton,
                                     TSearchEdit,
                                     TWizardManager,
                                     TWizardButtonPanel,
                                     TDropDownManager,
                                     TDropDownButton,
                                     TVirtualPageManager,
                                     TATBinHex,
                                     TLuiConfig,
                                     TIniConfigProvider,
                                     // TLuiOrderedDataset,
                                     // TLuiRecordBuffer,
                                     TJSONObjectViewManager,
                                     TJSONBooleanGroupMediator,
                                     TLogTreeView,
                                     TUniqueInstance
                                     ]);

  RegisterComponents ('LuiControls DB',[
                                     TDBDateMaskEdit,
                                     TDBValidateEdit
                                     ]);

  RegisterPropertyEditor(TypeInfo(String), TJSONObjectPropertyView,'Options', TStringMultilinePropertyEditor);

end;

end.

