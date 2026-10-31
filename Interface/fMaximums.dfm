object fmMaximums: TfmMaximums
  Left = 311
  Top = 150
  Width = 450
  Height = 550
  Caption = 'Maximums'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BackPanel: TPanel
    Left = 0
    Top = 0
    Width = 442
    Height = 444
    Align = alClient
    BorderWidth = 2
    TabOrder = 0
    object ListBox: TListBox
      Left = 3
      Top = 3
      Width = 436
      Height = 438
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListBoxClick
    end
  end
  object panButtonBar: TPanel
    Left = 0
    Top = 475
    Width = 442
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    object panOKButton: TPanel
      Left = 337
      Top = 1
      Width = 104
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK: TBitBtn
        Left = 10
        Top = 6
        Width = 75
        Height = 25
        TabOrder = 0
        Kind = bkOK
      end
    end
    object btnEdit: TBitBtn
      Left = 234
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Commit'
      TabOrder = 1
      OnClick = btnEditClick
      Kind = bkHelp
    end
    object EditMax: TJvValidateEdit
      Left = 122
      Top = 10
      Width = 99
      Height = 21
      CheckChars = '01234567890'
      CriticalPoints.CheckPoints = cpNone
      CriticalPoints.ColorAbove = clBlue
      CriticalPoints.ColorBelow = clRed
      EditText = '0'
      HasMaxValue = True
      HasMinValue = True
      MaxValue = 100000.000000000000000000
      TabOrder = 2
      Text = '0'
      Value = 0
    end
    object btnDefaults: TBitBtn
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Defaults'
      TabOrder = 3
      OnClick = btnDefaultsClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 444
    Width = 442
    Height = 31
    Align = alBottom
    Caption = 
      'Click on a Thing, enter a new value in the box below, then press' +
      ' the Commit button.'
    TabOrder = 2
  end
end
