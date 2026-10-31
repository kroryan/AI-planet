object fmDNA: TfmDNA
  Left = 531
  Top = 210
  Width = 393
  Height = 470
  Caption = 'DNA'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 385
    Height = 37
    Align = alTop
    TabOrder = 0
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 68
      Height = 35
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Creature:'
      TabOrder = 0
    end
    object panID: TPanel
      Left = 69
      Top = 1
      Width = 315
      Height = 35
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 'ID'
      TabOrder = 1
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 37
    Width = 385
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 37
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Mutation:'
      TabOrder = 0
    end
    object edMutation: TJvValidateEdit
      Left = 98
      Top = 8
      Width = 173
      Height = 21
      GroupIndex = -1
      MaxPixel.Font.Charset = DEFAULT_CHARSET
      MaxPixel.Font.Color = clWindowText
      MaxPixel.Font.Height = -11
      MaxPixel.Font.Name = 'MS Sans Serif'
      MaxPixel.Font.Style = []
      Modified = False
      SelStart = 0
      SelLength = 0
      PasswordChar = #0
      ReadOnly = False
      TabOrder = 1
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 74
    Width = 385
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel7: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 37
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Buoyancy:'
      TabOrder = 0
    end
    object edBuoyancy: TJvValidateEdit
      Left = 98
      Top = 8
      Width = 173
      Height = 21
      GroupIndex = -1
      MaxPixel.Font.Charset = DEFAULT_CHARSET
      MaxPixel.Font.Color = clWindowText
      MaxPixel.Font.Height = -11
      MaxPixel.Font.Name = 'MS Sans Serif'
      MaxPixel.Font.Style = []
      Modified = False
      SelStart = 0
      SelLength = 0
      PasswordChar = #0
      ReadOnly = False
      TabOrder = 1
    end
  end
  object Panel12: TPanel
    Left = 0
    Top = 148
    Width = 385
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Panel13: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 37
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Preferred Food:'
      TabOrder = 0
    end
    object edPreferredFood: TJvValidateEdit
      Left = 100
      Top = 8
      Width = 71
      Height = 21
      Alignment = taRightJustify
      ReadOnly = False
      TabOrder = 1
      Value = 0
      MaxValue = 0
      MinValue = 0
      HasMaxValue = False
      HasMinValue = False
    end
  end
  object panButtonBar: TPanel
    Left = 0
    Top = 375
    Width = 385
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 4
    object panOKButton: TPanel
      Left = 280
      Top = 1
      Width = 104
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK: TBitBtn
        Left = 18
        Top = 8
        Width = 75
        Height = 25
        TabOrder = 0
        OnClick = btnOKClick
        Kind = bkOK
      end
    end
    object btnCancel: TBitBtn
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      OnClick = btnCancelClick
      Kind = bkCancel
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 111
    Width = 385
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object Panel8: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 37
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Bounce:'
      TabOrder = 0
    end
    object edBounce: TJvValidateEdit
      Left = 98
      Top = 8
      Width = 173
      Height = 21
      GroupIndex = -1
      MaxPixel.Font.Charset = DEFAULT_CHARSET
      MaxPixel.Font.Color = clWindowText
      MaxPixel.Font.Height = -11
      MaxPixel.Font.Name = 'MS Sans Serif'
      MaxPixel.Font.Style = []
      Modified = False
      SelStart = 0
      SelLength = 0
      PasswordChar = #0
      ReadOnly = False
      TabOrder = 1
    end
  end
  object Panel9: TPanel
    Left = 0
    Top = 259
    Width = 385
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 6
    object Panel10: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 37
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Green:'
      TabOrder = 0
    end
    object edGreen: TJvValidateEdit
      Left = 98
      Top = 8
      Width = 173
      Height = 21
      GroupIndex = -1
      MaxPixel.Font.Charset = DEFAULT_CHARSET
      MaxPixel.Font.Color = clWindowText
      MaxPixel.Font.Height = -11
      MaxPixel.Font.Name = 'MS Sans Serif'
      MaxPixel.Font.Style = []
      Modified = False
      SelStart = 0
      SelLength = 0
      PasswordChar = #0
      ReadOnly = False
      TabOrder = 1
    end
  end
  object Panel11: TPanel
    Left = 0
    Top = 222
    Width = 385
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 7
    object Panel14: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 37
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Blue:'
      TabOrder = 0
    end
    object edBlue: TJvValidateEdit
      Left = 98
      Top = 8
      Width = 173
      Height = 21
      GroupIndex = -1
      MaxPixel.Font.Charset = DEFAULT_CHARSET
      MaxPixel.Font.Color = clWindowText
      MaxPixel.Font.Height = -11
      MaxPixel.Font.Name = 'MS Sans Serif'
      MaxPixel.Font.Style = []
      Modified = False
      SelStart = 0
      SelLength = 0
      PasswordChar = #0
      ReadOnly = False
      TabOrder = 1
    end
  end
  object Panel15: TPanel
    Left = 0
    Top = 185
    Width = 385
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 8
    object Panel16: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 37
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Red:'
      TabOrder = 0
    end
    object edRed: TJvValidateEdit
      Left = 98
      Top = 8
      Width = 173
      Height = 21
      GroupIndex = -1
      MaxPixel.Font.Charset = DEFAULT_CHARSET
      MaxPixel.Font.Color = clWindowText
      MaxPixel.Font.Height = -11
      MaxPixel.Font.Name = 'MS Sans Serif'
      MaxPixel.Font.Style = []
      Modified = False
      SelStart = 0
      SelLength = 0
      PasswordChar = #0
      ReadOnly = False
      TabOrder = 1
    end
  end
  object Panel17: TPanel
    Left = 0
    Top = 334
    Width = 385
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 9
    object btnLoadDNA: TBitBtn
      Left = 10
      Top = 6
      Width = 109
      Height = 25
      Caption = 'Load DNA File'
      TabOrder = 0
      OnClick = LoadDNA1Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
        333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
        0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
        07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
        07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
        0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
        B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
        3BB33773333773333773B333333B3333333B7333333733333337}
      NumGlyphs = 2
    end
    object btnSaveDNA: TBitBtn
      Left = 128
      Top = 6
      Width = 111
      Height = 25
      Caption = 'Save DNA File'
      TabOrder = 1
      OnClick = SaveDNA1Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
        7700333333337777777733333333008088003333333377F73377333333330088
        88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
        000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
        FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
        99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
    end
  end
  object Panel18: TPanel
    Left = 0
    Top = 296
    Width = 385
    Height = 37
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 10
    object Panel19: TPanel
      Left = 0
      Top = 0
      Width = 93
      Height = 37
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Lifespan:'
      TabOrder = 0
    end
    object edLifespan: TJvValidateEdit
      Left = 100
      Top = 8
      Width = 71
      Height = 21
      Alignment = taRightJustify
      ReadOnly = False
      TabOrder = 1
      Value = 0
      MaxValue = 0
      MinValue = 0
      HasMaxValue = False
      HasMinValue = False
    end
  end
  object OpenDNADialog: TOpenDialog
    Left = 120
    Top = 5
  end
  object SaveDNADialog: TSaveDialog
    Left = 88
    Top = 5
  end
  object MainMenu1: TMainMenu
    Left = 152
    Top = 6
    object File1: TMenuItem
      Caption = '&File'
      object LoadDNA1: TMenuItem
        Caption = '&Load DNA'
        OnClick = LoadDNA1Click
      end
      object SaveDNA1: TMenuItem
        Caption = '&Save DNA'
        OnClick = SaveDNA1Click
      end
    end
  end
end
