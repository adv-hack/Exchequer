object frmDealerDetail: TfrmDealerDetail
  Left = 319
  Top = 129
  ActiveControl = edtDlrCode
  BorderStyle = bsDialog
  Caption = 'frmDealerDetail'
  ClientHeight = 400
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 6
    Top = 3
    Width = 517
    Height = 392
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Main'
      DesignSize = (
        509
        364)
      object GroupBox1: TGroupBox
        Left = 4
        Top = 1
        Width = 399
        Height = 157
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        object Label1: TLabel
          Left = 15
          Top = 15
          Width = 68
          Height = 13
          Alignment = taRightJustify
          Caption = 'Account Code'
        end
        object Label2: TLabel
          Left = 8
          Top = 39
          Width = 75
          Height = 13
          Alignment = taRightJustify
          Caption = 'Company Name'
        end
        object Label3: TLabel
          Left = 46
          Top = 62
          Width = 37
          Height = 13
          Alignment = taRightJustify
          Caption = 'Contact'
        end
        object Label4: TLabel
          Left = 52
          Top = 85
          Width = 31
          Height = 13
          Alignment = taRightJustify
          Caption = 'Phone'
        end
        object Label5: TLabel
          Left = 58
          Top = 108
          Width = 25
          Height = 13
          Alignment = taRightJustify
          Caption = 'Email'
        end
        object Label6: TLabel
          Left = 29
          Top = 132
          Width = 54
          Height = 13
          Alignment = taRightJustify
          Caption = 'Expiry Date'
        end
        object edtDlrCode: TEdit
          Left = 87
          Top = 12
          Width = 70
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 6
          TabOrder = 0
        end
        object edtDlrName: TEdit
          Left = 87
          Top = 36
          Width = 241
          Height = 21
          MaxLength = 45
          TabOrder = 1
        end
        object edtContactName: TEdit
          Left = 87
          Top = 59
          Width = 243
          Height = 21
          MaxLength = 30
          TabOrder = 2
        end
        object edtPhone: TEdit
          Left = 87
          Top = 82
          Width = 142
          Height = 21
          MaxLength = 30
          TabOrder = 3
        end
        object edtEmail: TEdit
          Left = 87
          Top = 105
          Width = 268
          Height = 21
          MaxLength = 100
          TabOrder = 4
        end
        object mskLicExpiry: TMaskEdit
          Left = 87
          Top = 129
          Width = 89
          Height = 21
          EditMask = '!99/99/0000;1;_'
          MaxLength = 10
          TabOrder = 5
          Text = '  /  /    '
        end
      end
      object Panel1: TPanel
        Left = 411
        Top = 6
        Width = 92
        Height = 152
        Anchors = [akTop, akRight]
        BevelOuter = bvLowered
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
        object btnAddPlugIn: TButton
          Left = 6
          Top = 66
          Width = 80
          Height = 21
          Caption = '&Add Plug-In'
          TabOrder = 2
          OnClick = btnAddPlugInClick
        end
        object btnEditPlugIn: TButton
          Left = 6
          Top = 91
          Width = 80
          Height = 21
          Caption = '&Edit Plug-In'
          TabOrder = 3
          OnClick = btnEditPlugInClick
        end
        object btnDeletePlugIn: TButton
          Left = 6
          Top = 115
          Width = 80
          Height = 21
          Caption = 'Delete Plug-In'
          TabOrder = 4
          OnClick = btnDeletePlugInClick
        end
      end
      object lvPlugIns: TListView
        Left = 4
        Top = 163
        Width = 500
        Height = 139
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Code'
            Width = 130
          end
          item
            Caption = 'Plug-In Name'
            Width = 220
          end
          item
            Caption = 'Expires'
            Width = 85
          end
          item
            Caption = 'CheckSum'
            Width = 70
          end>
        ColumnClick = False
        ReadOnly = True
        RowSelect = True
        SortType = stText
        TabOrder = 2
        ViewStyle = vsReport
        OnDblClick = btnEditPlugInClick
      end
      object memComments: TMemo
        Left = 4
        Top = 306
        Width = 500
        Height = 54
        Anchors = [akLeft, akRight, akBottom]
        MaxLength = 200
        TabOrder = 3
      end
    end
  end
end
