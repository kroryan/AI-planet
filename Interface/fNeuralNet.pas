unit fNeuralNet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, GLMisc, GLScene, GLWin32Viewer;

type
  TfmNeuralNet = class(TForm)
    GLBrainScene: TGLScene;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    btnRun: TBitBtn;
    Panel2: TPanel;
    NeuronList: TListBox;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    Panel5: TPanel;
    GLBrainViewer: TGLSceneViewer;
    ListBox1: TListBox;
    Edit1: TEdit;
    Label1: TLabel;
    NueronConnect: TBitBtn;
    NeuronSelect1: TEdit;
    NeuronSelect2: TEdit;
    NeuronInfo: TMemo;
    Label2: TLabel;
    BitBtn3: TBitBtn;
    Panel6: TPanel;
    Label3: TLabel;
    Label4: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmNeuralNet: TfmNeuralNet;

implementation

{$R *.dfm}

end.
