inherited frmEbusBeta: TfrmEbusBeta
  Caption = 'frmEbusBeta'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'Beta eBusiness Module'
  end
  inherited InstrLbl: TLabel
    Height = 46
    Caption = 
      'An old Beta of the Exchequer eBusiness Module is in the director' +
      'y being upgraded.  The Beta cannot be upgraded or converted to t' +
      'he latest standard.'
  end
  object Label1: TLabel [4]
    Left = 186
    Top = 121
    Width = 265
    Height = 46
    AutoSize = False
    Caption = 
      'The Beta eBusiness Module will be deleted and its data files rem' +
      'oved.  The current eBusiness Module will be installed with the d' +
      'efault settings.'
    WordWrap = True
  end
  object Label2: TLabel [5]
    Left = 187
    Top = 190
    Width = 264
    Height = 43
    AutoSize = False
    Caption = 
      'The latest eBusiness Module will NOT be installed, and the Beta ' +
      'will be left intact.  NOTE: This may prevent Exchequer from gene' +
      'rating valid XML messages. '
    WordWrap = True
  end
  inherited HelpBtn: TButton
    TabOrder = 3
  end
  inherited Panel1: TPanel
    TabOrder = 2
  end
  inherited ExitBtn: TButton
    TabOrder = 4
  end
  inherited BackBtn: TButton
    TabOrder = 5
  end
  inherited NextBtn: TButton
    TabOrder = 6
  end
  object radRemoveBeta: TRadioButton
    Left = 168
    Top = 102
    Width = 282
    Height = 17
    Caption = 'Remove Beta and Install latest eBusiness Module'
    TabOrder = 0
  end
  object radLeaveBeta: TRadioButton
    Left = 168
    Top = 171
    Width = 282
    Height = 17
    Caption = 'Leave the Beta eBusiness Module Intact'
    TabOrder = 1
  end
end
