object fmLists: TfmLists
  Left = 103
  Top = 136
  Width = 848
  Height = 536
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Lists'
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
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    000B3B3B3B33330000BB3B3000000000B3B3B3B3333333030BB3303300000003
    3330000000000030BB0B3B3330000003333B8B8383333033BBBB333330000000
    3333333333330B3B3BB33B3B3B0000000B3B3B3333330B3B33B3BBB3330000B3
    B3B3B3B333330B3B333BBB333B0003333000000000000B3B33BBBBB3B3000300
    000B3B3B33330B3B333BB0B33B000030B3B3B3B3B3330B3B333BBBB3B3000303
    3333333333330B33333BBB3B3B000003000B888383830BB33333333BB0000000
    33330000000000B33B3333BB300000033000B3B3B3B3B0BB33330BBB00000000
    0B3B3B3B3B3B3B0BB33B3BB00000000033333333333333300B33330000000000
    3000BBB838383830003000000000000003333380000000000000000000000000
    3338000B3B3B3B3B3B000000000000000330B3B3B3B3B3B3B3B3300000000000
    0003333FFFFFF33333333300000000000003088BBBB3B3B3B300030000000000
    000033333BBBBB3B3B33300000000000000333B3B3BBBBB3B3B3330000000000
    0000333B3BBBBBBB333330000000000000000003B3B3BFFFFB00000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFE003C1FF000000FE0000007C0000003C0000003C0000001C00000018000
    00010000000100000001000000010000000180000003C0000003C0000007E000
    000FE000001FE00000FFE00000FFE000007FF000003FF800001FFC00001FFC00
    001FFC00001FFE00003FFF00007FFFE003FFFFFFFFFFFFFFFFFFFFFFFFFF}
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel15: TPanel
    Left = 0
    Top = 0
    Width = 840
    Height = 502
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel15'
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 540
      Top = 0
      Width = 7
      Height = 460
      Align = alRight
      Beveled = True
    end
    object Panel7: TPanel
      Left = 0
      Top = 0
      Width = 540
      Height = 460
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 10
      Color = clBtnShadow
      TabOrder = 0
      object panCultureName: TPanel
        Left = 10
        Top = 10
        Width = 520
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        Caption = 'THINGS'
        Color = clBtnShadow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsUnderline]
        ParentFont = False
        TabOrder = 0
      end
      object lbThings: TListBox
        Left = 10
        Top = 35
        Width = 520
        Height = 360
        Align = alClient
        Color = clCream
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'SimSun'
        Font.Style = []
        ItemHeight = 13
        Items.Strings = (
          'one'
          'two'
          'three')
        ParentFont = False
        TabOrder = 1
        OnDblClick = lbThingsDblClick
      end
      object Panel3: TPanel
        Left = 10
        Top = 395
        Width = 520
        Height = 55
        Align = alBottom
        BevelOuter = bvNone
        Color = clBtnShadow
        TabOrder = 2
        object btnDelete: TBitBtn
          Left = 104
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Delete'
          Enabled = False
          TabOrder = 0
          OnClick = btnDeleteClick
        end
        object btnView: TBitBtn
          Left = 186
          Top = 4
          Width = 75
          Height = 25
          Caption = 'View'
          TabOrder = 1
          OnClick = btnViewClick
        end
        object btnTrack: TBitBtn
          Left = 268
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Track'
          TabOrder = 2
          OnClick = btnTrackClick
        end
        object btnRefreshAll: TBitBtn
          Left = 0
          Top = 4
          Width = 99
          Height = 25
          Caption = 'Refresh'
          TabOrder = 3
          OnClick = btnRefreshAllClick
        end
        object cbAutoRefresh: TCheckBox
          Left = 2
          Top = 36
          Width = 97
          Height = 17
          Caption = 'Auto Refresh'
          TabOrder = 4
        end
        object cbPlants: TCheckBox
          Left = 106
          Top = 36
          Width = 65
          Height = 17
          Caption = 'Plants'
          TabOrder = 5
        end
        object cbCreatures: TCheckBox
          Left = 162
          Top = 36
          Width = 101
          Height = 17
          Caption = 'Creatures'
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
        object cbClouds: TCheckBox
          Left = 234
          Top = 36
          Width = 63
          Height = 17
          Caption = 'Clouds'
          TabOrder = 7
        end
      end
    end
    object Panel20: TPanel
      Left = 547
      Top = 0
      Width = 293
      Height = 460
      Align = alRight
      BevelOuter = bvNone
      BorderWidth = 10
      Color = clBtnShadow
      TabOrder = 1
      object ToolBar1: TToolBar
        Left = 10
        Top = 332
        Width = 273
        Height = 118
        Align = alBottom
        ButtonHeight = 21
        ButtonWidth = 67
        Caption = 'ToolBar1'
        ShowCaptions = True
        TabOrder = 0
        object tbReality: TToolButton
          Left = 0
          Top = 2
          Caption = 'Reality'
          ImageIndex = 12
          OnClick = tbRealityClick
        end
        object tbSpace: TToolButton
          Left = 67
          Top = 2
          Caption = 'Space'
          ImageIndex = 10
          OnClick = tbSpaceClick
        end
        object tbEnvironment: TToolButton
          Left = 134
          Top = 2
          Caption = 'Environment'
          ImageIndex = 11
          OnClick = tbEnvironmentClick
        end
        object tbExistents: TToolButton
          Left = 201
          Top = 2
          Caption = 'Existents'
          ImageIndex = 4
          Wrap = True
          OnClick = tbExistentsClick
        end
        object tbAttachments: TToolButton
          Left = 0
          Top = 23
          Caption = 'Attachments'
          ImageIndex = 1
          OnClick = tbAttachmentsClick
        end
        object tbReferences: TToolButton
          Left = 67
          Top = 23
          Caption = 'References'
          ImageIndex = 0
          OnClick = tbReferencesClick
        end
        object tbGrids: TToolButton
          Left = 134
          Top = 23
          Caption = 'Grids'
          ImageIndex = 3
          OnClick = tbGridsClick
        end
        object tbCradle: TToolButton
          Left = 201
          Top = 23
          Caption = 'Cradle'
          ImageIndex = 5
          Wrap = True
          OnClick = tbCradleClick
        end
        object tbPurgatory: TToolButton
          Left = 0
          Top = 44
          Caption = 'Purgatory'
          ImageIndex = 6
          OnClick = tbPurgatoryClick
        end
        object tbTrash: TToolButton
          Left = 67
          Top = 44
          Caption = 'Trash'
          ImageIndex = 14
          OnClick = tbTrashClick
        end
        object tbEventQueue: TToolButton
          Left = 134
          Top = 44
          Caption = 'EventQueue'
          ImageIndex = 14
          OnClick = tbEventQueueClick
        end
        object tbEventRound: TToolButton
          Left = 201
          Top = 44
          Caption = 'EventRound'
          ImageIndex = 13
          Wrap = True
          OnClick = tbEventRoundClick
        end
        object tbThings: TToolButton
          Left = 0
          Top = 65
          Caption = 'Things'
          ImageIndex = 9
          OnClick = tbThingsClick
        end
        object tbFruits: TToolButton
          Left = 67
          Top = 65
          Caption = 'Fruits'
          ImageIndex = 10
          OnClick = tbFruitsClick
        end
        object tbPrey: TToolButton
          Left = 134
          Top = 65
          Caption = 'Prey'
          ImageIndex = 11
          OnClick = tbPreyClick
        end
        object tbPredators: TToolButton
          Left = 201
          Top = 65
          Caption = 'Predators'
          ImageIndex = 12
          Wrap = True
          OnClick = tbPredatorsClick
        end
        object tbColliders: TToolButton
          Left = 0
          Top = 86
          Caption = 'Colliders'
          ImageIndex = 14
          OnClick = tbCollidersClick
        end
        object tb3DView: TToolButton
          Left = 67
          Top = 86
          Caption = '3DView'
          ImageIndex = 13
          OnClick = tb3DViewClick
        end
      end
      object redView: TRichEdit
        Left = 10
        Top = 10
        Width = 273
        Height = 322
        Align = alClient
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'ai.planet data viewer'
          '-------------------------------------------'
          'Click on a data structure below to see its contents.')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        WordWrap = False
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 460
      Width = 840
      Height = 42
      Align = alBottom
      Color = clBtnShadow
      TabOrder = 2
      object Panel2: TPanel
        Left = 735
        Top = 1
        Width = 104
        Height = 40
        Align = alRight
        BevelOuter = bvNone
        Color = clBtnShadow
        TabOrder = 0
        object btnClose: TBitBtn
          Left = 14
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Close'
          TabOrder = 0
          OnClick = btnCloseClick
        end
      end
    end
  end
end
