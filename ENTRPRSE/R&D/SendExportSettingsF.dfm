object frmExportResults: TfrmExportResults
  Left = 773
  Top = 131
  BorderStyle = bsDialog
  Caption = 'Export System Settings'
  ClientHeight = 533
  ClientWidth = 749
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poMainFormCenter
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    749
    533)
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 155
    Top = 46
    Width = 588
    Height = 15
    AutoSize = False
    Caption = 
      'The exported System Settings are shown below, please Email them ' +
      'to us by following the instructions below:-'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 155
    Top = 195
    Width = 575
    Height = 16
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
  object TitleLbl: TLabel
    Left = 156
    Top = 8
    Width = 567
    Height = 28
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Export System Settings'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -21
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object imgSide: TImage
    Left = 3
    Top = 374
    Width = 76
    Height = 146
    Visible = False
  end
  object memExportSettingsOutput: TMemo
    Left = 155
    Top = 230
    Width = 584
    Height = 268
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
  object btnSaveAs: TButton
    Left = 572
    Top = 505
    Width = 80
    Height = 21
    Caption = 'Save As'
    TabOrder = 1
    OnClick = btnSaveAsClick
  end
  object RichEdit1: TRichEdit
    Left = 158
    Top = 69
    Width = 573
    Height = 117
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    PopupMenu = PopupMenu1
    ReadOnly = True
    TabOrder = 2
  end
  object NextBtn: TButton
    Left = 661
    Top = 505
    Width = 80
    Height = 21
    Caption = '&Close'
    TabOrder = 3
    OnClick = NextBtnClick
  end
  object SaveDialog1: TSaveDialog
    FileName = 'Exchequer System Settings.xml'
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
      OnClick = menuOptCopyClick
    end
  end
end
