unit fDNA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvEdit, JvValidateEdit, ExtCtrls, Buttons, cAIDNA,
  Menus;

type
  TfmDNA = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    panID: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    edPreferredFood: TJvValidateEdit;
    panButtonBar: TPanel;
    panOKButton: TPanel;
    btnCancel: TBitBtn;
    edMutation: TJvValidateEdit;
    edBuoyancy: TJvValidateEdit;
    Panel3: TPanel;
    Panel8: TPanel;
    edBounce: TJvValidateEdit;
    OpenDNADialog: TOpenDialog;
    SaveDNADialog: TSaveDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    LoadDNA1: TMenuItem;
    SaveDNA1: TMenuItem;
    Panel9: TPanel;
    Panel10: TPanel;
    edGreen: TJvValidateEdit;
    Panel11: TPanel;
    Panel14: TPanel;
    edBlue: TJvValidateEdit;
    Panel15: TPanel;
    Panel16: TPanel;
    edRed: TJvValidateEdit;
    Panel17: TPanel;
    btnOK: TBitBtn;
    btnLoadDNA: TBitBtn;
    btnSaveDNA: TBitBtn;
    Panel18: TPanel;
    Panel19: TPanel;
    edLifespan: TJvValidateEdit;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LoadDNA1Click(Sender: TObject);
    procedure SaveDNA1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DNA: AIDNA;
    procedure GetDNA;
    procedure ApplyDNA;
  end;

var
  fmDNA: TfmDNA;

implementation

{$R *.dfm}

procedure TfmDNA.btnOKClick(Sender: TObject);
begin
  ApplyDNA;
  Close;
end;

procedure TfmDNA.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// fill edit boxes with DNA values
procedure TfmDNA.GetDNA;
begin
  edMutation.Value := DNA.Mutation;
  edBuoyancy.Value := DNA.Buoyancy;
  edBounce.Value := DNA.Bounce;
  edPreferredFood.Value := DNA.PreferredFood;
  edRed.Value := DNA.Red;
  edBlue.Value := DNA.Blue;
  edGreen.Value := DNA.Green;
  edLifespan.Value := DNA.LifeSpan;
end;

// copy edit box values to DNA
procedure TfmDNA.ApplyDNA;
begin
  DNA.Mutation := edMutation.Value;
  DNA.Buoyancy := edBuoyancy.Value;
  DNA.Bounce := edBounce.Value;
  DNA.PreferredFood := edPreferredFood.Value;
  DNA.Red := edRed.Value;
  DNA.Blue := edBlue.Value;
  DNA.Green := edGreen.Value;
  DNA.LifeSpan := edLifespan.Value;
end;

procedure TfmDNA.FormShow(Sender: TObject);
begin
  GetDNA;
end;

procedure TfmDNA.LoadDNA1Click(Sender: TObject);
begin
  OpenDNADialog.InitialDir := ExtractFilePath(Application.ExeName) + '\data';
  OpenDNADialog.Filter := '*.ini,*.dna';
  if OpenDNADialog.Execute then
  begin
    if FileExists(OpenDNADialog.FileName) then
      DNA.LoadFromINI(OpenDNADialog.FileName);
    GetDNA;
  end;
  SetCurrentDir(ExtractFilePath(Application.ExeName));
end;

procedure TfmDNA.SaveDNA1Click(Sender: TObject);
begin
  SaveDNADialog.InitialDir := ExtractFilePath(Application.ExeName) + '\data';
  SaveDNADialog.Filter := '*.ini,*.dna';
  if SaveDNADialog.Execute then
  begin
    if DNA.SaveToINI(SaveDNADialog.FileName) then
      ShowMessage('Save DNA as ' + SaveDNADialog.FileName)
    else
      ShowMessage('Failed to save DNA.');
    ApplyDNA;
  end;
  SetCurrentDir(ExtractFilePath(Application.ExeName));
end;

end.
