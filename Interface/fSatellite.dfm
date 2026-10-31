object fmSatellite: TfmSatellite
  Left = 411
  Top = 200
  Width = 345
  Height = 393
  Caption = 'Satellite'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object panDescription: TPanel
    Left = 0
    Top = 0
    Width = 337
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Label1: TLabel
      Left = 150
      Top = 8
      Width = 135
      Height = 13
      Caption = 'Intensity of effect per round,.'
    end
    object panRate: TPanel
      Left = 0
      Top = 0
      Width = 100
      Height = 29
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Rate:'
      ParentColor = True
      TabOrder = 0
    end
    object edRate: TEdit
      Left = 102
      Top = 4
      Width = 39
      Height = 21
      TabOrder = 1
      Text = '1'
      OnChange = edRateChange
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 58
    Width = 337
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object Label3: TLabel
      Left = 150
      Top = 8
      Width = 155
      Height = 13
      Caption = 'Rate of movement in clock ticks.'
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 100
      Height = 29
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Movement:'
      ParentColor = True
      TabOrder = 0
    end
    object edMovement: TEdit
      Left = 102
      Top = 4
      Width = 39
      Height = 21
      TabOrder = 1
      Text = '25'
      OnChange = edMovementChange
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 29
    Width = 337
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Label2: TLabel
      Left = 150
      Top = 8
      Width = 87
      Height = 13
      Caption = 'Distance of effect.'
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 100
      Height = 29
      Align = alLeft
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 5
      Caption = 'Radius:'
      ParentColor = True
      TabOrder = 0
    end
    object edRadius: TEdit
      Left = 102
      Top = 4
      Width = 39
      Height = 21
      TabOrder = 1
      Text = '5'
      OnChange = edRadiusChange
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 87
    Width = 337
    Height = 89
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 3
    object rgDirection: TRadioGroup
      Left = 46
      Top = 5
      Width = 202
      Height = 79
      Align = alClient
      Caption = 'Direction:'
      Columns = 2
      ItemIndex = 2
      Items.Strings = (
        'Up'
        'Down'
        'Left'
        'Right')
      TabOrder = 0
      OnClick = rgDirectionClick
    end
    object Panel6: TPanel
      Left = 5
      Top = 5
      Width = 41
      Height = 79
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
    end
    object Panel7: TPanel
      Left = 248
      Top = 5
      Width = 84
      Height = 79
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
    end
  end
  object panButtonBar: TPanel
    Left = 0
    Top = 318
    Width = 337
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 4
    object panOKButton: TPanel
      Left = 232
      Top = 1
      Width = 104
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK: TBitBtn
        Left = 10
        Top = 8
        Width = 75
        Height = 25
        TabOrder = 0
        OnClick = btnOKClick
        Kind = bkOK
      end
    end
  end
  object Panel8: TPanel
    Left = 0
    Top = 176
    Width = 337
    Height = 142
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 5
    object Label4: TLabel
      Left = 24
      Top = 16
      Width = 45
      Height = 13
      Caption = 'Epicenter'
    end
    object Label5: TLabel
      Left = 48
      Top = 40
      Width = 7
      Height = 13
      Caption = 'X'
    end
    object Label6: TLabel
      Left = 128
      Top = 40
      Width = 7
      Height = 13
      Caption = 'Y'
    end
    object Label7: TLabel
      Left = 216
      Top = 40
      Width = 7
      Height = 13
      Caption = 'Z'
    end
    object Label8: TLabel
      Left = 16
      Top = 80
      Width = 20
      Height = 13
      Caption = 'Size'
    end
    object Label9: TLabel
      Left = 16
      Top = 108
      Width = 42
      Height = 13
      Caption = 'Distance'
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
    object edSize: TEdit
      Left = 64
      Top = 72
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '2'
    end
    object edDistance: TEdit
      Left = 64
      Top = 100
      Width = 121
      Height = 21
      TabOrder = 4
      Text = '5'
    end
  end
end
