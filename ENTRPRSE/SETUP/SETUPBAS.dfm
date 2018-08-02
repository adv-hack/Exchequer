object SetupTemplate: TSetupTemplate
  Left = 195
  Top = 112
  ActiveControl = NextBtn
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Setup Form Template'
  ClientHeight = 285
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    463
    285)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 12
    Top = 240
    Width = 440
    Height = 11
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
  end
  object TitleLbl: TLabel
    Left = 167
    Top = 10
    Width = 288
    Height = 28
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Dialog Title'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object InstrLbl: TLabel
    Left = 167
    Top = 49
    Width = 285
    Height = 30
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Instructions...'
    WordWrap = True
  end
  object imgSide: TImage
    Left = 5
    Top = 116
    Width = 76
    Height = 129
    Anchors = [akLeft, akTop, akBottom]
    Visible = False
  end
  object HelpBtn: TButton
    Left = 13
    Top = 257
    Width = 79
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = '&Help'
    TabOrder = 1
    OnClick = HelpBtnClick
  end
  object Panel1: TPanel
    Left = 12
    Top = 15
    Width = 145
    Height = 223
    Anchors = [akLeft, akTop, akBottom]
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      145
      223)
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 143
      Height = 221
      Anchors = [akLeft, akTop, akBottom]
    end
  end
  object ExitBtn: TButton
    Left = 100
    Top = 257
    Width = 79
    Height = 23
    Anchors = [akLeft, akBottom]
    Caption = 'E&xit Installation'
    TabOrder = 2
    OnClick = ExitBtnClick
  end
  object BackBtn: TButton
    Left = 286
    Top = 257
    Width = 79
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '<< &Back'
    TabOrder = 3
    OnClick = BackBtnClick
  end
  object NextBtn: TButton
    Left = 372
    Top = 257
    Width = 79
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '&Next >>'
    TabOrder = 4
    OnClick = NextBtnClick
  end
end
