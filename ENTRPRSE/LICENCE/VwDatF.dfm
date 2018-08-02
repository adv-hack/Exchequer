object Form1: TForm1
  Left = 343
  Top = 94
  Width = 435
  Height = 507
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 419
    Height = 448
    Align = alClient
    Lines.Strings = (
      'RichEdit1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 179
    Top = 65529
    object File1: TMenuItem
      Caption = '&File'
      object Open1: TMenuItem
        Caption = '&Open'
        OnClick = Open1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuChange: TMenuItem
        Caption = 'Change'
        object mnuProductType: TMenuItem
          Caption = 'Product Type'
          object mnuSaveAsExchequer: TMenuItem
            Caption = 'Save As Exchequer'
            OnClick = mnuSaveAsExchequerClick
          end
          object mnuSaveAsIAOCustomer: TMenuItem
            Caption = 'Save As IAO Customer'
            OnClick = mnuSaveAsIAOCustomerClick
          end
          object mnuSaveAsIAOAccountant: TMenuItem
            Caption = 'Save As IAO Accountant'
            OnClick = mnuSaveAsIAOAccountantClick
          end
        end
        object DatabaseType1: TMenuItem
          Caption = 'Database Type'
          object BtrievePervasiveSQL1: TMenuItem
            Caption = 'Btrieve / Pervasive.SQL'
            OnClick = BtrievePervasiveSQL1Click
          end
          object MSSQLServer1: TMenuItem
            Caption = 'MS SQL Server'
            OnClick = MSSQLServer1Click
          end
        end
        object Modules1: TMenuItem
          Caption = 'Modules'
          object Core1: TMenuItem
            Caption = 'Core'
            OnClick = Core1Click
          end
          object Stock1: TMenuItem
            Caption = 'Stock'
            OnClick = Stock1Click
          end
          object SPOP1: TMenuItem
            Caption = 'SPOP'
            OnClick = SPOP1Click
          end
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'LIC'
    Filter = 'Licence Files (*.DAT)|*.DAT|All Files (*.*)|*.*'
    Options = [ofPathMustExist, ofFileMustExist]
    Title = 'Open Exchequer Licence'
    Left = 213
    Top = 65532
  end
end
