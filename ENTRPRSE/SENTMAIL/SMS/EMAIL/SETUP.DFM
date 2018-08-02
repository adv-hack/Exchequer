object frmSetup: TfrmSetup
  Left = 329
  Top = 207
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'SMS Email Sender Configuration'
  ClientHeight = 214
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object btnOK: TButton
    Left = 176
    Top = 184
    Width = 65
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 248
    Top = 184
    Width = 65
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object pcSettings: TPageControl
    Left = 8
    Top = 8
    Width = 305
    Height = 169
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Global Settings'
      object Label7: TLabel
        Left = 8
        Top = 84
        Width = 113
        Height = 14
        Caption = 'Sender Email Address :'
      end
      object Label9: TLabel
        Left = 8
        Top = 52
        Width = 69
        Height = 14
        Caption = 'SMTP Server :'
      end
      object Label10: TLabel
        Left = 8
        Top = 20
        Width = 84
        Height = 14
        Caption = 'Gateway to use :'
      end
      object edSenderEmail: TEdit
        Left = 128
        Top = 80
        Width = 161
        Height = 22
        TabOrder = 2
      end
      object edSMTPServer: TEdit
        Left = 96
        Top = 48
        Width = 193
        Height = 22
        TabOrder = 1
      end
      object cmbGateway: TComboBox
        Left = 96
        Top = 16
        Width = 193
        Height = 22
        Style = csDropDownList
        ItemHeight = 14
        TabOrder = 0
        Items.Strings = (
          'Kapow'
          'Text Marketer')
      end
      object cbMAPI: TCheckBox
        Left = 128
        Top = 112
        Width = 97
        Height = 17
        Caption = ' Use MAPI ?'
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Kapow'
      ImageIndex = 1
      object Label2: TLabel
        Left = 8
        Top = 60
        Width = 59
        Height = 14
        Caption = 'User Name :'
      end
      object Label3: TLabel
        Left = 8
        Top = 84
        Width = 56
        Height = 14
        Caption = 'Password :'
      end
      object Label4: TLabel
        Left = 8
        Top = 20
        Width = 51
        Height = 14
        Caption = 'Company :'
      end
      object edKUserName: TEdit
        Left = 80
        Top = 56
        Width = 209
        Height = 22
        TabOrder = 1
      end
      object edKPassword: TEdit
        Left = 80
        Top = 80
        Width = 209
        Height = 22
        PasswordChar = '*'
        TabOrder = 2
      end
      object edKCompany: TEdit
        Left = 80
        Top = 16
        Width = 209
        Height = 22
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Text Marketer'
      ImageIndex = 2
      object Label1: TLabel
        Left = 8
        Top = 60
        Width = 63
        Height = 14
        Caption = 'Account No :'
      end
      object Label6: TLabel
        Left = 8
        Top = 20
        Width = 51
        Height = 14
        Caption = 'Company :'
      end
      object edTMAccountNo: TEdit
        Left = 80
        Top = 56
        Width = 209
        Height = 22
        TabOrder = 1
      end
      object edTMCompany: TEdit
        Left = 80
        Top = 16
        Width = 209
        Height = 22
        TabOrder = 0
      end
    end
  end
end
