inherited frmCompWizStockCats: TfrmCompWizStockCats
  Left = 142
  Top = 157
  HelpContext = 68
  ActiveControl = edtCategory1
  Caption = 'frmCompWizStockCats'
  ClientHeight = 389
  ClientWidth = 716
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel1: TBevel
    Left = 14
    Top = 344
    Width = 689
  end
  inherited TitleLbl: TLabel
    Width = 541
    Caption = 'Stock Groups'
  end
  inherited InstrLbl: TLabel
    Width = 538
    Height = 19
    Caption = 
      'Please enter your Stock Groups in the fields below, leave any un' +
      'wanted groups blank:-'
  end
  inherited imgSide: TImage
    Height = 233
  end
  object Label1: TLabel [4]
    Left = 172
    Top = 95
    Width = 19
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '1'
    WordWrap = True
  end
  object Label2: TLabel [5]
    Left = 172
    Top = 120
    Width = 19
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '2'
    WordWrap = True
  end
  object Label3: TLabel [6]
    Left = 172
    Top = 145
    Width = 19
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '3'
    WordWrap = True
  end
  object Label4: TLabel [7]
    Left = 172
    Top = 170
    Width = 19
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '4'
    WordWrap = True
  end
  object Label5: TLabel [8]
    Left = 172
    Top = 195
    Width = 19
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '5'
    WordWrap = True
  end
  object Label6: TLabel [9]
    Left = 172
    Top = 220
    Width = 19
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '6'
    WordWrap = True
  end
  object Label7: TLabel [10]
    Left = 172
    Top = 245
    Width = 19
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '7'
    WordWrap = True
  end
  object Label8: TLabel [11]
    Left = 172
    Top = 270
    Width = 19
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '8'
    WordWrap = True
  end
  object Label9: TLabel [12]
    Left = 172
    Top = 295
    Width = 19
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '9'
    WordWrap = True
  end
  object Label10: TLabel [13]
    Left = 172
    Top = 320
    Width = 19
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '10'
    WordWrap = True
  end
  object Label11: TLabel [14]
    Left = 356
    Top = 95
    Width = 8
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
    WordWrap = True
  end
  object Label12: TLabel [15]
    Left = 356
    Top = 120
    Width = 8
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
    WordWrap = True
  end
  object Label13: TLabel [16]
    Left = 356
    Top = 145
    Width = 8
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
    WordWrap = True
  end
  object Label14: TLabel [17]
    Left = 356
    Top = 170
    Width = 8
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
    WordWrap = True
  end
  object Label15: TLabel [18]
    Left = 356
    Top = 195
    Width = 8
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
    WordWrap = True
  end
  object Label16: TLabel [19]
    Left = 356
    Top = 220
    Width = 8
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
    WordWrap = True
  end
  object Label17: TLabel [20]
    Left = 356
    Top = 245
    Width = 8
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
    WordWrap = True
  end
  object Label18: TLabel [21]
    Left = 356
    Top = 270
    Width = 8
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
    WordWrap = True
  end
  object Label19: TLabel [22]
    Left = 356
    Top = 295
    Width = 8
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
    WordWrap = True
  end
  object Label20: TLabel [23]
    Left = 356
    Top = 320
    Width = 8
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = '-'
    WordWrap = True
  end
  object Label21: TLabel [24]
    Left = 196
    Top = 75
    Width = 155
    Height = 20
    AutoSize = False
    Caption = 'Group Code'
    WordWrap = True
  end
  object Label22: TLabel [25]
    Left = 368
    Top = 75
    Width = 158
    Height = 20
    AutoSize = False
    Caption = 'Group Description'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Top = 361
    TabOrder = 21
  end
  inherited Panel1: TPanel
    Height = 327
    TabOrder = 20
    inherited Image1: TImage
      Height = 325
    end
  end
  inherited ExitBtn: TButton
    Top = 361
    TabOrder = 22
  end
  inherited BackBtn: TButton
    Left = 539
    Top = 361
    TabOrder = 23
  end
  inherited NextBtn: TButton
    Left = 625
    Top = 361
    Caption = '&Finish'
    TabOrder = 24
  end
  object edtCategory1: TEdit
    Left = 194
    Top = 92
    Width = 158
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 0
  end
  object edtCategory2: TEdit
    Left = 194
    Top = 117
    Width = 158
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 2
  end
  object edtCategory3: TEdit
    Left = 194
    Top = 142
    Width = 158
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 4
  end
  object edtCategory4: TEdit
    Left = 194
    Top = 167
    Width = 158
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 6
  end
  object edtCategory5: TEdit
    Left = 194
    Top = 192
    Width = 158
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 8
  end
  object edtCategory6: TEdit
    Left = 194
    Top = 217
    Width = 158
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 10
  end
  object edtCategory7: TEdit
    Left = 194
    Top = 242
    Width = 158
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 12
  end
  object edtCategory8: TEdit
    Left = 194
    Top = 267
    Width = 158
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 14
  end
  object edtCategory9: TEdit
    Left = 194
    Top = 292
    Width = 158
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 16
  end
  object edtCategory10: TEdit
    Left = 194
    Top = 317
    Width = 158
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 16
    TabOrder = 18
  end
  object edtCategoryDesc1: TEdit
    Left = 367
    Top = 92
    Width = 336
    Height = 21
    MaxLength = 35
    TabOrder = 1
  end
  object edtCategoryDesc2: TEdit
    Left = 367
    Top = 117
    Width = 336
    Height = 21
    MaxLength = 35
    TabOrder = 3
  end
  object edtCategoryDesc3: TEdit
    Left = 367
    Top = 142
    Width = 336
    Height = 21
    MaxLength = 35
    TabOrder = 5
  end
  object edtCategoryDesc4: TEdit
    Left = 367
    Top = 167
    Width = 336
    Height = 21
    MaxLength = 35
    TabOrder = 7
  end
  object edtCategoryDesc5: TEdit
    Left = 367
    Top = 192
    Width = 336
    Height = 21
    MaxLength = 35
    TabOrder = 9
  end
  object edtCategoryDesc6: TEdit
    Left = 367
    Top = 217
    Width = 336
    Height = 21
    MaxLength = 35
    TabOrder = 11
  end
  object edtCategoryDesc7: TEdit
    Left = 367
    Top = 242
    Width = 336
    Height = 21
    MaxLength = 35
    TabOrder = 13
  end
  object edtCategoryDesc8: TEdit
    Left = 367
    Top = 267
    Width = 336
    Height = 21
    MaxLength = 35
    TabOrder = 15
  end
  object edtCategoryDesc9: TEdit
    Left = 367
    Top = 292
    Width = 336
    Height = 21
    MaxLength = 35
    TabOrder = 17
  end
  object edtCategoryDesc10: TEdit
    Left = 367
    Top = 317
    Width = 336
    Height = 21
    MaxLength = 35
    TabOrder = 19
  end
end
