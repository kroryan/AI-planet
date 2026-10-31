{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fCreatingGalaxy.pas,v 1.2 2003/06/28 21:47:54 aidave Exp $
}
unit fCreatingGalaxy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons;

type
  TfmCreatingGalaxy = class(TForm)
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
  fmCreatingGalaxy: TfmCreatingGalaxy;

implementation

{$R *.dfm}

end.
