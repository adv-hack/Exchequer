object frmSetup: TfrmSetup
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Configure SMS'
  ClientHeight = 179
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 240
    Top = 32
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 240
    Top = 64
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 225
    Height = 161
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Defaults'
      object Panel2: TPanel
        Left = 8
        Top = 8
        Width = 209
        Height = 121
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label3: TLabel
          Left = 24
          Top = 24
          Width = 106
          Height = 13
          Caption = 'TimeOut (In Seconds):'
        end
        object edtTimeOut: TEdit
          Left = 24
          Top = 40
          Width = 153
          Height = 21
          TabOrder = 0
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Proxy'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 8
        Top = 4
        Width = 201
        Height = 125
        TabOrder = 0
        object Label1: TLabel
          Left = 24
          Top = 16
          Width = 29
          Height = 13
          Caption = 'Proxy:'
        end
        object Label2: TLabel
          Left = 24
          Top = 54
          Width = 51
          Height = 13
          Caption = 'Proxy Port:'
        end
        object edtProxy: TEdit
          Left = 24
          Top = 30
          Width = 153
          Height = 21
          TabOrder = 0
        end
        object edtProxyPort: TEdit
          Left = 24
          Top = 68
          Width = 81
          Height = 21
          TabOrder = 1
        end
        object chkUseProxy: TCheckBox
          Left = 24
          Top = 96
          Width = 97
          Height = 17
          Caption = 'Use Proxy'
          TabOrder = 2
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Connection'
      ImageIndex = 2
      object Panel1: TPanel
        Left = 8
        Top = 8
        Width = 201
        Height = 121
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label4: TLabel
          Left = 8
          Top = 8
          Width = 185
          Height = 13
          AutoSize = False
          Caption = 'This PC connects to the Internet using:'
        end
        object rbLocal: TRadioButton
          Left = 24
          Top = 32
          Width = 113
          Height = 17
          Caption = 'A local network'
          TabOrder = 0
          OnClick = rbLocalClick
        end
        object rbDialup: TRadioButton
          Left = 24
          Top = 64
          Width = 129
          Height = 17
          Caption = 'A dial-up connection'
          TabOrder = 1
          OnClick = rbLocalClick
        end
        object chkDisconnect: TCheckBox
          Left = 42
          Top = 92
          Width = 145
          Height = 17
          Caption = 'Disconnect after sending'
          TabOrder = 2
        end
      end
    end
  end
end
