unit fEditLine;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfmEditLine = class(TForm)
    edLine: TEdit;
    BitBtn1: TBitBtn;
    labName: TLabel;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEditLine: TfmEditLine;

implementation

{$R *.DFM}

end.
