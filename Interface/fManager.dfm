object fmManager: TfmManager
  Left = 470
  Top = 107
  Align = alLeft
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Views'
  ClientHeight = 530
  ClientWidth = 146
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 146
    Height = 225
    Align = alTop
    BevelOuter = bvLowered
    BorderWidth = 10
    TabOrder = 0
    object Panel2: TPanel
      Left = 11
      Top = 11
      Width = 124
      Height = 25
      Align = alTop
      BevelOuter = bvLowered
      Caption = 'Reality'
      Color = clActiveBorder
      TabOrder = 0
    end
    object ToolBar1: TToolBar
      Left = 11
      Top = 36
      Width = 124
      Height = 178
      Align = alClient
      ButtonWidth = 128
      Caption = 'ToolBar1'
      EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
      Flat = True
      Images = fmImages.imgIcons
      List = True
      ShowCaptions = True
      TabOrder = 1
      object tbTime: TToolButton
        Left = 0
        Top = 0
        Hint = 'Time'
        Caption = 'Time                          '
        Down = True
        ImageIndex = 38
        ParentShowHint = False
        Wrap = True
        ShowHint = True
        OnClick = tbTimeClick
      end
      object tbSpace: TToolButton
        Left = 0
        Top = 22
        Hint = 'Space View'
        Caption = 'Space'
        ImageIndex = 63
        ParentShowHint = False
        Wrap = True
        ShowHint = True
        Style = tbsCheck
        OnClick = tbSpaceClick
      end
      object tbPopulations: TToolButton
        Left = 0
        Top = 44
        Caption = 'Populations'
        ImageIndex = 117
        Wrap = True
        Style = tbsCheck
        OnClick = tbPopulationsClick
      end
      object tbHeightField: TToolButton
        Left = 0
        Top = 66
        Caption = 'Temperature'
        ImageIndex = 77
        Wrap = True
        Style = tbsCheck
        OnClick = tbHeightFieldClick
      end
      object tbHumidityMap: TToolButton
        Left = 0
        Top = 88
        Caption = 'Humidity'
        ImageIndex = 57
        Wrap = True
        Style = tbsCheck
        OnClick = tbHumidityMapClick
      end
      object tbConstruction: TToolButton
        Left = 0
        Top = 110
        Caption = 'Construction'
        ImageIndex = 40
        Wrap = True
        Style = tbsCheck
        OnClick = tbConstructionClick
      end
      object tbLists: TToolButton
        Left = 0
        Top = 132
        Hint = 'Lists Window'
        Caption = 'Lists'
        ImageIndex = 26
        ParentShowHint = False
        Wrap = True
        ShowHint = True
        Style = tbsCheck
        OnClick = tbListsClick
      end
      object tbEvents: TToolButton
        Left = 0
        Top = 154
        Hint = 'Events Window'
        Caption = 'Events'
        ImageIndex = 30
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbEventsClick
      end
    end
  end
  object panSpirits: TPanel
    Left = 0
    Top = 225
    Width = 146
    Height = 305
    Align = alClient
    BevelOuter = bvLowered
    BorderWidth = 10
    TabOrder = 1
    object Panel1: TPanel
      Left = 11
      Top = 11
      Width = 124
      Height = 25
      Align = alTop
      BevelOuter = bvLowered
      Caption = 'Views'
      Color = clInactiveBorder
      TabOrder = 0
    end
    object tbSpirits: TToolBar
      Left = 11
      Top = 36
      Width = 124
      Height = 232
      Align = alClient
      ButtonWidth = 43
      Caption = 'tbSpirits'
      EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
      Flat = True
      Images = fmImages.imgIcons
      List = True
      ShowCaptions = True
      TabOrder = 1
    end
    object Panel4: TPanel
      Left = 11
      Top = 268
      Width = 124
      Height = 26
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object btnAddThing: TBitBtn
        Left = 0
        Top = 0
        Width = 123
        Height = 25
        Caption = 'View Target'
        TabOrder = 0
        OnClick = btnAddThingClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333333333333333333333FFFFF3333333333CCCCC33
          33333FFFF77777FFFFFFCCCCCC808CCCCCC377777737F777777F008888070888
          8003773FFF7773FFF77F0F0770F7F0770F037F777737F777737F70FFFFF7FFFF
          F07373F3FFF7F3FFF37F70F000F7F000F07337F77737F777373330FFFFF7FFFF
          F03337FF3FF7F3FF37F3370F00F7F00F0733373F7737F77337F3370FFFF7FFFF
          0733337F33373F337333330FFF030FFF03333373FF7373FF7333333000333000
          3333333777333777333333333333333333333333333333333333333333333333
          3333333333333333333333333333333333333333333333333333}
        NumGlyphs = 2
      end
    end
  end
end
