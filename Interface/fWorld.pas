unit fWorld;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TfmWorld = class(TForm)
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edRadius: TEdit;
    edHeight: TEdit;
    edWidth: TEdit;
    Label3: TLabel;
    panButtonBar: TPanel;
    panOKButton: TPanel;
    btnOK: TBitBtn;
    BitBtn1: TBitBtn;
    RichEdit1: TRichEdit;
    Label8: TLabel;
    Label9: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmWorld: TfmWorld;

implementation

{$R *.dfm}

end.
