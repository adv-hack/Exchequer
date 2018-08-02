inherited TestCust3: TTestCust3
  Tag = 101
  Caption = 'Rebuild Data Files'
  ClientHeight = 295
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Height = 295
    inherited TabSheet1: TTabSheet
      Caption = 'Rebuild'
      inherited SBSPanel4: TSBSBackGroup
        Height = 227
      end
      object Label1: TLabel [1]
        Left = 196
        Top = 16
        Width = 193
        Height = 45
        Alignment = taCenter
        AutoSize = False
        Caption = 'Rebuild Data'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
      end
      object Label2: TLabel [2]
        Left = 208
        Top = 64
        Width = 177
        Height = 57
        AutoSize = False
        Caption = 
          'Please select each of the files you wish to rebuild, or select a' +
          'll files.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object lblPath: TLabel [3]
        Left = 208
        Top = 118
        Width = 180
        Height = 41
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      inherited StartBtn: TButton
        Visible = False
      end
      object FileList: TCheckListBox
        Left = 12
        Top = 14
        Width = 173
        Height = 207
        ItemHeight = 13
        TabOrder = 1
        OnDblClick = FileListClick
      end
    end
  end
  inherited OkCP1Btn: TButton
    Top = 264
    ModalResult = 0
  end
  inherited ClsCP1Btn: TButton
    Top = 264
    OnClick = ClsCP1BtnClick
  end
end
