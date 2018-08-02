object frmPlugInDetail: TfrmPlugInDetail
  Left = 346
  Top = 155
  ActiveControl = edtCode
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'frmPlugInDetail'
  ClientHeight = 129
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 6
    Top = 3
    Width = 434
    Height = 122
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Plug-In'
      object GroupBox1: TGroupBox
        Left = 4
        Top = 1
        Width = 320
        Height = 89
        TabOrder = 0
        object Label1: TLabel
          Left = 33
          Top = 15
          Width = 25
          Height = 13
          Alignment = taRightJustify
          Caption = 'Code'
        end
        object Label2: TLabel
          Left = 30
          Top = 39
          Width = 28
          Height = 13
          Alignment = taRightJustify
          Caption = 'Name'
        end
        object Label6: TLabel
          Left = 5
          Top = 66
          Width = 54
          Height = 13
          Alignment = taRightJustify
          Caption = 'Expiry Date'
        end
        object edtCode: TEdit
          Left = 64
          Top = 12
          Width = 145
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 16
          TabOrder = 0
        end
        object edtName: TEdit
          Left = 63
          Top = 36
          Width = 249
          Height = 21
          MaxLength = 100
          TabOrder = 1
        end
        object mskLicExpiry: TMaskEdit
          Left = 64
          Top = 61
          Width = 89
          Height = 21
          EditMask = '!99/99/0000;1;_'
          MaxLength = 10
          TabOrder = 2
          Text = '  /  /    '
        end
      end
      object Panel1: TPanel
        Left = 329
        Top = 6
        Width = 93
        Height = 83
        BevelOuter = bvLowered
        Caption = 'Panel1'
        TabOrder = 1
        object btnOK: TButton
          Left = 6
          Top = 6
          Width = 80
          Height = 21
          Caption = '&OK'
          TabOrder = 0
          OnClick = btnOKClick
        end
        object btnCancel: TButton
          Left = 6
          Top = 31
          Width = 80
          Height = 21
          Cancel = True
          Caption = '&Cancel'
          ModalResult = 2
          TabOrder = 1
        end
      end
    end
  end
end
