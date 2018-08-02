object FormRecurseErr: TFormRecurseErr
  Left = 396
  Top = 165
  Width = 435
  Height = 284
  HelpContext = 150
  BorderIcons = [biSystemMenu]
  Caption = 'Recursion Error'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 14
  object ListVw_Controls: TListView
    Left = 0
    Top = 63
    Width = 427
    Height = 158
    Align = alClient
    Columns = <
      item
        Caption = 'Field'
        Width = 80
      end
      item
        Caption = 'Operation'
        Width = 120
      end
      item
        Caption = 'Formula'
        Width = 400
      end>
    TabOrder = 1
    ViewStyle = vsReport
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 427
    Height = 63
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label81: Label8
      Left = 5
      Top = 5
      Width = 417
      Height = 33
      AutoSize = False
      Caption = 
        'A Recursion Error has been detected while processing the current' +
        ' form. The details shown below give details of the controls bein' +
        'g processed at the time of the error.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      TextId = 0
    end
    object Label82: Label8
      Left = 5
      Top = 42
      Width = 418
      Height = 19
      AutoSize = False
      Caption = 
        'NOTE: This error means that the form will have incorrect values ' +
        'on it.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TextId = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 221
    Width = 427
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnOK: TButton
      Left = 176
      Top = 5
      Width = 80
      Height = 21
      Caption = '&OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
end
