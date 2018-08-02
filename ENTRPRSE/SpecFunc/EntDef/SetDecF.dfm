object SetDecFrm: TSetDecFrm
  Left = 401
  Top = 114
  Width = 420
  Height = 243
  Caption = 'Special Function 115'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
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
      Caption = 'Quantity Decimal Places'
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
    object TabSheet1: TTabSheet
      Caption = 'Set Decimal Places'
      object SBSPanel4: TSBSBackGroup
        Left = 5
        Top = 2
        Width = 390
        Height = 109
        TextId = 0
      end
      object Label2: TLabel
        Left = 17
        Top = 15
        Width = 361
        Height = 34
        AutoSize = False
        Caption = 
          'Please enter the number of decimal places that should be checked' +
          ' for non-zero quantities.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object lblQtyDecPlaces: TLabel
        Left = 116
        Top = 68
        Width = 73
        Height = 13
        Caption = 'Decimal Places'
      end
      object StartBtn: TButton
        Tag = 1
        Left = 96
        Top = 156
        Width = 80
        Height = 21
        Caption = '&Start Test'
        TabOrder = 0
        Visible = False
      end
      object edtQtyDecPlaces: TMaskEdit
        Left = 196
        Top = 64
        Width = 16
        Height = 21
        EditMask = '0;1; '
        MaxLength = 1
        TabOrder = 1
        Text = '0'
      end
      object spinQtyDecPlaces: TUpDown
        Left = 212
        Top = 64
        Width = 16
        Height = 21
        Associate = edtQtyDecPlaces
        Min = 0
        Position = 0
        TabOrder = 2
        Wrap = False
      end
      object OkCP1Btn: TButton
        Tag = 1
        Left = 228
        Top = 115
        Width = 80
        Height = 21
        Caption = '&OK'
        ModalResult = 1
        TabOrder = 3
      end
      object ClsCP1Btn: TButton
        Left = 312
        Top = 115
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 4
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
