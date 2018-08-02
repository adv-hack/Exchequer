object frmDateAdjust: TfrmDateAdjust
  Left = 298
  Top = 190
  BorderStyle = bsDialog
  Caption = 'Demo Data Date Adjuster v5.71.002'
  ClientHeight = 158
  ClientWidth = 366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 77
    Height = 13
    Caption = 'Select Company'
  end
  object cbCompanies: TComboBox
    Left = 8
    Top = 24
    Width = 265
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object btnGo: TSBSButton
    Left = 280
    Top = 24
    Width = 80
    Height = 21
    Caption = '&Go'
    TabOrder = 1
    OnClick = btnGoClick
    TextId = 0
  end
  object btnClose: TSBSButton
    Left = 280
    Top = 48
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Close'
    TabOrder = 2
    OnClick = btnCloseClick
    TextId = 0
  end
  object Panel1: TPanel
    Left = 8
    Top = 48
    Width = 265
    Height = 105
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    object Label1: TLabel
      Left = 64
      Top = 8
      Width = 5
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 38
      Top = 32
      Width = 88
      Height = 13
      Alignment = taRightJustify
      Caption = 'Transactions read:'
    end
    object lblTotalRecs: TLabel
      Left = 136
      Top = 32
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label4: TLabel
      Left = 18
      Top = 56
      Width = 109
      Height = 13
      Alignment = taRightJustify
      Caption = 'Line Records adjusted:'
    end
    object lblProcessedRecs: TLabel
      Left = 136
      Top = 56
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label5: TLabel
      Left = 10
      Top = 80
      Width = 117
      Height = 13
      Alignment = taRightJustify
      Caption = 'Notes Records adjusted:'
    end
    object lblNotesRecs: TLabel
      Left = 136
      Top = 80
      Width = 6
      Height = 13
      Caption = '0'
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 328
    Top = 104
  end
end
