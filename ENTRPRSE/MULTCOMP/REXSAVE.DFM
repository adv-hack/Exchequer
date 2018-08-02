inherited Form_REXWarn: TForm_REXWarn
  Left = 190
  Top = 125
  ActiveControl = nil
  Caption = 'Form_REXWarn'
  PixelsPerInch = 96
  TextHeight = 13
  inherited TitleLbl: TLabel
    Caption = 'REX.BAT'
  end
  inherited InstrLbl: TLabel
    Top = 48
    Height = 34
    Caption = 
      'REX.BAT has been changed to support the Multi-Company Manager. Y' +
      'our original REX.BAT has been saved as '
  end
  object RexSave: TLabel [3]
    Left = 190
    Top = 89
    Width = 225
    Height = 13
    AutoSize = False
    Caption = 'RexSave'
  end
  inherited ExitBtn: TButton
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 169
    Top = 217
    Visible = False
  end
  inherited NextBtn: TButton
    Left = 370
    Caption = '&OK'
  end
end
