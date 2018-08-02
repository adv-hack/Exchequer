inherited frmAutopayConfig: TfrmAutopayConfig
  HorzScrollBar.Range = 0
  VertScrollBar.Range = 0
  BorderStyle = bsDialog
  Caption = 'Configure Autopay'
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    inherited Label1: TLabel
      Width = 130
      Caption = 'User-Defined Field Number:'
    end
    inherited Label2: TLabel
      Height = 57
      Caption = 
        'From the list below, select the number of the User-Defined field' +
        ' you are using to store Bank Ref numbers.'
    end
    inherited edtVal: TEdit
      MaxLength = 1
      OnChange = edtValChange
      OnExit = edtValExit
    end
    object cbUDF: TComboBox
      Left = 8
      Top = 80
      Width = 161
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = '1'
      OnChange = cbUDFChange
      Items.Strings = (
        '1'
        '2'
        '3'
        '4')
    end
  end
end
