object fmBuildProgress: TfmBuildProgress
  Left = 569
  Top = 180
  Width = 258
  Height = 67
  BorderIcons = []
  Caption = 'Building Planet...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pbBuildProgress: TProgressBar
    Left = 8
    Top = 8
    Width = 233
    Height = 17
    Min = 0
    Max = 100
    TabOrder = 0
  end
end
