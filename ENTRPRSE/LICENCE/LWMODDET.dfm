object frmModSettings: TfrmModSettings
  Left = 348
  Top = 137
  BorderStyle = bsDialog
  Caption = 'Enterprise Modules - Details Settings'
  ClientHeight = 248
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    479
    248)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 4
    Top = 3
    Width = 470
    Height = 241
    ActivePage = tabshElerts
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabIndex = 2
    TabOrder = 0
    object tabshToolkit: TTabSheet
      Caption = 'Toolkit (COM + DLL)'
      object lblTK30Users: TLabel
        Left = 10
        Top = 126
        Width = 68
        Height = 19
        Alignment = taRightJustify
        AutoSize = False
        Caption = '30-Day '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label83: Label8
        Left = 5
        Top = 3
        Width = 448
        Height = 31
        AutoSize = False
        Caption = 
          'Please specify whether the Runtime or Developer version of the T' +
          'oolkits are to be installed, and what release code status to giv' +
          'e them.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object Label84: Label8
        Left = 5
        Top = 102
        Width = 448
        Height = 20
        AutoSize = False
        Caption = 'Please specify the 30-Day and Full User Counts for the Toolkits.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object lblTKFullUsers: TLabel
        Left = 200
        Top = 126
        Width = 68
        Height = 19
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Full'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnToolkitOK: TButton
        Left = 290
        Top = 155
        Width = 80
        Height = 21
        Caption = '&OK'
        TabOrder = 0
        OnClick = btnToolkitOKClick
      end
      object btnToolkitCancel: TButton
        Left = 377
        Top = 155
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
      end
      object ScrollBox2: TScrollBox
        Left = 3
        Top = 36
        Width = 455
        Height = 51
        TabOrder = 2
        object Label81: Label8
          Left = 8
          Top = 3
          Width = 110
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Runtime'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TextId = 0
        end
        object Bevel2: TBevel
          Left = 4
          Top = 23
          Width = 441
          Height = 7
          Shape = bsTopLine
        end
        object Label82: Label8
          Left = 8
          Top = 27
          Width = 110
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Developer'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TextId = 0
        end
        object panRunTKNo: TPanel
          Left = 137
          Top = 2
          Width = 80
          Height = 20
          BevelOuter = bvNone
          Caption = 'NO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = TKClick
        end
        object panRunTKFull: TPanel
          Tag = 2
          Left = 332
          Top = 2
          Width = 115
          Height = 20
          BevelOuter = bvNone
          Caption = 'FULL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = TKClick
        end
        object panRunTK30: TPanel
          Tag = 1
          Left = 217
          Top = 2
          Width = 115
          Height = 20
          BevelOuter = bvNone
          Caption = '30-DAY'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = TKClick
        end
        object panDevTKNo: TPanel
          Tag = 10
          Left = 137
          Top = 26
          Width = 80
          Height = 20
          BevelOuter = bvNone
          Caption = 'NO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = TKClick
        end
        object panDevTKFull: TPanel
          Tag = 12
          Left = 332
          Top = 26
          Width = 115
          Height = 20
          BevelOuter = bvNone
          Caption = 'FULL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = TKClick
        end
        object panDevTK30: TPanel
          Tag = 11
          Left = 217
          Top = 26
          Width = 115
          Height = 20
          BevelOuter = bvNone
          Caption = '30-DAY'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = TKClick
        end
      end
      object lstTK30Users: TComboBox
        Left = 82
        Top = 123
        Width = 85
        Height = 27
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 19
        ParentFont = False
        TabOrder = 3
        Text = '0'
        Items.Strings = (
          '0'
          '1'
          '4'
          '8'
          '12'
          '16'
          '20'
          '24'
          '28')
      end
      object lstTKFullUsers: TComboBox
        Left = 272
        Top = 123
        Width = 85
        Height = 27
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 19
        ParentFont = False
        TabOrder = 4
        Text = '0'
        Items.Strings = (
          '0'
          '1'
          '4'
          '8'
          '12'
          '16'
          '20'
          '24'
          '28')
      end
      object UpDown2: TUpDown
        Left = 167
        Top = 123
        Width = 12
        Height = 27
        Associate = lstTK30Users
        Min = 0
        Max = 999
        Position = 0
        TabOrder = 5
        Wrap = False
      end
      object UpDown3: TUpDown
        Left = 357
        Top = 123
        Width = 12
        Height = 27
        Associate = lstTKFullUsers
        Min = 0
        Max = 999
        Position = 0
        TabOrder = 6
        Wrap = False
      end
    end
    object tabshWOP: TTabSheet
      Caption = 'Works Order Processing'
      ImageIndex = 2
      object btnOK: TButton
        Left = 291
        Top = 62
        Width = 80
        Height = 21
        Caption = '&OK'
        TabOrder = 0
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        Left = 378
        Top = 62
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
      end
      object ScrollBox1: TScrollBox
        Left = 3
        Top = 4
        Width = 455
        Height = 51
        TabOrder = 2
        object lblASAHed: Label8
          Left = 8
          Top = 3
          Width = 110
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Standard'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TextId = 0
        end
        object Bevel1: TBevel
          Left = 4
          Top = 23
          Width = 441
          Height = 7
          Shape = bsTopLine
        end
        object lblCommitHed: Label8
          Left = 8
          Top = 27
          Width = 110
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Professional'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TextId = 0
        end
        object panStdWOPNo: TPanel
          Left = 137
          Top = 2
          Width = 80
          Height = 20
          BevelOuter = bvNone
          Caption = 'NO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = WOPClick
        end
        object panStdWOPFull: TPanel
          Tag = 2
          Left = 332
          Top = 2
          Width = 115
          Height = 20
          BevelOuter = bvNone
          Caption = 'FULL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = WOPClick
        end
        object panStdWOP30: TPanel
          Tag = 1
          Left = 217
          Top = 2
          Width = 115
          Height = 20
          BevelOuter = bvNone
          Caption = '30-DAY'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = WOPClick
        end
        object panProWOPNo: TPanel
          Tag = 10
          Left = 137
          Top = 26
          Width = 80
          Height = 20
          BevelOuter = bvNone
          Caption = 'NO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = WOPClick
        end
        object panProWOPFull: TPanel
          Tag = 12
          Left = 332
          Top = 26
          Width = 115
          Height = 20
          BevelOuter = bvNone
          Caption = 'FULL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = WOPClick
        end
        object panProWOP30: TPanel
          Tag = 11
          Left = 217
          Top = 26
          Width = 115
          Height = 20
          BevelOuter = bvNone
          Caption = '30-DAY'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = WOPClick
        end
      end
    end
    object tabshElerts: TTabSheet
      Caption = 'Sentimail'
      ImageIndex = 2
      object Label87: Label8
        Left = 5
        Top = 40
        Width = 448
        Height = 20
        AutoSize = False
        Caption = 'Please specify the number of Sentinels that the user can add:-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        TextId = 0
      end
      object lblSentinelCnt: TLabel
        Left = 5
        Top = 64
        Width = 94
        Height = 19
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Sentinels'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lstElertSentinels: TComboBox
        Left = 103
        Top = 61
        Width = 85
        Height = 27
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 19
        ParentFont = False
        TabOrder = 1
        Text = '0'
        Items.Strings = (
          '500')
      end
      object btnElertsOK: TButton
        Left = 290
        Top = 94
        Width = 80
        Height = 21
        Caption = '&OK'
        TabOrder = 3
        OnClick = btnElertsOKClick
      end
      object btnElertsCancel: TButton
        Left = 377
        Top = 94
        Width = 80
        Height = 21
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 4
      end
      object ScrollBox3: TScrollBox
        Left = 3
        Top = 4
        Width = 455
        Height = 28
        TabOrder = 0
        object Label88: Label8
          Left = 8
          Top = 3
          Width = 110
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Sentimail'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TextId = 0
        end
        object panElertsNo: TPanel
          Left = 137
          Top = 2
          Width = 80
          Height = 20
          BevelOuter = bvNone
          Caption = 'NO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = ElertsClick
        end
        object panElertsFull: TPanel
          Tag = 2
          Left = 332
          Top = 2
          Width = 115
          Height = 20
          BevelOuter = bvNone
          Caption = 'FULL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = ElertsClick
        end
        object panElerts30: TPanel
          Tag = 1
          Left = 217
          Top = 2
          Width = 115
          Height = 20
          BevelOuter = bvNone
          Caption = '30-DAY'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = ElertsClick
        end
      end
      object UpDown1: TUpDown
        Left = 188
        Top = 61
        Width = 12
        Height = 27
        Associate = lstElertSentinels
        Min = 0
        Max = 999
        Position = 0
        TabOrder = 2
        Wrap = False
      end
    end
  end
end
