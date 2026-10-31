{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr and Aaron Hochwimmer
  $Id: fHumidityMap.pas,v 1.2 2003/06/28 21:47:54 aidave Exp $
}
unit fHumidityMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fHeightField;

type
  TfmHumidityMap = class(TfmHeightField)
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmHumidityMap: TfmHumidityMap;

implementation

uses fFirstForm;

{$R *.dfm}

procedure TfmHumidityMap.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);

  HeatField.OnGetHeight := HumidityFormula;
end;

procedure TfmHumidityMap.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := false;
  fmFirstForm.RealityForm.ManagerForm.DropHumidityMap;
end;

end.
