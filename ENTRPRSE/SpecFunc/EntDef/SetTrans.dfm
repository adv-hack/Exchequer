inherited ClearTransFrm: TClearTransFrm
  Left = 296
  Top = 219
  ActiveControl = TransactionTxt
  Caption = 'Clear transactions with no lines'
  ClientHeight = 225
  ClientWidth = 413
  FormStyle = fsNormal
  Position = poOwnerFormCenter
  Visible = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  inherited PageControl1: TPageControl
    Width = 413
    Height = 184
    inherited TabSheet1: TTabSheet
      Caption = 'Transaction'
      inherited SBSPanel4: TSBSBackGroup
        Height = 123
      end
      object Label2: TLabel [1]
        Left = 17
        Top = 15
        Width = 361
        Height = 34
        AutoSize = False
        Caption = 
          'Please enter the document reference of the Transaction whose val' +
          'ues should be cleared.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label81: Label8 [2]
        Left = 94
        Top = 70
        Width = 60
        Height = 14
        Caption = 'Transaction:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TextId = 0
      end
      object TransactionTxt: Text8Pt
        Left = 161
        Top = 67
        Width = 130
        Height = 23
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 9
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnChange = TransactionTxtChange
        OnKeyPress = TransactionTxtKeyPress
        TextId = 0
        ViaSBtn = False
      end
      object StatusPnl: TPanel
        Left = 9
        Top = 96
        Width = 381
        Height = 25
        BevelOuter = bvLowered
        Caption = ' '
        TabOrder = 2
      end
    end
  end
  inherited OkCP1Btn: TButton
    ModalResult = 0
  end
  inherited ClsCP1Btn: TButton
    Caption = '&Close'
  end
  inherited TitlePnl: TPanel
    Width = 413
    object Label1: TLabel
      Left = 7
      Top = 12
      Width = 377
      Height = 25
      AutoSize = False
      Caption = 'Clear Transaction'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
