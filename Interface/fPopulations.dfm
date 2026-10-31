object fmPopulations: TfmPopulations
  Left = 338
  Top = 179
  Width = 449
  Height = 377
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Populations'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PopGraph: TChart
    Left = 0
    Top = 0
    Width = 441
    Height = 283
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    LeftWall.Color = clWhite
    Title.Text.Strings = (
      'Populations')
    Title.Visible = False
    Chart3DPercent = 10
    Legend.LegendStyle = lsSeries
    View3DOptions.Perspective = 0
    Align = alClient
    TabOrder = 0
  end
  object Panel3: TPanel
    Left = 0
    Top = 283
    Width = 441
    Height = 60
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 36
      Width = 51
      Height = 13
      Caption = 'Crop Rate:'
    end
    object Label2: TLabel
      Left = 150
      Top = 36
      Width = 66
      Height = 13
      Caption = 'Refresh Rate:'
    end
    object Panel4: TPanel
      Left = 331
      Top = 1
      Width = 109
      Height = 58
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnRun: TBitBtn
        Left = 24
        Top = 24
        Width = 75
        Height = 25
        Caption = 'Close'
        TabOrder = 0
        OnClick = btnRunClick
        Kind = bkOK
      end
    end
    object cb3DGraph: TCheckBox
      Left = 70
      Top = 8
      Width = 77
      Height = 17
      Caption = '3-D Graph'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = cb3DGraphClick
    end
    object cbCrop: TCheckBox
      Left = 14
      Top = 8
      Width = 51
      Height = 17
      Caption = 'Crop'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object cbHiddenRefresh: TCheckBox
      Left = 152
      Top = 8
      Width = 135
      Height = 17
      Caption = 'Refresh When Hidden'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object edCrop: TJvValidateEdit
      Left = 72
      Top = 32
      Width = 61
      Height = 21
      CheckChars = '01234567890'
      CriticalPoints.CheckPoints = cpNone
      CriticalPoints.ColorAbove = clBlue
      CriticalPoints.ColorBelow = clRed
      EditText = '1024'
      HasMaxValue = True
      HasMinValue = True
      MaxValue = 100000.000000000000000000
      MinValue = 100.000000000000000000
      TabOrder = 4
      Text = '1024'
      Value = 1024
      OnChange = edCropChange
    end
    object edRate: TJvValidateEdit
      Left = 222
      Top = 32
      Width = 63
      Height = 21
      CheckChars = '01234567890'
      CriticalPoints.CheckPoints = cpNone
      CriticalPoints.ColorAbove = clBlue
      CriticalPoints.ColorBelow = clRed
      EditText = '4'
      HasMaxValue = True
      HasMinValue = True
      MaxValue = 100000.000000000000000000
      MinValue = 1.000000000000000000
      TabOrder = 5
      Text = '4'
      Value = 4
      OnChange = edRateChange
    end
  end
end
