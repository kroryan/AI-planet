object fmPlanet: TfmPlanet
  Left = 337
  Top = 313
  Width = 334
  Height = 285
  Caption = 'Build Planet'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
    99999999999999999999999999999FFFFFFFFFFFFF88888888888FFFFFF997FF
    FFFFFFFF888888888888888FFFF9977FFFFFFFF8444C444888888888FFF99777
    FFFFFF4444444444488888888FF997777FFF44444C4C4C4C4C48888888F99777
    77F44444443444444444888888F99777774C444C433C4C4C4C4C488888899777
    74444444C334C444C444C48888899777744C4C4C433C4C4C4C4C4C8888899777
    444444C43334CCC4C4C4C44888899777444C4C43333C4C4C4C4C4C3888899774
    4444C4433333CCCCC4CCC433888997744C4C4C4333333C4C4C4C4C3388899774
    4444C43333333CCCCCCCC43388899774444C4C333333CC4CCC4C4C3388899774
    4444C433333CCCCCCCC33333888997744C4C4C334C4C4CCCCCC3333388899774
    44444433CCCC3CCCCCC3333388F99777444C4C433C433C4CCC4C333888F99777
    4444343333333CCCCCCCC4C88FF99777744C333333333C4C4C433C88FFF99777
    7444333333333CCCCCC3348FFFF99777774C333333333C4C3C433FFFFFF99777
    7774333333C333CC3433FFFFFFF9977777774333334C333C4C377FFFFFF99777
    77777744433444C4477777FFFFF99777777777774C4C4C477777777FFFF99777
    777777777777777777777777FFF997777777777777777777777777777FF99777
    77777777777777777777777777F9999999999999999999999999999999990000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 22
    Height = 13
    Caption = 'Core'
  end
  object Label2: TLabel
    Left = 48
    Top = 40
    Width = 7
    Height = 13
    Caption = 'X'
  end
  object Label3: TLabel
    Left = 128
    Top = 40
    Width = 7
    Height = 13
    Caption = 'Y'
  end
  object Label4: TLabel
    Left = 216
    Top = 40
    Width = 7
    Height = 13
    Caption = 'Z'
  end
  object Label5: TLabel
    Left = 16
    Top = 80
    Width = 33
    Height = 13
    Caption = 'Radius'
  end
  object Label6: TLabel
    Left = 24
    Top = 120
    Width = 31
    Height = 13
    Caption = 'Height'
  end
  object Label7: TLabel
    Left = 24
    Top = 152
    Width = 28
    Height = 13
    Caption = 'Width'
  end
  object edX: TEdit
    Left = 64
    Top = 32
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object edY: TEdit
    Left = 144
    Top = 32
    Width = 57
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object edZ: TEdit
    Left = 232
    Top = 32
    Width = 57
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object edRadius: TEdit
    Left = 64
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 3
    Text = '7'
  end
  object edHeight: TEdit
    Left = 64
    Top = 112
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '15'
  end
  object edWidth: TEdit
    Left = 64
    Top = 144
    Width = 121
    Height = 21
    TabOrder = 5
    Text = '30'
  end
  object cbShowBuild: TCheckBox
    Left = 64
    Top = 184
    Width = 97
    Height = 17
    Caption = 'Show Build'
    TabOrder = 6
  end
  object btnOK: TBitBtn
    Left = 232
    Top = 208
    Width = 75
    Height = 25
    TabOrder = 7
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 144
    Top = 208
    Width = 75
    Height = 25
    TabOrder = 8
    Kind = bkCancel
  end
end
