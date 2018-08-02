inherited frmEntOptions: TfrmEntOptions
  Left = 309
  Top = 159
  ActiveControl = nil
  Caption = 'Exchequer Setup Program'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Top = 245
    Height = 6
  end
  inherited TitleLbl: TLabel
    Caption = 'Setup Options'
  end
  inherited InstrLbl: TLabel
    Height = 19
    Caption = 'Please select the optional modules you want to install:'
  end
  object ScrollBox1: TScrollBox
    Left = 169
    Top = 73
    Width = 289
    Height = 164
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    object Label1: TLabel
      Left = 5
      Top = 31
      Width = 274
      Height = 67
      AutoSize = False
      Caption = 
        'The Development Department apologises for any inconvience caused' +
        ' by this ongoing development. If you have complaints please call' +
        ' the Development Hotline on Internal 223.'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 6
      Top = 7
      Width = 258
      Height = 13
      Caption = 'Development Here for 4 weeks - completion Spring 01.'
    end
  end
end
