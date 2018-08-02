object frmDocumentNumbersReport: TfrmDocumentNumbersReport
  Left = 409
  Top = 184
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exchequer Document Numbers Report'
  ClientHeight = 533
  ClientWidth = 860
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    860
    533)
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 155
    Top = 46
    Width = 699
    Height = 15
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'The exported System Settings are shown below, please Email them ' +
      'to us by following the instructions below:-'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 155
    Top = 195
    Width = 686
    Height = 16
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If you do not have access to Email then please contact us to arr' +
      'ange an alternative using your normal support number.'
    WordWrap = True
  end
  object Image1: TImage
    Left = 6
    Top = 8
    Width = 143
    Height = 490
  end
  object imgSide: TImage
    Left = 3
    Top = 374
    Width = 76
    Height = 146
    Visible = False
  end
  object TitleLbl: TLabel
    Left = 156
    Top = 8
    Width = 678
    Height = 28
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Exchequer Document Numbers'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object memExportSettingsOutput: TMemo
    Left = 155
    Top = 230
    Width = 695
    Height = 268
    Anchors = [akLeft, akTop, akRight]
    ScrollBars = ssVertical
    TabOrder = 1
    WordWrap = False
  end
  object btnSaveAs: TButton
    Left = 664
    Top = 505
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'Save As'
    TabOrder = 2
    OnClick = btnSaveAsClick
  end
  object RichEdit1: TRichEdit
    Left = 158
    Top = 69
    Width = 684
    Height = 117
    TabStop = False
    Anchors = [akLeft, akTop, akRight]
    BorderStyle = bsNone
    Color = clBtnFace
    PopupMenu = PopupMenu1
    ReadOnly = True
    TabOrder = 0
  end
  object btnClose: TButton
    Left = 753
    Top = 505
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object panProgress: TPanel
    Left = 258
    Top = 325
    Width = 520
    Height = 69
    TabOrder = 4
    object Label3: TLabel
      Left = 10
      Top = 17
      Width = 500
      Height = 18
      Alignment = taCenter
      AutoSize = False
      Caption = 'Scanning Exchequer Installation, please wait...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
    end
    object lblCompany: TLabel
      Left = 10
      Top = 39
      Width = 500
      Height = 18
      Alignment = taCenter
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ShowAccelChar = False
    end
  end
  object SaveDialog1: TSaveDialog
    FileName = 'Exchequer Document Numbers.xml'
    Filter = 'XML Files|*.XML|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 36
    Top = 20
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 56
    Top = 79
  end
  object PopupMenu1: TPopupMenu
    Left = 92
    Top = 22
    object menuOptCopy: TMenuItem
      Caption = '&Copy'
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 115
    Top = 182
  end
end
