inherited frmAibConfig: TfrmAibConfig
  HorzScrollBar.Range = 0
  VertScrollBar.Range = 0
  BorderStyle = bsDialog
  Caption = 'Configure AIB'
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
        'Enter your Authorised User ID for the Allied Irish Bank'#39's EFT Se' +
        'rvice in the box below.'
    end
  end
end
