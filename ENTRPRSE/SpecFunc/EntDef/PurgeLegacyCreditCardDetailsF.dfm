inherited PurgeLegacyCreditCardDetailsForm: TPurgeLegacyCreditCardDetailsForm
  Caption = 'Purge Legacy Credit Card Details'
  ClientHeight = 258
  ClientWidth = 356
  FormStyle = fsNormal
  Position = poMainFormCenter
  Visible = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  inherited PageControl1: TPageControl
    Width = 356
    Height = 217
    inherited TabSheet1: TTabSheet
      Caption = 'Credit Card details'
      inherited SBSPanel4: TSBSBackGroup
        Width = 336
        Height = 147
        Caption = 'Apply to :'
      end
      inherited StartBtn: TButton
        Left = 10
        Top = 152
        Visible = False
      end
      object chkCustomers: TCheckBox
        Left = 32
        Top = 36
        Width = 77
        Height = 17
        Caption = 'Customers'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object chkSuppliers: TCheckBox
        Left = 32
        Top = 74
        Width = 73
        Height = 17
        Caption = 'Suppliers'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object chkConsumers: TCheckBox
        Left = 32
        Top = 112
        Width = 77
        Height = 17
        Caption = 'Consumers'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object chkExcludeNameField: TCheckBox
        Left = 120
        Top = 74
        Width = 205
        Height = 17
        Caption = 'Exclude Card Number field (CIS UTR)'
        TabOrder = 4
      end
    end
  end
  inherited OkCP1Btn: TButton
    Left = 168
    Top = 224
  end
  inherited ClsCP1Btn: TButton
    Left = 254
    Top = 224
    OnClick = ClsCP1BtnClick
  end
  inherited TitlePnl: TPanel
    Width = 356
    object lblTitle: TLabel
      Left = 3
      Top = 12
      Width = 377
      Height = 25
      AutoSize = False
      Caption = 'Purge Legacy Credit Card Details'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
