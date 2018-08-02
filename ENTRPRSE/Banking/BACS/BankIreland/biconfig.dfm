inherited frmBIConfig: TfrmBIConfig
  HorzScrollBar.Range = 0
  VertScrollBar.Range = 0
  BorderStyle = bsDialog
  Caption = 'Configure Bank of Ireland'
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    inherited Label1: TLabel
      Width = 39
      Caption = 'User ID:'
    end
    inherited Label2: TLabel
      Caption = 
        'Enter your Authorised User ID for the Bank of Ireland'#39's EFT Serv' +
        'ice in the box below.'
    end
  end
end
