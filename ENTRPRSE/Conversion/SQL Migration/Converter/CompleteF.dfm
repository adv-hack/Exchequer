inherited frmConversionComplete: TfrmConversionComplete
  Left = 439
  Top = 219
  HelpContext = 6
  HorzScrollBar.Range = 0
  VertScrollBar.Range = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'frmConversionComplete'
  ClientHeight = 304
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 14
  inherited lblBanner: TLabel
    Width = 248
    Caption = 'Conversion Complete'
  end
  object btnClose: TButton [2]
    Left = 193
    Top = 276
    Width = 80
    Height = 21
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 0
  end
  object ScrollBox1: TScrollBox [3]
    Left = 12
    Top = 46
    Width = 450
    Height = 222
    BorderStyle = bsNone
    TabOrder = 1
    object panHeader: TPanel
      Left = 0
      Top = 0
      Width = 419
      Height = 28
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 0
        Top = 4
        Width = 394
        Height = 17
        AutoSize = False
        Caption = 
          'The Exchequer Pervasive Edition to SQL Edition Conversion has co' +
          'mpleted.'
        WordWrap = True
      end
    end
    object panExchDllIni: TPanel
      Left = 0
      Top = 27
      Width = 419
      Height = 59
      BevelOuter = bvNone
      TabOrder = 1
      object Label4: TLabel
        Left = 0
        Top = 0
        Width = 394
        Height = 33
        AutoSize = False
        Caption = 
          'The conversion was unable to automatically correct ExchDll.Ini i' +
          'n the Exchequer SQL Edition directory, this must be corrected ma' +
          'nually. '
        WordWrap = True
      end
      object lblExchDll: TLabel
        Left = 12
        Top = 32
        Width = 137
        Height = 14
        Cursor = crHandPoint
        Caption = 'Click here to open ExchDll.Ini'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        OnClick = lblExchDllClick
      end
    end
    object panPostConversion: TPanel
      Left = 1
      Top = 85
      Width = 419
      Height = 76
      BevelOuter = bvNone
      TabOrder = 2
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 410
        Height = 42
        AutoSize = False
        Caption = 
          'Next you should go through the precautionary Post-Conversion che' +
          'cks in your Exchequer SQL Edition to confirm that your accounts ' +
          'have been converted successfully.'
        WordWrap = True
      end
      object lblPostConversionChecks: TLabel
        Left = 12
        Top = 46
        Width = 264
        Height = 14
        Cursor = crHandPoint
        HelpContext = 301
        Caption = 'Click here to view help on the Post-Conversion Checks'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        OnClick = lblPostConversionChecksClick
      end
    end
    object panCompanyDetails: TPanel
      Left = 2
      Top = 160
      Width = 419
      Height = 53
      BevelOuter = bvNone
      TabOrder = 3
      object Label6: TLabel
        Left = 0
        Top = 0
        Width = 410
        Height = 36
        AutoSize = False
        Caption = 
          'A report containing details of your Company datasets can be prin' +
          'ted.  If printed this information should be stored securely.'
        WordWrap = True
      end
      object lblCompanyReport: TLabel
        Left = 12
        Top = 33
        Width = 219
        Height = 14
        Cursor = crHandPoint
        Caption = 'Click here to print the Company Details Report'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        OnClick = lblCompanyReportClick
      end
    end
  end
end
