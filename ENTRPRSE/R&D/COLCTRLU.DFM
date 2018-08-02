object ColourCtrl: TColourCtrl
  Left = 590
  Top = 251
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'User Preferences'
  ClientHeight = 234
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 1
    Width = 355
    Height = 232
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Visual'
      object Panel1: TPanel
        Left = 2
        Top = 3
        Width = 266
        Height = 65
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label1: TLabel
          Left = 9
          Top = 13
          Width = 72
          Height = 13
          Caption = 'Fields and Lists'
        end
        object Button1: TButton
          Tag = 1
          Left = 94
          Top = 6
          Width = 80
          Height = 25
          Caption = 'Background'
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TButton
          Tag = 1
          Left = 177
          Top = 6
          Width = 80
          Height = 25
          Caption = 'Text'
          TabOrder = 1
          OnClick = Button2Click
        end
        object SBSPanel1: TSBSPanel
          Left = 8
          Top = 34
          Width = 249
          Height = 25
          BevelOuter = bvLowered
          Caption = 'ABCDEF...abcdef'
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = Button1Click
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
        end
      end
      object Panel2: TPanel
        Left = 2
        Top = 70
        Width = 266
        Height = 65
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        object Label2: TLabel
          Left = 9
          Top = 13
          Width = 67
          Height = 13
          Caption = 'List  Headings'
        end
        object Button3: TButton
          Tag = 2
          Left = 94
          Top = 6
          Width = 80
          Height = 25
          Caption = 'Background'
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button4: TButton
          Tag = 2
          Left = 177
          Top = 6
          Width = 80
          Height = 25
          Caption = 'Text'
          TabOrder = 1
          OnClick = Button2Click
        end
        object SBSPanel2: TSBSPanel
          Left = 8
          Top = 34
          Width = 249
          Height = 25
          BevelOuter = bvLowered
          Caption = 'ABCDEF...abcdef'
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = Button1Click
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
        end
      end
      object Panel3: TPanel
        Left = 2
        Top = 138
        Width = 266
        Height = 65
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 2
        object Label3: TLabel
          Left = 9
          Top = 13
          Width = 60
          Height = 13
          Caption = 'Highlight Bar'
        end
        object Button5: TButton
          Tag = 3
          Left = 94
          Top = 6
          Width = 80
          Height = 25
          Caption = 'Background'
          TabOrder = 0
          OnClick = Button1Click
        end
        object SBSPanel3: TSBSPanel
          Left = 8
          Top = 34
          Width = 249
          Height = 25
          BevelOuter = bvLowered
          Caption = 'ABCDEF...abcdef'
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = Button1Click
          AllowReSize = False
          IsGroupBox = False
          TextId = 0
        end
        object Button6: TButton
          Tag = 3
          Left = 177
          Top = 6
          Width = 80
          Height = 25
          Caption = 'Text'
          TabOrder = 2
          OnClick = Button2Click
        end
      end
    end
  end
  object PropOkBtn: TButton
    Left = 274
    Top = 30
    Width = 75
    Height = 23
    Hint = 'OK!|Apply Colour & Font changes'
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = PropOkBtnClick
  end
  object PropCanBtn: TButton
    Left = 274
    Top = 56
    Width = 75
    Height = 23
    Hint = 'Cancel any Colour/Font changes'
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = PropOkBtnClick
  end
  object PropDefaultBtn: TButton
    Left = 274
    Top = 84
    Width = 75
    Height = 23
    Hint = 'Restore the default settings for this form'
    Cancel = True
    Caption = '&Defaults'
    TabOrder = 3
    OnClick = PropOkBtnClick
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 180
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 208
  end
  object PopupMenu1: TPopupMenu
    Left = 300
    Top = 149
    object PropFlg: TMenuItem
      Caption = '&Properties'
      Hint = 'Access Colour & Font settings'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StoreCoordFlg: TMenuItem
      Caption = '&Save Coordinates'
      Hint = 'Make the current window settings permanent'
    end
  end
end
