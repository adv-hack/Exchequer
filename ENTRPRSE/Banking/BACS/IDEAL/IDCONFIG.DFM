inherited frmIdealConfig: TfrmIdealConfig
  HorzScrollBar.Range = 0
  VertScrollBar.Range = 0
  BorderStyle = bsDialog
  Caption = 'Configure IDEAL'
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    inherited Label1: TLabel
      Width = 61
      Caption = 'Company ID:'
    end
    inherited Label2: TLabel
      Caption = 
        'Enter your Company ID (the ID under which you log into IDEAL) in' +
        'to the box below.'
    end
  end
end
