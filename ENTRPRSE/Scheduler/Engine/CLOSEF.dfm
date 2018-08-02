object frmSchedCloseStatus: TfrmSchedCloseStatus
  Left = 293
  Top = 133
  BorderStyle = bsDialog
  Caption = 'Exchequer Scheduler'
  ClientHeight = 135
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 329
    Height = 121
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 313
      Height = 41
      AutoSize = False
      Caption = 
        'Some tasks are still being processed.  The program will wait for' +
        ' them to finish before closing. '
      WordWrap = True
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 313
      Height = 41
      AutoSize = False
      Caption = 
        ' If you wish to terminate the processes and close the program im' +
        'mediately, click the '#39'Close Now'#39' button.'
      WordWrap = True
    end
  end
  object Button2: TButton
    Left = 344
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Close Now'
    TabOrder = 1
    OnClick = Button2Click
  end
end
