object WizTemplate: TWizTemplate
  Left = 626
  Top = 319
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsNone
  Caption = 'Wizard Template'
  ClientHeight = 359
  ClientWidth = 514
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefaultPosOnly
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 31
    Width = 514
    Height = 297
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      TabVisible = False
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      TabVisible = False
    end
  end
  object SBSPanel1: TSBSPanel
    Left = 14
    Top = 63
    Width = 143
    Height = 219
    BevelOuter = bvLowered
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Image1: TImage
      Left = 3
      Top = 4
      Width = 136
      Height = 212
    end
  end
  object WBotPanel: TSBSPanel
    Left = 0
    Top = 328
    Width = 514
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    Purpose = puFrame
    object TWNextBtn: TSBSButton
      Left = 332
      Top = 7
      Width = 80
      Height = 21
      Hint = 
        'Continue with next stage|Move to the next stage of TeleSales ent' +
        'ry.'
      HelpContext = 780
      Caption = '&Next >'
      ModalResult = 1
      TabOrder = 1
      OnClick = TWPrevBtnClick
      TextId = 0
    end
    object TWClsBtn: TSBSButton
      Left = 420
      Top = 7
      Width = 80
      Height = 21
      HelpContext = 62
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
      OnClick = TWClsBtnClick
      TextId = 0
    end
    object TWPrevBtn: TSBSButton
      Left = 248
      Top = 7
      Width = 80
      Height = 21
      Hint = 
        'Return to previous stage|Move to the previous stage of the Wizar' +
        'd..'
      HelpContext = 780
      Caption = '< &Back'
      ModalResult = 1
      TabOrder = 0
      OnClick = TWPrevBtnClick
      TextId = 0
    end
  end
  object WTopPanel: TSBSPanel
    Left = 0
    Top = 0
    Width = 514
    Height = 31
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 3
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label86: Label8
      Left = 16
      Top = 3
      Width = 277
      Height = 26
      AutoSize = False
      Caption = 'Wizard....'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -24
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      TextId = 0
    end
    object Label81: Label8
      Left = 385
      Top = 6
      Width = 117
      Height = 23
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Step x of x        '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TextId = 0
    end
  end
end
