object frmDetails: TfrmDetails
  Left = 162
  Top = 137
  BorderStyle = bsNone
  Caption = 'frmDetails'
  ClientHeight = 190
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 56
    Top = 36
    Width = 26
    Height = 14
    Caption = 'Edit1:'
  end
  object Label2: TLabel
    Left = 56
    Top = 64
    Width = 26
    Height = 14
    Caption = 'Edit2:'
  end
  object Edit1: TEdit
    Left = 96
    Top = 32
    Width = 121
    Height = 22
    TabOrder = 1
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 96
    Top = 64
    Width = 121
    Height = 22
    TabOrder = 2
    Text = 'Edit2'
  end
  object pnlNext: TPanel
    Left = 1
    Top = 1
    Width = 1
    Height = 1
    Caption = 'pnlNext'
    TabOrder = 3
    TabStop = True
    OnEnter = pnlNextEnter
  end
  object pnlPrev: TPanel
    Left = 1
    Top = 1
    Width = 1
    Height = 1
    TabOrder = 0
    TabStop = True
    OnEnter = pnlPrevEnter
  end
  object EnterToTab1: TEnterToTab
    ConvertEnters = True
    OverrideFont = True
    Version = 'TEnterToTab v1.02 for Delphi 6.01'
    Left = 368
    Top = 144
  end
end
