object FrmEditSettingsEnt: TFrmEditSettingsEnt
  Left = 400
  Top = 233
  BorderStyle = bsDialog
  Caption = 'Properties'
  ClientHeight = 324
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 381
    Height = 324
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Visual'
      object Bevel3: TBevel
        Left = 8
        Top = 152
        Width = 273
        Height = 65
        Shape = bsFrame
      end
      object Bevel2: TBevel
        Left = 8
        Top = 80
        Width = 273
        Height = 65
        Shape = bsFrame
      end
      object Bevel1: TBevel
        Left = 8
        Top = 8
        Width = 273
        Height = 65
        Shape = bsFrame
      end
      object lFields: TLabel
        Left = 16
        Top = 19
        Width = 75
        Height = 14
        Caption = 'Fields and Lists'
      end
      object lListHeadings: TLabel
        Left = 16
        Top = 91
        Width = 65
        Height = 14
        Caption = 'List Headings'
      end
      object lHighlightBar: TLabel
        Left = 16
        Top = 163
        Width = 60
        Height = 14
        Caption = 'Highlight Bar'
      end
      object btnCancel: TButton
        Left = 288
        Top = 32
        Width = 80
        Height = 21
        Cancel = True
        Caption = 'C&ancel'
        ModalResult = 2
        TabOrder = 11
      end
      object btnOK: TButton
        Left = 288
        Top = 8
        Width = 80
        Height = 21
        Caption = '&OK'
        ModalResult = 1
        TabOrder = 10
      end
      object btnFieldColour: TButton
        Left = 104
        Top = 16
        Width = 80
        Height = 21
        Caption = 'Background'
        TabOrder = 0
        OnClick = btnFieldColourClick
      end
      object btnFieldFont: TButton
        Left = 192
        Top = 16
        Width = 80
        Height = 21
        Caption = 'Text'
        TabOrder = 1
        OnClick = btnFieldFontClick
      end
      object panFields: TPanel
        Left = 16
        Top = 40
        Width = 257
        Height = 25
        BevelOuter = bvLowered
        Caption = 'ABCDEF...abcdef'
        TabOrder = 2
      end
      object btnHeaderColour: TButton
        Left = 104
        Top = 88
        Width = 80
        Height = 21
        Caption = 'Background'
        Enabled = False
        TabOrder = 3
        OnClick = Button3Click
      end
      object btnHeaderFont: TButton
        Left = 192
        Top = 88
        Width = 80
        Height = 21
        Caption = 'Text'
        TabOrder = 4
        OnClick = btnHeaderFontClick
      end
      object panHeader: TPanel
        Left = 16
        Top = 112
        Width = 257
        Height = 25
        BevelOuter = bvLowered
        Caption = 'ABCDEF...abcdef'
        TabOrder = 5
      end
      object btnHighlightColour: TButton
        Left = 104
        Top = 160
        Width = 80
        Height = 21
        Caption = 'Background'
        TabOrder = 6
        OnClick = btnHighlightColourClick
      end
      object btnHighlightFont: TButton
        Left = 192
        Top = 160
        Width = 80
        Height = 21
        Caption = 'Text'
        TabOrder = 7
        OnClick = btnHighlightFontClick
      end
      object panHighlight: TPanel
        Left = 16
        Top = 184
        Width = 257
        Height = 25
        BevelOuter = bvLowered
        Caption = 'ABCDEF...abcdef'
        TabOrder = 8
      end
      object btnDefaults: TButton
        Left = 288
        Top = 56
        Width = 80
        Height = 21
        Caption = '&Defaults'
        ModalResult = 4
        TabOrder = 12
      end
      object panMultiSelectStuff: TPanel
        Left = 8
        Top = 224
        Width = 273
        Height = 65
        BevelOuter = bvNone
        TabOrder = 9
        object Bevel4: TBevel
          Left = 0
          Top = 0
          Width = 273
          Height = 65
          Align = alClient
          Shape = bsFrame
        end
        object Label4: TLabel
          Left = 8
          Top = 11
          Width = 74
          Height = 14
          Caption = 'Multi Select Bar'
        end
        object btnMultiSelectColour: TButton
          Left = 96
          Top = 8
          Width = 80
          Height = 21
          Caption = 'Background'
          TabOrder = 0
          OnClick = btnMultiSelectColourClick
        end
        object btnMultiSelectFont: TButton
          Left = 184
          Top = 8
          Width = 80
          Height = 21
          Caption = 'Text'
          TabOrder = 1
          OnClick = btnMultiSelectFontClick
        end
        object panMultiSelect: TPanel
          Left = 8
          Top = 32
          Width = 257
          Height = 25
          BevelOuter = bvLowered
          Caption = 'ABCDEF...abcdef'
          TabOrder = 2
        end
      end
    end
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 288
    Top = 120
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Left = 320
    Top = 120
  end
end
