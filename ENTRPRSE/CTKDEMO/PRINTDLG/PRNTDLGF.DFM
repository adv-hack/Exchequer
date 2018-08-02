object frmPrintDlg: TfrmPrintDlg
  Left = 345
  Top = 134
  Width = 603
  Height = 390
  ActiveControl = tabshPrinterInfo
  Caption = 'frmPrintDlg'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 5
    Top = 4
    Width = 547
    Height = 354
    ActivePage = tabshPrinterInfo
    TabIndex = 3
    TabOrder = 0
    object tabshPrinter: TTabSheet
      Caption = 'Printer'
      object GroupBox1: TGroupBox
        Left = 5
        Top = 1
        Width = 439
        Height = 71
        Caption = ' Printer '
        TabOrder = 0
        object Label1: TLabel
          Left = 19
          Top = 22
          Width = 30
          Height = 13
          Alignment = taRightJustify
          Caption = 'Printer'
        end
        object Label2: TLabel
          Left = 17
          Top = 45
          Width = 32
          Height = 13
          Alignment = taRightJustify
          Caption = 'Copies'
        end
        object Label3: TLabel
          Left = 257
          Top = 45
          Width = 32
          Height = 13
          Alignment = taRightJustify
          Caption = 'Copies'
        end
        object lstPrinters: TComboBox
          Left = 56
          Top = 19
          Width = 316
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
        end
        object edtCopies: TEdit
          Left = 56
          Top = 43
          Width = 57
          Height = 21
          TabOrder = 1
        end
        object Edit1: TEdit
          Left = 295
          Top = 43
          Width = 77
          Height = 21
          TabOrder = 2
        end
      end
    end
    object tabshFax: TTabSheet
      Caption = 'Fax'
      ImageIndex = 2
    end
    object tabshEmail: TTabSheet
      Caption = 'Email'
      ImageIndex = 1
    end
    object tabshPrinterInfo: TTabSheet
      Caption = 'Printer Info'
      ImageIndex = 3
      object Label4: TLabel
        Left = 9
        Top = 5
        Width = 41
        Height = 13
        Caption = 'Printers:-'
      end
      object Label5: TLabel
        Left = 10
        Top = 90
        Width = 26
        Height = 13
        Caption = 'Bins:-'
      end
      object Label6: TLabel
        Left = 10
        Top = 206
        Width = 39
        Height = 13
        Caption = 'Papers:-'
      end
      object lstPIPrinters: TListBox
        Left = 9
        Top = 19
        Width = 316
        Height = 66
        ItemHeight = 13
        TabOrder = 0
        OnClick = lstPIPrintersClick
      end
      object lstPIBins: TListBox
        Left = 9
        Top = 104
        Width = 316
        Height = 97
        ItemHeight = 13
        TabOrder = 1
      end
      object lstPIPapers: TListBox
        Left = 9
        Top = 220
        Width = 316
        Height = 97
        ItemHeight = 13
        TabOrder = 2
      end
    end
  end
end
