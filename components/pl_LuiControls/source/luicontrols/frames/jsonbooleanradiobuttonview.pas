unit JSONBooleanRadioButtonView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, JSONMediators;

type

  { TJSONBooleanRadioButtonViewFrame }

  TJSONBooleanRadioButtonViewFrame = class(TFrame)
    CaptionLabel: TLabel;
    FalseRadioButton: TRadioButton;
    IndeterminateRadioButton: TRadioButton;
    TrueRadioButton: TRadioButton;
  private
    function GetValue: TBooleanValue;
    procedure SetPropertyCaption(const AValue: String);
    procedure SetTrueCaption(const Value: String);
    procedure SetFalseCaption(const Value: String);
    procedure SetIndeterminateCaption(const Value: String);
    procedure SetValue(Value: TBooleanValue);
  public
    property PropertyCaption: String write SetPropertyCaption;
    property TrueCaption: String write SetTrueCaption;
    property FalseCaption: String write SetFalseCaption;
    property IndeterminateCaption: String write SetIndeterminateCaption;
    property Value: TBooleanValue read GetValue write SetValue;
  end;

implementation

{$R *.lfm}

{ TJSONBooleanRadioButtonViewFrame }

procedure TJSONBooleanRadioButtonViewFrame.SetTrueCaption(const Value: String);
begin
  TrueRadioButton.Caption := Value;
end;

procedure TJSONBooleanRadioButtonViewFrame.SetFalseCaption(const Value: String);
begin
  FalseRadioButton.Caption := Value;
end;

procedure TJSONBooleanRadioButtonViewFrame.SetIndeterminateCaption(const Value: String);
begin
  if Value = '' then
    IndeterminateRadioButton.Visible := False
  else
    IndeterminateRadioButton.Caption := Value;
end;

procedure TJSONBooleanRadioButtonViewFrame.SetValue(Value: TBooleanValue);
begin
  case Value of
    bvTrue: TrueRadioButton.Checked := True;
    bvFalse: FalseRadioButton.Checked := True;
    bvIndeterminate: IndeterminateRadioButton.Checked := True;
  end;
end;

function TJSONBooleanRadioButtonViewFrame.GetValue: TBooleanValue;
begin
  if TrueRadioButton.Checked then
    Result := bvTrue
  else if FalseRadioButton.Checked then
    Result := bvFalse
  else if IndeterminateRadioButton.Checked then
    Result := bvIndeterminate
  else
    Result := bvNone;
end;

procedure TJSONBooleanRadioButtonViewFrame.SetPropertyCaption(const AValue: String);
begin
  CaptionLabel.Caption := AValue;
end;

end.

