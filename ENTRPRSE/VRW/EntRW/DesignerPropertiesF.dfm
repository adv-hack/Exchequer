object frmDesignerProperties: TfrmDesignerProperties
  Left = 354
  Top = 307
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Designer Properties'
  ClientHeight = 102
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TSBSButton
    Left = 234
    Top = 8
    Width = 80
    Height = 21
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 234
    Top = 33
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    TextId = 0
  end
  object btnApply: TSBSButton
    Left = 234
    Top = 65
    Width = 80
    Height = 21
    Caption = '&Apply'
    TabOrder = 3
    OnClick = btnApplyClick
    TextId = 0
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 3
    Width = 221
    Height = 94
    Caption = ' Grid Properties '
    TabOrder = 0
    object Label81: Label8
      Left = 25
      Top = 41
      Width = 139
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Vertical Separation (mm)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 25
      Top = 67
      Width = 139
      Height = 14
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Horizontal Separation (mm)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object chkShowGrid: TBorCheckEx
      Left = 9
      Top = 17
      Width = 85
      Height = 20
      Align = alRight
      Caption = 'Show Grid'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      TextId = 0
    end
    object edtYMM: Text8Pt
      Left = 167
      Top = 38
      Width = 27
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '1'
      TextId = 0
      ViaSBtn = False
    end
    object udYMM: TSBSUpDown
      Left = 194
      Top = 38
      Width = 15
      Height = 22
      Associate = edtYMM
      Min = 1
      Max = 10
      Position = 1
      TabOrder = 2
      Wrap = False
    end
    object edtXMM: Text8Pt
      Left = 167
      Top = 64
      Width = 27
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '1'
      TextId = 0
      ViaSBtn = False
    end
    object udXMM: TSBSUpDown
      Left = 194
      Top = 64
      Width = 15
      Height = 22
      Associate = edtXMM
      Min = 1
      Max = 10
      Position = 1
      TabOrder = 4
      Wrap = False
    end
  end
end
