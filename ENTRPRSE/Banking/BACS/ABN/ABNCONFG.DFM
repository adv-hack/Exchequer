object frmAbnConfig: TfrmAbnConfig
  Left = 192
  Top = 133
  BorderStyle = bsDialog
  Caption = 'Configure ABN-Amro'
  ClientHeight = 364
  ClientWidth = 376
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 281
    Height = 353
    ActivePage = tabControl
    TabIndex = 0
    TabOrder = 0
    OnChange = PageControl1Change
    object tabControl: TTabSheet
      Caption = 'Control'
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 257
        Height = 121
        Caption = 'Domestic Payments'
        TabOrder = 0
        object spDomestic: TSpeedButton
          Left = 200
          Top = 82
          Width = 23
          Height = 22
          Caption = '...'
          OnClick = spDomesticClick
        end
        object edtDomesticPay: TLabeledEdit
          Left = 32
          Top = 36
          Width = 129
          Height = 21
          EditLabel.Width = 61
          EditLabel.Height = 13
          EditLabel.Caption = 'Payment GL:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 0
          OnChange = edtDomesticPayChange
        end
        object edtDomesticDir: TLabeledEdit
          Left = 32
          Top = 82
          Width = 169
          Height = 21
          EditLabel.Width = 45
          EditLabel.Height = 13
          EditLabel.Caption = 'Directory:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 1
          OnChange = edtDomesticPayChange
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 136
        Width = 257
        Height = 121
        Caption = 'Foreign Payments'
        TabOrder = 1
        object spForeign: TSpeedButton
          Tag = 1
          Left = 200
          Top = 82
          Width = 23
          Height = 22
          Caption = '...'
          OnClick = spDomesticClick
        end
        object edtForeignPay: TLabeledEdit
          Left = 32
          Top = 36
          Width = 129
          Height = 21
          EditLabel.Width = 61
          EditLabel.Height = 13
          EditLabel.Caption = 'Payment GL:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 0
          OnChange = edtDomesticPayChange
        end
        object edtForeignDir: TLabeledEdit
          Left = 32
          Top = 82
          Width = 169
          Height = 21
          EditLabel.Width = 45
          EditLabel.Height = 13
          EditLabel.Caption = 'Directory:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 1
          OnChange = edtDomesticPayChange
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 264
        Width = 257
        Height = 57
        Caption = 'Payment Description'
        TabOrder = 2
        object edtPayDesc: TEdit
          Left = 32
          Top = 24
          Width = 193
          Height = 21
          TabOrder = 0
          OnChange = edtDomesticPayChange
        end
      end
    end
    object tabBanks: TTabSheet
      Caption = 'Banks'
      ImageIndex = 1
      object Label1: TLabel
        Left = 16
        Top = 10
        Width = 45
        Height = 13
        Caption = 'Bank No:'
      end
      object Panel1: TPanel
        Left = 8
        Top = 40
        Width = 257
        Height = 281
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object edtGL: TLabeledEdit
          Left = 28
          Top = 24
          Width = 81
          Height = 21
          EditLabel.Width = 45
          EditLabel.Height = 13
          EditLabel.Caption = 'GL Code:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 0
          OnChange = edtDomesticPayChange
        end
        object edtSwift: TLabeledEdit
          Left = 148
          Top = 24
          Width = 81
          Height = 21
          EditLabel.Width = 54
          EditLabel.Height = 13
          EditLabel.Caption = 'Swift Code:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 1
          OnChange = edtDomesticPayChange
        end
        object edtBankName: TLabeledEdit
          Left = 28
          Top = 72
          Width = 201
          Height = 21
          EditLabel.Width = 59
          EditLabel.Height = 13
          EditLabel.Caption = 'Bank Name:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 2
          OnChange = edtDomesticPayChange
        end
        object edtBankCountry: TLabeledEdit
          Left = 28
          Top = 152
          Width = 201
          Height = 21
          EditLabel.Width = 39
          EditLabel.Height = 13
          EditLabel.Caption = 'Country:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 4
          OnChange = edtDomesticPayChange
        end
        object edtISOCountry: TLabeledEdit
          Left = 28
          Top = 200
          Width = 81
          Height = 21
          EditLabel.Width = 60
          EditLabel.Height = 13
          EditLabel.Caption = 'ISO Country:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 5
          OnChange = edtDomesticPayChange
        end
        object edtISOCurr: TLabeledEdit
          Left = 148
          Top = 200
          Width = 81
          Height = 21
          EditLabel.Width = 66
          EditLabel.Height = 13
          EditLabel.Caption = 'ISO Currency:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 6
          OnChange = edtDomesticPayChange
        end
        object edtBankAc: TLabeledEdit
          Left = 28
          Top = 248
          Width = 81
          Height = 21
          EditLabel.Width = 60
          EditLabel.Height = 13
          EditLabel.Caption = 'Account No:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 7
          OnChange = edtDomesticPayChange
        end
        object edtExchangeCode: TLabeledEdit
          Left = 148
          Top = 248
          Width = 81
          Height = 21
          EditLabel.Width = 79
          EditLabel.Height = 13
          EditLabel.Caption = 'Exchange Code:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 8
          OnChange = edtDomesticPayChange
        end
        object edtTown: TLabeledEdit
          Left = 28
          Top = 112
          Width = 201
          Height = 21
          EditLabel.Width = 30
          EditLabel.Height = 13
          EditLabel.Caption = 'Town:'
          LabelPosition = lpAbove
          LabelSpacing = 3
          TabOrder = 3
          OnChange = edtDomesticPayChange
        end
      end
      object cbBanks: TComboBox
        Left = 72
        Top = 8
        Width = 57
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        OnChange = cbBanksChange
      end
    end
  end
  object btnSave: TButton
    Left = 296
    Top = 28
    Width = 75
    Height = 25
    Caption = '&Save'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnAdd: TButton
    Left = 296
    Top = 64
    Width = 75
    Height = 25
    Caption = '&Add'
    TabOrder = 2
    Visible = False
    OnClick = btnAddClick
  end
  object Button3: TButton
    Left = 296
    Top = 336
    Width = 75
    Height = 25
    Caption = '&Close'
    TabOrder = 3
    OnClick = Button3Click
  end
end
