inherited SetCountryCode: TSetCountryCode
  Caption = 'Set Country Code'
  ClientHeight = 270
  ClientWidth = 411
  FormStyle = fsNormal
  Position = poMainFormCenter
  Visible = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  inherited PageControl1: TPageControl
    Width = 411
    Height = 229
    inherited TabSheet1: TTabSheet
      Caption = 'Select Country Code'
      inherited SBSPanel4: TSBSBackGroup
        Height = 167
      end
      object Label2: TLabel [1]
        Left = 20
        Top = 24
        Width = 71
        Height = 14
        Caption = 'Country code :'
      end
      object GroupBox1: TGroupBox [2]
        Left = 20
        Top = 56
        Width = 361
        Height = 101
        Caption = ' Apply to : '
        TabOrder = 7
        object Bevel1: TBevel
          Left = 104
          Top = 20
          Width = 9
          Height = 73
          Shape = bsLeftLine
        end
      end
      inherited StartBtn: TButton
        Top = 176
        Visible = False
      end
      object lstCountry: TSBSComboBox
        Tag = 1
        Left = 100
        Top = 21
        Width = 279
        Height = 22
        HelpContext = 111
        Style = csDropDownList
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        MaxLength = 3
        ParentFont = False
        TabOrder = 1
        ExtendedList = True
        MaxListWidth = 220
        Validate = True
      end
      object chkCustomers: TCheckBox
        Left = 32
        Top = 80
        Width = 77
        Height = 17
        Caption = 'Customers'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object chkSuppliers: TCheckBox
        Left = 32
        Top = 104
        Width = 73
        Height = 17
        Caption = 'Suppliers'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object chkConsumers: TCheckBox
        Left = 32
        Top = 128
        Width = 77
        Height = 17
        Caption = 'Consumers'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
      object chkAllRecords: TRadioButton
        Left = 140
        Top = 80
        Width = 113
        Height = 17
        Caption = 'All records '
        Checked = True
        TabOrder = 5
        TabStop = True
      end
      object RadioButton1: TRadioButton
        Left = 140
        Top = 104
        Width = 237
        Height = 17
        Caption = 'Only records which have no code assigned'
        TabOrder = 6
      end
    end
  end
  inherited OkCP1Btn: TButton
    Top = 240
  end
  inherited ClsCP1Btn: TButton
    Top = 240
    OnClick = ClsCP1BtnClick
  end
  inherited TitlePnl: TPanel
    Width = 411
    object Label1: TLabel
      Left = 3
      Top = 12
      Width = 377
      Height = 25
      AutoSize = False
      Caption = 'Set Country Code'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
