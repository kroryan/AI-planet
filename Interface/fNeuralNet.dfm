object fmNeuralNet: TfmNeuralNet
  Left = 334
  Top = 183
  Width = 802
  Height = 686
  Caption = 'fmNeuralNet'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 522
    Top = 0
    Width = 272
    Height = 402
    Align = alRight
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 40
      Height = 13
      Caption = 'Neurons'
    end
    object NeuronList: TListBox
      Left = 10
      Top = 28
      Width = 177
      Height = 235
      ItemHeight = 13
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 92
      Top = 268
      Width = 75
      Height = 25
      Caption = 'Delete Neuron'
      TabOrder = 1
    end
    object BitBtn1: TBitBtn
      Left = 10
      Top = 268
      Width = 75
      Height = 25
      Caption = 'New Neuron'
      TabOrder = 2
    end
    object NueronConnect: TBitBtn
      Left = 138
      Top = 346
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 3
    end
    object NeuronSelect1: TEdit
      Left = 12
      Top = 332
      Width = 121
      Height = 21
      ReadOnly = True
      TabOrder = 4
      Text = 'Neuron Selection 1'
    end
    object NeuronSelect2: TEdit
      Left = 12
      Top = 358
      Width = 121
      Height = 21
      ReadOnly = True
      TabOrder = 5
      Text = 'Neuron Selection 2'
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 611
    Width = 794
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Panel4: TPanel
      Left = 684
      Top = 1
      Width = 109
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnRun: TBitBtn
        Left = 18
        Top = 6
        Width = 75
        Height = 25
        TabOrder = 0
        Kind = bkOK
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 402
    Width = 794
    Height = 209
    Align = alBottom
    TabOrder = 2
    object Label2: TLabel
      Left = 406
      Top = 42
      Width = 59
      Height = 13
      Caption = 'Connections'
    end
    object Label3: TLabel
      Left = 632
      Top = 68
      Width = 84
      Height = 13
      Caption = 'Connection Editor'
    end
    object Label4: TLabel
      Left = 220
      Top = 74
      Width = 65
      Height = 13
      Caption = 'Neuron Editor'
    end
    object ListBox1: TListBox
      Left = 404
      Top = 66
      Width = 213
      Height = 89
      ItemHeight = 13
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 28
      Top = 42
      Width = 173
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Text = 'Neuron Name'
    end
    object NeuronInfo: TMemo
      Left = 28
      Top = 70
      Width = 175
      Height = 93
      Lines.Strings = (
        'NeuronInfo')
      ReadOnly = True
      TabOrder = 2
    end
    object BitBtn3: TBitBtn
      Left = 402
      Top = 162
      Width = 119
      Height = 25
      Caption = 'Break Connection'
      TabOrder = 3
    end
    object Panel6: TPanel
      Left = 1
      Top = 1
      Width = 792
      Height = 24
      Align = alTop
      Caption = 'Neuron Edit'
      TabOrder = 4
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 522
    Height = 402
    Align = alClient
    BorderWidth = 5
    TabOrder = 3
    object GLBrainViewer: TGLSceneViewer
      Left = 6
      Top = 6
      Width = 510
      Height = 390
      Buffer.BackgroundColor = clBlack
      Align = alClient
    end
  end
  object GLBrainScene: TGLScene
    Left = 10
    Top = 14
  end
end
