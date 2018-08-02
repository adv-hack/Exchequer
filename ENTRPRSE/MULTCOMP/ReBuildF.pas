unit ReBuildF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Setupbas, ExtCtrls, StdCtrls;

type
  TfrmConfirmRebuild = class(TSetupTemplate)
    Label1: TLabel;
    lblCompDets: TLabel;
    Label2: TLabel;
    lblDailyPword: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

Uses VAOUtil;

procedure TfrmConfirmRebuild.FormCreate(Sender: TObject);
begin
  inherited;

  // HM 07/12/04: Changed wording of notice under VAO
  If (VAOInfo.vaoMode = smVAO) Then
  Begin
    lblDailyPword.Caption := 'NOTE: The Special Functions will not available in the Rebuild Module as they are only accessible to the Bureau Administrator.';
  End; // If (VAOInfo.vaoMode = smVAO)
end;

end.
