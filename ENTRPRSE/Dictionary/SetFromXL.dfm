object frmSetFieldFromXL: TfrmSetFieldFromXL
  Left = 328
  Top = 180
  BorderStyle = bsDialog
  Caption = 'Set File / Version on Var Range'
  ClientHeight = 418
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 336
    Top = 32
    Width = 80
    Height = 21
    Caption = '&OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 336
    Top = 8
    Width = 80
    Height = 21
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object pcTabs: TPageControl
    Left = 8
    Top = 32
    Width = 321
    Height = 377
    ActivePage = tsFields
    TabIndex = 0
    TabOrder = 2
    object tsFields: TTabSheet
      Caption = 'Var Nos'
      object lCount: TLabel
        Left = 8
        Top = 320
        Width = 6
        Height = 13
        Caption = '0'
      end
      object lbVarNos: TListBox
        Left = 8
        Top = 8
        Width = 297
        Height = 305
        ItemHeight = 13
        TabOrder = 0
      end
      object Button1: TButton
        Left = 176
        Top = 320
        Width = 131
        Height = 25
        Caption = 'Append From Text File'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 96
        Top = 320
        Width = 75
        Height = 25
        Caption = 'Clear'
        TabOrder = 2
        OnClick = Button2Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Field to Set'
      ImageIndex = 1
      object Shape7: TShape
        Left = 8
        Top = 152
        Width = 89
        Height = 33
        Brush.Style = bsClear
        Pen.Color = clOlive
      end
      object Shape4: TShape
        Left = 8
        Top = 8
        Width = 297
        Height = 145
        Brush.Style = bsClear
        Pen.Color = clOlive
      end
      object Label2: TLabel
        Left = 16
        Top = 16
        Width = 49
        Height = 13
        Caption = 'Property :'
      end
      object Shape2: TShape
        Left = 88
        Top = 24
        Width = 193
        Height = 57
        Brush.Style = bsClear
        Pen.Color = clOlive
      end
      object Shape3: TShape
        Left = 88
        Top = 80
        Width = 193
        Height = 57
        Brush.Style = bsClear
        Pen.Color = clOlive
      end
      object Label3: TLabel
        Left = 16
        Top = 160
        Width = 38
        Height = 13
        Caption = 'Set To :'
      end
      object Shape5: TShape
        Left = 96
        Top = 152
        Width = 209
        Height = 33
        Brush.Style = bsClear
        Pen.Color = clOlive
      end
      object rbFile: TRadioButton
        Left = 104
        Top = 16
        Width = 41
        Height = 17
        Caption = 'File'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = ThingsChange
      end
      object rbVersion: TRadioButton
        Left = 104
        Top = 72
        Width = 57
        Height = 17
        Caption = 'Version'
        TabOrder = 1
        OnClick = ThingsChange
      end
      object cmbFile: TComboBox
        Left = 112
        Top = 40
        Width = 161
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        OnChange = ThingsChange
      end
      object cmbVersion: TComboBox
        Left = 112
        Top = 96
        Width = 161
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        OnChange = ThingsChange
      end
      object cbSetTo: TCheckBox
        Left = 104
        Top = 160
        Width = 97
        Height = 17
        Caption = 'Unselected'
        TabOrder = 4
      end
    end
  end
  object rbVarNo: TRadioButton
    Left = 8
    Top = 8
    Width = 113
    Height = 17
    Caption = 'Read as Var Nos'
    Checked = True
    TabOrder = 3
    TabStop = True
    OnClick = ReadAsClick
  end
  object rbFieldCode: TRadioButton
    Left = 128
    Top = 8
    Width = 113
    Height = 17
    Caption = 'Read as Field Codes'
    TabOrder = 4
    OnClick = ReadAsClick
  end
  object dlgOpen: TOpenDialog
    Left = 72
    Top = 352
  end
end
