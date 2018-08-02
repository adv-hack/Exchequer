object frmPrintTo: TfrmPrintTo
  Left = 467
  Top = 251
  ActiveControl = lstPrinters
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Select Printer'
  ClientHeight = 161
  ClientWidth = 406
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 4
    Top = 2
    Width = 398
    Height = 156
    ActivePage = tabshPrinter
    TabIndex = 0
    TabOrder = 0
    object tabshPrinter: TTabSheet
      Caption = 'Printer'
      object SBSBackGroup3: TSBSBackGroup
        Left = 3
        Top = 4
        Width = 383
        Height = 47
        Caption = 'Printer'
        TextId = 0
      end
      object Label81: Label8
        Left = 6
        Top = 25
        Width = 37
        Height = 23
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Printer'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object SBSBackGroup4: TSBSBackGroup
        Left = 3
        Top = 54
        Width = 149
        Height = 43
        Caption = 'Output To'
        TextId = 0
      end
      object lstPrinters: TSBSComboBox
        Left = 47
        Top = 21
        Width = 252
        Height = 22
        Hint = 
          'Choose which printer|Use this option to select which printer you' +
          ' wish to use. Note, even when printing to screen you must select' +
          ' a valid printer.'
        HelpContext = 298
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        OnClick = lstPrintersClick
        MaxListWidth = 0
      end
      object btnSetupPrinter: TButton
        Left = 303
        Top = 21
        Width = 75
        Height = 21
        Hint = 
          'Access printer setup|Change the printer settings for the current' +
          'ly selected print device.'
        HelpContext = 302
        Caption = '&Setup'
        TabOrder = 1
        OnClick = btnSetupPrinterClick
      end
      object radPrinter: TBorRadio
        Left = 11
        Top = 71
        Width = 63
        Height = 20
        Hint = 
          'Send output to Printer|Sends output to the currently selected pr' +
          'int device.'
        HelpContext = 300
        Align = alNone
        Caption = 'Printer'
        TabOrder = 2
        TextId = 0
      end
      object radPreview: TBorRadio
        Left = 78
        Top = 71
        Width = 70
        Height = 20
        Hint = 
          'Send output to Screen|Sends all output to a print preview screen' +
          ', which can optionaly be sent to  the currently selected printer'
        HelpContext = 300
        Align = alRight
        Caption = 'Screen'
        Checked = True
        TabOrder = 3
        TabStop = True
        TextId = 0
      end
      object btnOK: TButton
        Left = 221
        Top = 104
        Width = 75
        Height = 21
        HelpContext = 303
        Caption = '&OK'
        Default = True
        TabOrder = 4
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        Left = 310
        Top = 103
        Width = 75
        Height = 21
        HelpContext = 304
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 5
      end
    end
  end
end
