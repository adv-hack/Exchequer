object frmOptions: TfrmOptions
  Left = 323
  Top = 187
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 189
  ClientWidth = 341
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 272
    Top = 24
    Width = 65
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 272
    Top = 56
    Width = 65
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 249
    Height = 177
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Options'
      object Panel1: TPanel
        Left = 8
        Top = 8
        Width = 225
        Height = 137
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label1: TLabel
          Left = 24
          Top = 36
          Width = 100
          Height = 13
          Hint = 'Sets the number of VAT periods used in each year'
          Caption = 'Tax Periods per year:'
        end
        object spPeriods: TSpinEdit
          Left = 128
          Top = 32
          Width = 49
          Height = 22
          Hint = 'Sets the number of VAT periods used in each year'
          MaxValue = 12
          MinValue = 1
          TabOrder = 0
          Value = 12
        end
        object chkAutoFill: TCheckBox
          Left = 24
          Top = 88
          Width = 169
          Height = 17
          Hint = 
            'If a future period is not available when posting, this will crea' +
            'te it'
          Caption = 'Use Auto-Fill during posting'
          TabOrder = 1
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Colours'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 8
        Top = 8
        Width = 225
        Height = 137
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label2: TLabel
          Left = 12
          Top = 20
          Width = 80
          Height = 13
          Caption = 'List Background:'
        end
        object Label3: TLabel
          Left = 49
          Top = 60
          Width = 43
          Height = 13
          Caption = 'List Text:'
        end
        object Label4: TLabel
          Left = 22
          Top = 100
          Width = 70
          Height = 13
          Caption = 'Current Period:'
        end
        object colBack: TColorBox
          Left = 100
          Top = 16
          Width = 113
          Height = 22
          Hint = 'Colour of list background'
          Style = [cbStandardColors, cbExtendedColors, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 0
        end
        object colText: TColorBox
          Left = 100
          Top = 56
          Width = 113
          Height = 22
          Hint = 'Colour of list text'
          Style = [cbStandardColors, cbExtendedColors, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 1
        end
        object colCurr: TColorBox
          Left = 100
          Top = 96
          Width = 113
          Height = 22
          Hint = 'Colour to show current period in list'
          Style = [cbStandardColors, cbExtendedColors, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 2
        end
      end
    end
  end
end
