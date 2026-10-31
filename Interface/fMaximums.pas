{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fMaximums.pas,v 1.7 2005/11/20 09:38:36 aidave Exp $
}
unit fMaximums;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, cAIThings, JvEdit,
  JvValidateEdit, JvExStdCtrls;

type
  TfmMaximums = class(TForm)
    BackPanel: TPanel;
    panButtonBar: TPanel;
    panOKButton: TPanel;
    btnOK: TBitBtn;
    ListBox: TListBox;
    btnEdit: TBitBtn;
    Panel1: TPanel;
    EditMax: TJvValidateEdit;
    btnDefaults: TBitBtn;
    procedure btnDefaultsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Refresh;
    procedure RefreshMaximums;
  end;

var
  fmMaximums: TfmMaximums;

implementation

{$R *.dfm}

uses cGlobals;

procedure TfmMaximums.Refresh;
begin
  RefreshMaximums;
end;

procedure TfmMaximums.btnDefaultsClick(Sender: TObject);
begin
  gThings.DefaultMaximums;
  Refresh;
end;

procedure TfmMaximums.FormShow(Sender: TObject);
begin
  Refresh;
end;

procedure TfmMaximums.RefreshMaximums;
var
  i: integer;
begin
  ListBox.Clear;
  for i := 0 to cLastThing do
  begin
    ListBox.AddItem(
      ThingName(i) + ' ' + IntToStr(gThings.Maximums[i]),
      nil);
  end;
end;

procedure TfmMaximums.ListBoxClick(Sender: TObject);
begin
  // show the selected maximum value in the edit box
  if ListBox.ItemIndex <> -1 then
    EditMax.Text := IntToStr(gThings.Maximums[ListBox.ItemIndex]);
end;

procedure TfmMaximums.btnEditClick(Sender: TObject);
begin
  // save the maximum value from the edit box
  if ListBox.ItemIndex <> -1 then
  try
    StrToInt(EditMax.Text)
  finally
    gThings.Maximums[ListBox.ItemIndex] := StrToInt(EditMax.Text);
  end;
  Refresh;
end;

end.
