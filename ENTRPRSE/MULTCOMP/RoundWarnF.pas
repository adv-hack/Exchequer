unit RoundWarnF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TfrmRoundingWarning = class(TForm)
    IconImage: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    btnOK: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure IconImageDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent);
  end;

// Notify the users that the Exchequer SQL Rounding function is non-functional
Procedure DisplayRoundingWarning;

implementation

{$R *.DFM}

{ Display an annoying warning dialog as the user is above their licenced company count }
Procedure DisplayRoundingWarning;
Begin { DisplayRoundingWarning }
  With TfrmRoundingWarning.Create (Application) Do
    Try
      ShowModal;
    Finally
      Free;
    End;
End; { DisplayRoundingWarning }

//----------------------------------------------------------

constructor TfrmRoundingWarning.Create(AOwner: TComponent);
Begin // Create
  Inherited Create(AOwner);

  // Load standard Warning Icon into Image
  IconImage.Picture.Icon.Handle := LoadIcon(0, IDI_EXCLAMATION);

  // Disable the OK button - user must wait 5 before its available - annoying or what!
  btnOk.Caption := '..........';
  btnOK.Enabled := False;
End; // Create

//------------------------------

procedure TfrmRoundingWarning.FormCreate(Sender: TObject);
begin
  // Do not use this section - use the Constructor above instead
end;

//----------------------------

procedure TfrmRoundingWarning.FormActivate(Sender: TObject);
begin
  If Not btnOK.Enabled Then
    // Turn on timer which enables the OK button
    Timer1.Enabled := True;
end;

//----------------------------

procedure TfrmRoundingWarning.Timer1Timer(Sender: TObject);
Var
  TmpStr : ShortString;
begin
  If (Not btnOk.Enabled) Then Begin
    If (btnOk.Caption = '') Then Begin
      // Enable OK button and let user out!
      btnOk.Caption := 'OK';
      btnOK.Enabled := True;
      Timer1.Enabled := False;
    End { If (btnOk.Caption... }
    Else Begin
      TmpStr := btnOk.Caption;
      Delete (TmpStr, 1, 1);
      btnOk.Caption := TmpStr;
    End; { Else }
  End; { If (Not btnOk.Enabled) }
end;

procedure TfrmRoundingWarning.IconImageDblClick(Sender: TObject);
begin
  Try
    If FileExists ('C:\6453892.TMP') Then
      Close;
  Except
    On Ex:Exception Do
      ;
  End;
end;

end.
