unit fViewStatus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons;

type
  TfmConstruction = class(TForm)
    Panel1: TPanel;
    redStatus: TRichEdit;
    Panel2: TPanel;
    pbTextures: TProgressBar;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmConstruction: TfmConstruction;

implementation

{$R *.dfm}

end.
