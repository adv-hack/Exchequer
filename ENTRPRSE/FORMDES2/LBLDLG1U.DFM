object BaseLabelDialog: TBaseLabelDialog
  Left = 93
  Top = 130
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'BaseLabelDialog'
  ClientHeight = 361
  ClientWidth = 566
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnActivate = PaintLabel
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Image_Labels: TImage
    Left = 7
    Top = 8
    Width = 367
    Height = 341
    OnClick = Image_LabelsClick
    OnMouseDown = Image_LabelsMouseDown
  end
end
