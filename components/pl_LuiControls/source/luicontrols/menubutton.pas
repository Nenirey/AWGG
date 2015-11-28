unit MenuButton;

{
  Implements TMenuButton

  Copyright (C) 2007 Luiz Américo Pereira Câmara
  luizmed@oi.com.br

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}


{$mode objfpc}{$H+}

interface


uses
  LCLType, Forms, Classes, SysUtils, DropDownBaseButtons, Menus;

type

  { TMenuButton }

  TMenuButton = class (TCustomDropDownButton)
  private
    FMenu: TPopupMenu;
    procedure MenuClosed(Sender: TObject);
    procedure SetMenu(const AValue: TPopupMenu);
  protected
    procedure DoShowDropDown; override;
  public
  published
    property Menu: TPopupMenu read FMenu write SetMenu;
    //dropdown properties
    property Options;
    property Style;
    //TSpeedButton properties
    property Action;
    property Align;
    property Anchors;
    property AllowAllUp;
    property AutoSize;
    property BorderSpacing;
    property Constraints;
    property Caption;
    property Color;
    property Down;
    property Enabled;
    property Flat;
    property Font;
    property Glyph;
    property GroupIndex;
    property Layout;
    property Margin;
    property NumGlyphs;
    property Spacing;
    property Transparent;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint;
    property OnResize;
    property OnChangeBounds;
    property ShowCaption;
    property ShowHint;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
  end;

implementation

{ TMenuButton }

procedure TMenuButton.MenuClosed(Sender: TObject);
begin
  DropDownClosed;
end;

procedure TMenuButton.SetMenu(const AValue: TPopupMenu);
begin
  FMenu := AValue;
  //todo: store original onclose
  if FMenu <> nil then
    FMenu.OnClose := @MenuClosed;
end;

procedure TMenuButton.DoShowDropDown;
var
  P: TPoint;
begin
  //Logger.SendCallStack('ShowMenu');
  if FMenu = nil then
    Exit;
  //necessary to avoid Click eat when hitting multiple menubuttons successively
  //This will unlock update of previous clicked menubutton
  Application.ProcessMessages;
  P := ClientToScreen(Point(0,Height));
  FMenu.PopUp(P.X, P.Y);
end;

end.

