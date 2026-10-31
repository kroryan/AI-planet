{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fBuildProgress.pas,v 1.2 2003/06/28 21:47:54 aidave Exp $
}
unit fBuildProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TfmBuildProgress = class(TForm)
    pbBuildProgress: TProgressBar;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmBuildProgress: TfmBuildProgress;

implementation

{$R *.dfm}

procedure TfmBuildProgress.FormCreate(Sender: TObject);
begin
  Top := 1;
  Left := 1;
end;

end.
