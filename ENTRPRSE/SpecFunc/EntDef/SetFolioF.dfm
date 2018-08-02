object SetFolioFrm: TSetFolioFrm
  Left = 341
  Top = 114
  Width = 420
  Height = 243
  Caption = 'Set Folio Number'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object TitlePnl: TPanel
    Left = 0
    Top = 0
    Width = 412
    Height = 41
    Align = alTop
    Color = clWhite
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 12
      Width = 377
      Height = 25
      AutoSize = False
      Caption = 'Folio Number'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 41
    Width = 412
    Height = 168
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 1
    TabStop = False
    object TabSheet1: TTabSheet
      Caption = 'Set Folio Number'
      object SBSPanel4: TSBSBackGroup
        Left = 5
        Top = 2
        Width = 390
        Height = 109
        TextId = 0
      end
      object Label2: TLabel
        Left = 17
        Top = 24
        Width = 361
        Height = 25
        AutoSize = False
        Caption = 'Please enter the new folio number.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object lblNewFolioNumber: TLabel
        Left = 68
        Top = 84
        Width = 88
        Height = 14
        Caption = 'New Folio Number'
      end
      object lblExistingFolioNumber: TLabel
        Left = 54
        Top = 60
        Width = 102
        Height = 14
        Caption = 'Existing Folio Number'
      end
      object IncBtn: TSpeedButton
        Left = 252
        Top = 81
        Width = 23
        Height = 11
        Caption = 't'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Marlett'
        Font.Style = []
        Layout = blGlyphTop
        ParentFont = False
        OnClick = IncBtnClick
      end
      object DecBtn: TSpeedButton
        Left = 252
        Top = 91
        Width = 23
        Height = 10
        Caption = 'u'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Marlett'
        Font.Style = []
        Layout = blGlyphBottom
        ParentFont = False
        OnClick = DecBtnClick
      end
      object lblError: TLabel
        Left = 8
        Top = 116
        Width = 3
        Height = 14
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edtFolioNumber: TMaskEdit
        Left = 160
        Top = 80
        Width = 89
        Height = 22
        AutoSize = False
        EditMask = '!-9999999999;1; '
        MaxLength = 11
        TabOrder = 0
        Text = '-          '
        OnChange = edtFolioNumberChange
        OnExit = edtFolioNumberExit
      end
      object OkCP1Btn: TButton
        Tag = 1
        Left = 228
        Top = 115
        Width = 80
        Height = 21
        Caption = '&OK'
        ModalResult = 1
        TabOrder = 1
        OnClick = OkCP1BtnClick
      end
      object ClsCP1Btn: TButton
        Left = 312
        Top = 115
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 2
      end
      object txtExistingFolioNumber: TStaticText
        Left = 160
        Top = 60
        Width = 92
        Height = 17
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '0'
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      TabVisible = False
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      TabVisible = False
    end
  end
end
