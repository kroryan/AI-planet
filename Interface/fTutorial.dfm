object fmTutorial: TfmTutorial
  Left = 325
  Top = 87
  Width = 442
  Height = 591
  Caption = 'Tutorial'
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
    Left = 0
    Top = 0
    Width = 434
    Height = 41
    Align = alTop
    Caption = 'Tutorial'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 434
    Height = 475
    Align = alClient
    BorderWidth = 10
    TabOrder = 1
    object redIntro: TRichEdit
      Left = 11
      Top = 11
      Width = 412
      Height = 453
      Align = alClient
      Lines.Strings = (
        
          'Your planet is a habitat for artificial intelligence to live on.' +
          '  '
        
          'To create a planet, you will need water, land, a sun, and food. ' +
          ' When you start'
        
          'a new reality, your planet is covered in water.  You will have t' +
          'o clear some'
        
          'water away, to make land.   After this is done, you should add s' +
          'ome trees.'
        ''
        ''
        'First Steps:'
        '---------------------------'
        ''
        '1) Click on the Galaxy Menu'
        '- add a Sun'
        '- add a moon'
        ''
        '2) Click on the Land Menu'
        '- add some Dirt squares'
        '- add some Field/Grass/etc squares'
        ''
        '3) Click on the Fauna Menu'
        '- add some Apple seeds'
        '- add some Orange seeds'
        ''
        '4) Click on the Creatures Menu'
        '- add some Birds'
        '- add some Fish'
        ''
        '5) Experiment'
        '- add other Creatures'
        '- add Beacons to make rivers'
        '- Load other worlds'
        '- Save your world'
        ''
        
          'Now that you have a basic galaxy made, you can let it run and wa' +
          'tch it grow.'
        '')
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 516
    Width = 434
    Height = 41
    Align = alBottom
    TabOrder = 2
    object Panel4: TPanel
      Left = 324
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
end
