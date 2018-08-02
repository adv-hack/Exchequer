{*********************************************************}
{*                   ADPEDIT0.PAS 4.03                   *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdPEdit0;

interface

uses
  WinTypes,
  WinProcs,
  SysUtils,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
{$IFDEF Delphi6}
  DesignIntf,
  DesignEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF}
  StdCtrls;

type
  TAdPEdit = class(TForm)
    BaudChoices : TComboBox;
    OK          : TButton;
    Cancel      : TButton;
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  end;

  {Baud rate property editor}
  TBaudRateProperty = class(TIntegerProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

var
  AdPEdit: TAdPEdit;

implementation

{$R *.DFM}

procedure TAdPEdit.OKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TAdPEdit.CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{TBaudRateProperty (editor)}

  procedure TBaudRateProperty.Edit;
  var
    BRE : TAdPEdit;
  begin
    BRE := TAdPEdit.Create(Application);
    BRE.BaudChoices.Text := GetValue;
    try
      BRE.ShowModal;
      SetValue(BRE.BaudChoices.Text);
      Modified;
    finally
      BRE.Free;
    end;
  end;

  function TBaudRateProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paDialog]
  end;

end.




