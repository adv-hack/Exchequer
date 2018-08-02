inherited frmResults: TfrmResults
  Left = 361
  Top = 123
  ActiveControl = nil
  Caption = 'frmResults'
  ClientHeight = 543
  ClientWidth = 898
  KeyPreview = True
  OnClose = FormClose
  DesignSize = (
    898
    543)
  PixelsPerInch = 96
  TextHeight = 14
  inherited Bevel1: TBevel
    Top = 498
    Width = 875
  end
  inherited TitleLbl: TLabel
    Width = 723
    Caption = 'Survey Results'
  end
  inherited InstrLbl: TLabel
    Left = 43
    Top = 76
    Width = 169
    Caption = ''
    Visible = False
  end
  object Label1: TLabel [4]
    Left = 167
    Top = 49
    Width = 724
    Height = 17
    AutoSize = False
    Caption = 
      'The survey results are shown below, please Email them to us by f' +
      'ollowing the instructions below:-'
    WordWrap = True
  end
  object Label2: TLabel [5]
    Left = 167
    Top = 179
    Width = 710
    Height = 17
    AutoSize = False
    Caption = 
      'If you do not have access to Email then please contact us to arr' +
      'ange an alternative using your normal support number.'
    WordWrap = True
  end
  inherited HelpBtn: TButton
    Left = 21
    Top = 515
    Anchors = [akBottom]
    Visible = False
  end
  inherited Panel1: TPanel
    Height = 481
    DesignSize = (
      145
      481)
    inherited Image1: TImage
      Height = 479
    end
  end
  inherited ExitBtn: TButton
    Left = 104
    Top = 515
    TabOrder = 4
    Visible = False
  end
  inherited BackBtn: TButton
    Left = 721
    Top = 515
    Caption = '<< &Details'
    TabOrder = 2
  end
  inherited NextBtn: TButton
    Left = 807
    Top = 515
    Caption = '&Close'
    TabOrder = 3
  end
  object memSurveyOutput: TMemo
    Left = 167
    Top = 204
    Width = 722
    Height = 265
    Anchors = [akLeft, akTop, akRight]
    ScrollBars = ssVertical
    TabOrder = 5
    WordWrap = False
  end
  object btnSaveAs: TButton
    Left = 807
    Top = 476
    Width = 79
    Height = 23
    Caption = 'Save As'
    TabOrder = 6
    OnClick = btnSaveAsClick
  end
  object RichEdit1: TRichEdit
    Left = 181
    Top = 70
    Width = 708
    Height = 105
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    PopupMenu = PopupMenu1
    ReadOnly = True
    TabOrder = 7
  end
  object SaveDialog1: TSaveDialog
    FileName = 'Exchequer Survey.xml'
    Filter = 'XML Files|*.XML|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 114
    Top = 30
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = False
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 66
    Top = 313
  end
  object PopupMenu1: TPopupMenu
    Left = 170
    Top = 102
    object menuOptCopy: TMenuItem
      Caption = '&Copy'
      OnClick = menuOptCopyClick
    end
  end
end
