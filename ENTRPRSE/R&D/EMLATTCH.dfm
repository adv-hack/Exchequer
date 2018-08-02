object frmEmailAttachs: TfrmEmailAttachs
  Left = 530
  Top = 305
  Width = 427
  Height = 184
  Caption = 'Email Attachments'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    411
    146)
  PixelsPerInch = 96
  TextHeight = 13
  object AttachList: TListBox
    Left = 5
    Top = 5
    Width = 314
    Height = 135
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 0
  end
  object btnOK: TSBSButton
    Left = 325
    Top = 6
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
    TextId = 0
  end
  object btnCancel: TSBSButton
    Left = 325
    Top = 34
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
    TextId = 0
  end
  object btnBrowse: TSBSButton
    Left = 325
    Top = 66
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Add'
    TabOrder = 3
    OnClick = btnBrowseClick
    TextId = 0
  end
  object SBSButton1: TSBSButton
    Left = 325
    Top = 92
    Width = 80
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Delete'
    TabOrder = 4
    OnClick = SBSButton1Click
    TextId = 0
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'All Files|*.*|Documents (*.DOC)|*.DOC|Graphic Files|*.BMP;*.JPG;' +
      '*.GIF|Spreadsheets|*.XLS'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Add Email Attachment'
    Left = 14
    Top = 11
  end
end
