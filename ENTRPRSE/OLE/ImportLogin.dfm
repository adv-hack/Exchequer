object frmExchLogin: TfrmExchLogin
  Left = 455
  Top = 146
  HelpContext = 2
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsNone
  Caption = 'Exchequer Login'
  ClientHeight = 214
  ClientWidth = 357
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  HelpFile = 'EnterOle.Hlp'
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object BackgroundImg: TImage
    Left = 0
    Top = 0
    Width = 357
    Height = 214
    Align = alClient
  end
  object UserLab: TantLabel
    Left = 12
    Top = 105
    Width = 62
    Height = 16
    Active = False
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'User Name'
    Color3d = False
    Color3dXDepth = 0
    Color3dYDepth = 0
    ColorFront.Normal = clBlack
    ColorFront.Selected = clBlue
    ColorFront.Active = clRed
    ColorFront.Disabled = clBtnShadow
    ColorBack.Normal = clBtnShadow
    ColorBack.Selected = clNavy
    ColorBack.Active = clMaroon
    ColorBack.Disabled = clBtnHighlight
    Cursors.Normal = crDefault
    Cursors.Selected = crHandPoint
    Cursors.Active = crHandPoint
    Cursors.Disabled = crDefault
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    HighLight.Normal = True
    HighLight.Selected = False
    HighLight.Active = False
    HighLight.Disabled = True
    HighLightColor.Normal = clWhite
    HighLightColor.Selected = clWhite
    HighLightColor.Active = clWhite
    HighLightColor.Disabled = clBtnHighlight
    HighLightStyle = hlsFull
    ParentFont = False
    Transparent = True
    UnderLine.Normal = False
    UnderLine.Selected = True
    UnderLine.Active = True
    UnderLine.Disabled = False
  end
  object antLabel2: TantLabel
    Left = 16
    Top = 130
    Width = 58
    Height = 16
    Active = False
    Alignment = taRightJustify
    Caption = 'Password'
    Color3d = False
    Color3dXDepth = 0
    Color3dYDepth = 0
    ColorFront.Normal = clBlack
    ColorFront.Selected = clBlue
    ColorFront.Active = clRed
    ColorFront.Disabled = clBtnShadow
    ColorBack.Normal = clBtnShadow
    ColorBack.Selected = clNavy
    ColorBack.Active = clMaroon
    ColorBack.Disabled = clBtnHighlight
    Cursors.Normal = crDefault
    Cursors.Selected = crHandPoint
    Cursors.Active = crHandPoint
    Cursors.Disabled = crDefault
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    HighLight.Normal = True
    HighLight.Selected = False
    HighLight.Active = False
    HighLight.Disabled = True
    HighLightColor.Normal = clWhite
    HighLightColor.Selected = clWhite
    HighLightColor.Active = clWhite
    HighLightColor.Disabled = clBtnHighlight
    HighLightStyle = hlsFull
    ParentFont = False
    Transparent = True
    UnderLine.Normal = False
    UnderLine.Selected = True
    UnderLine.Active = True
    UnderLine.Disabled = False
  end
  object CompLbl: TantLabel
    Left = 79
    Top = 80
    Width = 190
    Height = 16
    Active = False
    AutoSize = False
    Caption = '-- Company Name --'
    Color3d = False
    Color3dXDepth = 0
    Color3dYDepth = 0
    ColorFront.Normal = clBlack
    ColorFront.Selected = clBlue
    ColorFront.Active = clRed
    ColorFront.Disabled = clBtnShadow
    ColorBack.Normal = clBtnShadow
    ColorBack.Selected = clNavy
    ColorBack.Active = clMaroon
    ColorBack.Disabled = clBtnHighlight
    Cursors.Normal = crDefault
    Cursors.Selected = crHandPoint
    Cursors.Active = crHandPoint
    Cursors.Disabled = crDefault
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    HighLight.Normal = True
    HighLight.Selected = False
    HighLight.Active = False
    HighLight.Disabled = True
    HighLightColor.Normal = clWhite
    HighLightColor.Selected = clWhite
    HighLightColor.Active = clWhite
    HighLightColor.Disabled = clBtnHighlight
    HighLightStyle = hlsFull
    ParentFont = False
    Transparent = True
    UnderLine.Normal = False
    UnderLine.Selected = True
    UnderLine.Active = True
    UnderLine.Disabled = False
  end
  object antLabel3: TantLabel
    Left = 20
    Top = 80
    Width = 54
    Height = 16
    Active = False
    Alignment = taRightJustify
    Caption = 'Company'
    Color3d = False
    Color3dXDepth = 0
    Color3dYDepth = 0
    ColorFront.Normal = clBlack
    ColorFront.Selected = clBlue
    ColorFront.Active = clRed
    ColorFront.Disabled = clBtnShadow
    ColorBack.Normal = clBtnShadow
    ColorBack.Selected = clNavy
    ColorBack.Active = clMaroon
    ColorBack.Disabled = clBtnHighlight
    Cursors.Normal = crDefault
    Cursors.Selected = crHandPoint
    Cursors.Active = crHandPoint
    Cursors.Disabled = crDefault
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    HighLight.Normal = True
    HighLight.Selected = False
    HighLight.Active = False
    HighLight.Disabled = True
    HighLightColor.Normal = clWhite
    HighLightColor.Selected = clWhite
    HighLightColor.Active = clWhite
    HighLightColor.Disabled = clBtnHighlight
    HighLightStyle = hlsFull
    ParentFont = False
    Transparent = True
    UnderLine.Normal = False
    UnderLine.Selected = True
    UnderLine.Active = True
    UnderLine.Disabled = False
  end
  object edtUserName: Text8Pt
    Left = 77
    Top = 103
    Width = 108
    Height = 22
    AutoSelect = False
    AutoSize = False
    CharCase = ecUpperCase
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TextId = 0
    ViaSBtn = False
  end
  object edtPassword: Text8Pt
    Left = 77
    Top = 129
    Width = 108
    Height = 22
    AutoSize = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    PasswordChar = '*'
    ShowHint = True
    TabOrder = 1
    TextId = 0
    ViaSBtn = False
  end
  object OkI1Btn: TButton
    Tag = 1
    Left = 190
    Top = 103
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
    OnClick = OkI1BtnClick
  end
  object CanI1Btn: TButton
    Tag = 1
    Left = 190
    Top = 129
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = CanI1BtnClick
  end
end