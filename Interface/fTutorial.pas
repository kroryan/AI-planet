{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fTutorial.pas,v 1.2 2003/06/28 21:47:54 aidave Exp $
}
unit fTutorial;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TfmTutorial = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    redIntro: TRichEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    btnRun: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmTutorial: TfmTutorial;

implementation

{$R *.dfm}

end.
