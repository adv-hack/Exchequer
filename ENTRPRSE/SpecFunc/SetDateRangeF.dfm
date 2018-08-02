inherited SetDateRangeFrm: TSetDateRangeFrm
  Left = 355
  Top = 218
  Caption = 'Special Function 122'
  ClientHeight = 272
  ClientWidth = 412
  FormStyle = fsNormal
  Position = poScreenCenter
  Visible = False
  PixelsPerInch = 96
  TextHeight = 14
  inherited PageControl1: TPageControl
    Width = 412
    Height = 231
    inherited TabSheet1: TTabSheet
      Caption = 'Enter the date range'
      object FromDateLbl: Label8 [1]
        Left = 108
        Top = 48
        Width = 48
        Height = 14
        Caption = 'From date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object ToDateLbl: Label8 [2]
        Left = 108
        Top = 98
        Width = 36
        Height = 14
        Caption = 'To date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object ErrorLbl: TLabel [3]
        Left = 16
        Top = 136
        Width = 361
        Height = 14
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      inherited StartBtn: TButton
        Top = 164
        Visible = False
      end
      object FromDateTxt: TEditDate
        Left = 172
        Top = 44
        Width = 121
        Height = 22
        AutoSelect = False
        EditMask = '00/00/0000;0;'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        TabOrder = 1
        OnChange = FromDateTxtChange
        Placement = cpAbove
      end
      object ToDateTxt: TEditDate
        Left = 172
        Top = 92
        Width = 121
        Height = 22
        AutoSelect = False
        EditMask = '00/00/0000;0;'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        TabOrder = 2
        OnChange = ToDateTxtChange
        Placement = cpAbove
      end
    end
  end
  inherited OkCP1Btn: TButton
    Top = 228
    ModalResult = 0
  end
  inherited ClsCP1Btn: TButton
    Top = 228
  end
  inherited TitlePnl: TPanel
    Width = 412
    object TitleLbl: TLabel
      Left = 3
      Top = 11
      Width = 377
      Height = 25
      AutoSize = False
      Caption = 'Copy Cost of Sales'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
