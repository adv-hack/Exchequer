object frmTrialBalanceWarning: TfrmTrialBalanceWarning
  Left = 678
  Top = 242
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'WARNING'
  ClientHeight = 419
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial Narrow'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 15
  object SBSPanel1: TSBSPanel
    Left = 7
    Top = 9
    Width = 262
    Height = 290
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 1
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label81: Label8
      Left = 120
      Top = 22
      Width = 62
      Height = 16
      Caption = 'WARNING'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TextId = 0
    end
    object Label82: Label8
      Left = 67
      Top = 43
      Width = 179
      Height = 14
      Alignment = taCenter
      AutoSize = False
      Caption = 'Account Over Credit Limit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
    object Image1: TImage
      Left = 10
      Top = 6
      Width = 53
      Height = 73
    end
    object Label83: Label8
      Left = 10
      Top = 93
      Width = 245
      Height = 190
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
    object SBSPanel2: TSBSPanel
      Left = 66
      Top = 6
      Width = 185
      Height = 77
      TabOrder = 0
      AllowReSize = False
      IsGroupBox = False
      TextId = 0
      object CLMsgL: Label8
        Left = 3
        Top = 30
        Width = 179
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Caption = 'Trial Balance does not balance'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object Label86: Label8
        Left = 4
        Top = 9
        Width = 176
        Height = 16
        Alignment = taCenter
        AutoSize = False
        Caption = 'WARNING'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
      object Label85: Label8
        Left = 3
        Top = 52
        Width = 179
        Height = 14
        Alignment = taCenter
        AutoSize = False
        Caption = 'PLEASE READ BELOW'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TextId = 0
      end
    end
  end
  object OkCP1Btn: TButton
    Tag = 1
    Left = 54
    Top = 392
    Width = 80
    Height = 21
    Caption = '&OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 3
  end
  object CanCP1Btn: TButton
    Tag = 1
    Left = 141
    Top = 392
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 0
  end
  object SBSPanel3: TSBSPanel
    Left = 7
    Top = 306
    Width = 262
    Height = 79
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 2
    AllowReSize = False
    IsGroupBox = False
    TextId = 0
    object Label84: Label8
      Left = 8
      Top = 8
      Width = 245
      Height = 46
      AutoSize = False
      Caption = 
        'Continuing to post with a Trial Balance difference will affect t' +
        'he process time when correcting this difference.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
    object cb1: TBorCheckEx
      Left = 10
      Top = 54
      Width = 248
      Height = 20
      Align = alRight
      Caption = 'Continue Daybook Post with known difference'
      CheckColor = clWindowText
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      TabStop = True
      TextId = 0
      OnClick = cb1Click
    end
  end
end
