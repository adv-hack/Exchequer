unit EntOpts;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, RXCtrls;

type
  TfrmEntOptions = class(TSetupTemplate)
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure chkClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoCheckyChecky;
  public
    { Public declarations }
    Procedure BuildModList (Const AvMod, InstMod : String);
    Procedure GetModStrs (Var InstMod : String);
  end;

function GetEntOptions (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.DFM}

function GetEntOptions (var DLLParams: ParamRec): LongBool; StdCall; export;
var
  frmEntOptions                : TfrmEntOptions;
  AvMod, InstMod, DlgPN        : String;
Begin { GetEntOptions }
  Result := False;

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  frmEntOptions := TfrmEntOptions.Create(Application);
  Try
    With frmEntOptions Do Begin
      { Read selected Module info from Setup Script and Initialise Form }
      //GetVariable(DLLParams, 'VAR_AVMOD', AvMod);
      //GetVariable(DLLParams, 'VAR_INSTMOD', InstMod);

      //BuildModList (AvMod, InstMod);

      ShowModal;

      Case ExitCode Of
        'B' : Begin { Back }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
              End;
        'N' : Begin { Next }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                { Save selected Module info to Setup Script }
                //GetModStrs (InstMod);
                //SetVariable(DLLParams, 'VAR_INSTMOD', InstMod);
              End;
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; { With }
  Finally
    frmEntOptions.Free;
  End;
End; { GetEntOptions }


{---------------------------------------------------------------------------}


Procedure TfrmEntOptions.GetModStrs (Var InstMod : String);
Begin { GetModStrs }
  InstMod := '';

  (*
  If chkCore.Checked Then InstMod := InstMod + 'A';
  If chkEBus.Checked Then InstMod := InstMod + 'B';
  If chkEComms.Checked Then InstMod := InstMod + 'C';
  If chkImport.Checked Then InstMod := InstMod + 'D';
  If chkODBC.Checked Then InstMod := InstMod + 'E';
  If chkRepWrt.Checked Then InstMod := InstMod + 'F';
  If chkPervReq.Checked Then InstMod := InstMod + 'G';
  If chkCripple.Checked Then InstMod := InstMod + 'H';
  If chkBarCode.Checked Then InstMod := InstMod + 'I';
  If chkEntFax.Checked Then InstMod := InstMod + 'J';
  *)
End; {  GetModStrs }

Procedure TfrmEntOptions.BuildModList (Const AvMod, InstMod : String);
Var
  I, NextPan : Byte;
  NextTop    : LongInt;

  Procedure SetupPanel (Const ThePanel :  TControl; Const Vis : Boolean);
  Begin { SetupPanel }
    If Vis Then Begin
      With ThePanel Do Begin
        Top := NextTop;
        Inc (NextTop, Height);

        Left := 4;
        Width := 252;
      End; { With }
    End { If }
    Else Begin
      { Not Visible - Hide Panel }
      ThePanel.Visible := False;
    End; { If }
  End; { SetupPanel }

Begin { BuildModList }
  (*
  NextPan := 1;
  NextTop := 0;
  SetupPanel (panEntCore, True);
  SetupPanel (panPervReq, (Pos ('G', AvMod) > 0));
  SetupPanel (Bev1,       True);
  SetupPanel (panEBus,    (Pos ('B', AvMod) > 0));
  SetupPanel (panEComms,  (Pos ('C', AvMod) > 0));
  SetupPanel (panImport,  (Pos ('D', AvMod) > 0));
  SetupPanel (panODBC,    (Pos ('E', AvMod) > 0));
  SetupPanel (panRepWrt,  (Pos ('F', AvMod) > 0));

  { Set default CheckBox values }
  chkCore.Checked :=  (Pos ('A', InstMod) > 0);
    chkBarCode.Checked :=  (Pos ('I', InstMod) > 0);
    chkPervReq.Checked :=  (Pos ('G', InstMod) > 0);

  chkEBus.Checked :=  (Pos ('B', InstMod) > 0);

  chkEComms.Checked :=  (Pos ('C', InstMod) > 0);
    chkEntFax.Checked :=  (Pos ('J', InstMod) > 0);

  chkImport.Checked :=  (Pos ('D', InstMod) > 0);

  chkODBC.Checked :=  (Pos ('E', InstMod) > 0);
    chkCripple.Checked :=  (Pos ('H', InstMod) > 0);

  chkRepWrt.Checked :=  (Pos ('F', InstMod) > 0);

  DoCheckyChecky;
  *)
End; { BuildModList }

{ Enforce relational links between modules }
procedure TfrmEntOptions.DoCheckyChecky;
Begin { DoCheckyChecky }
  (*
  If chkEBus.Checked Or chkEntFax.Checked Then
    chkEComms.Checked := True;
  *)
End; { DoCheckyChecky }

procedure TfrmEntOptions.chkClick(Sender: TObject);
begin
  inherited;

  //DoCheckyChecky;
end;

end.
