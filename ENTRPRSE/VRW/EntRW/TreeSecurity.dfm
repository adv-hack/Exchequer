object frmSecurity: TfrmSecurity
  Left = 361
  Top = 245
  Width = 467
  Height = 209
  ActiveControl = vleUserRights
  BorderIcons = [biSystemMenu]
  Caption = 'Report Security'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object lblInfo: TLabel
    Left = 7
    Top = 4
    Width = 357
    Height = 34
    AutoSize = False
    Caption = 'Label1'
    WordWrap = True
  end
  object btnOK: TButton
    Left = 372
    Top = 40
    Width = 80
    Height = 21
    Caption = 'OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 372
    Top = 65
    Width = 80
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 2
  end
  object vleUserRights: TValueListEditor
    Left = 5
    Top = 40
    Width = 360
    Height = 128
    DisplayOptions = [doAutoColResize, doKeyColFixed]
    Options = [goHorzLine, goColSizing, goEditing, goAlwaysShowEditor, goThumbTracking]
    Strings.Strings = (
      '')
    TabOrder = 0
    TitleCaptions.Strings = (
      'User Id'
      'Permissions')
    OnKeyDown = vleUserRightsKeyDown
    ColWidths = (
      150
      204)
  end
  object btnHideAll: TButton
    Left = 372
    Top = 97
    Width = 80
    Height = 21
    Caption = '&Hide All'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnHideAllClick
  end
  object btnShowAll: TButton
    Left = 372
    Top = 122
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Show All'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnShowAllClick
  end
  object btnPrintAll: TButton
    Left = 372
    Top = 147
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Print All'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnPrintAllClick
  end
end
