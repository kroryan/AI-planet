{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: fImages.pas,v 1.4 2003/06/28 21:47:54 aidave Exp $
}
unit fImages;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, ExtCtrls;

type
  TfmImages = class(TForm)
    panImages: TPanel;
    imgIcons: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmImages: TfmImages;

implementation

uses fFirstForm;

{$R *.DFM}

end.
