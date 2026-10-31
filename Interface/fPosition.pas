unit fPosition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvEdit, JvValidateEdit, ExtCtrls, Buttons, cAIPosition;

type
  TfmPosition = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    panID: TPanel;
    panButtonBar: TPanel;
    panOKButton: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    Panel41: TPanel;
    Panel42: TPanel;
    Panel43: TPanel;
    Panel44: TPanel;
    Panel45: TPanel;
    Panel46: TPanel;
    cbTangible: TCheckBox;
    edVelocityX: TJvValidateEdit;
    edVelocityY: TJvValidateEdit;
    edVelocityH: TJvValidateEdit;
    edX: TJvValidateEdit;
    edY: TJvValidateEdit;
    edH: TJvValidateEdit;
    edAccelX: TJvValidateEdit;
    edAccelY: TJvValidateEdit;
    edAccelH: TJvValidateEdit;
    edDirXY: TJvValidateEdit;
    edDirH: TJvValidateEdit;
    edMass: TJvValidateEdit;
    edBounce: TJvValidateEdit;
    edBuoyancy: TJvValidateEdit;
    edSizeX: TJvValidateEdit;
    edSizeY: TJvValidateEdit;
    edSizeH: TJvValidateEdit;
    cbCollider: TCheckBox;
    btnApply: TBitBtn;
    btnCopy: TBitBtn;
    edHandle: TJvValidateEdit;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Position: AIPosition;
    procedure GetPosition;
    procedure ApplyPosition;
  end;

var
  fmPosition: TfmPosition;

implementation

uses cAIThings, cGlobals;

{$R *.dfm}

procedure TfmPosition.btnOKClick(Sender: TObject);
begin
  ApplyPosition;
  Close;
end;

procedure TfmPosition.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// fill edit boxes with Position values
procedure TfmPosition.GetPosition;
begin
  edX.Value := Position.X;
  edY.Value := Position.Y;
  edH.Value := Position.Height;
  edVelocityX.Value := Position.Velocity.DeltaX;
  edVelocityY.Value := Position.Velocity.DeltaY;
  edVelocityH.Value := Position.Velocity.DeltaHeight;
  edAccelX.Value := Position.Acceleration.DeltaX;
  edAccelY.Value := Position.Acceleration.DeltaY;
  edAccelH.Value := Position.Acceleration.DeltaHeight;
  edDirXY.Value := Position.DirectionXY;
  edDirH.Value := Position.DirectionH;
  edBuoyancy.Value := Position.Buoyancy;
  edBounce.Value := Position.Bounce;
  edMass.Value := Position.Mass;
  edSizeX.Value := Position.SizeX;
  edSizeY.Value := Position.SizeY;
  edSizeH.Value := Position.SizeH;
  cbTangible.Checked := Position.Tangible;
  cbCollider.Checked := Position.Collider;
end;

// copy edit box values to Position
procedure TfmPosition.ApplyPosition;
begin
  Position.X := edX.Value;
  Position.Y := edY.Value;
  Position.Height := edH.Value;
  Position.Velocity.DeltaX := edVelocityX.Value;
  Position.Velocity.DeltaY := edVelocityY.Value;
  Position.Velocity.DeltaHeight := edVelocityH.Value;
  Position.Acceleration.DeltaX := edAccelX.Value;
  Position.Acceleration.DeltaY := edAccelY.Value;
  Position.Acceleration.DeltaHeight := edAccelH.Value;
  Position.DirectionXY := edDirXY.Value;
  Position.DirectionH := edDirH.Value;
  Position.Buoyancy := edBuoyancy.Value;
  Position.Bounce := edBounce.Value;
  Position.Mass := edMass.Value;
  Position.SizeX := edSizeX.Value;
  Position.SizeY := edSizeY.Value;
  Position.SizeH := edSizeH.Value;
end;

procedure TfmPosition.FormShow(Sender: TObject);
begin
  GetPosition;
end;

procedure TfmPosition.btnApplyClick(Sender: TObject);
begin
  ApplyPosition;
  GetPosition;
end;

procedure TfmPosition.btnCopyClick(Sender: TObject);
var
  myThing: AIThing;
begin
  myThing := AIThing(gThings.FindWithHandle(edHandle.Value));
  if myThing<>nil then
  begin
    Position.FullCopy(myThing.Position);
    GetPosition;
  end
  else
    ShowMessage('Object with that handle does not exist.');
end;

end.
