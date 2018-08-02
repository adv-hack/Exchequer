object SF147SelectionFrm: TSF147SelectionFrm
  Left = 352
  Top = 190
  BorderStyle = bsDialog
  Caption = 'Scan for erroneous Adjustment lines'
  ClientHeight = 246
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object pnlButtons: TPanel
    Left = 0
    Top = 210
    Width = 486
    Height = 36
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      486
      36)
    object btnScan: TButton
      Left = 221
      Top = 8
      Width = 80
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&Scan'
      TabOrder = 0
      OnClick = btnScanClick
    end
    object btnOk: TButton
      Left = 309
      Top = 8
      Width = 80
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&Ok'
      ModalResult = 1
      TabOrder = 1
    end
    object btnCancel: TButton
      Left = 397
      Top = 8
      Width = 80
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 2
      OnClick = btnCancelClick
    end
    object txtRecords: TStaticText
      Left = 4
      Top = 10
      Width = 209
      Height = 18
      Alignment = taRightJustify
      AutoSize = False
      BorderStyle = sbsSunken
      Caption = '0 records scanned '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 486
    Height = 210
    Align = alClient
    BorderWidth = 4
    TabOrder = 1
    DesignSize = (
      486
      210)
    object lblInstructions: TLabel
      Left = 136
      Top = 25
      Width = 337
      Height = 61
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        'Click the Scan button to begin the search for Adjustments with e' +
        'rroneous lines. Once the Adjustments have been found, tick the o' +
        'nes in the list which you want to process, and click OK'
      WordWrap = True
    end
    object Bevel1: TBevel
      Left = 122
      Top = 24
      Width = 9
      Height = 181
      Shape = bsLeftLine
    end
    object lblWarning: TLabel
      Left = 136
      Top = 100
      Width = 52
      Height = 14
      Caption = 'Warnings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lstSelection: TCheckListBox
      Left = 5
      Top = 27
      Width = 110
      Height = 178
      Align = alLeft
      ItemHeight = 14
      TabOrder = 0
    end
    object pnlHeader: TPanel
      Left = 5
      Top = 5
      Width = 476
      Height = 22
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object lblAdjustments: TLabel
        Left = 2
        Top = 6
        Width = 107
        Height = 14
        Caption = 'Adjustments found'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object lstWarning: TListBox
      Left = 136
      Top = 116
      Width = 341
      Height = 89
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 14
      TabOrder = 2
    end
  end
end
