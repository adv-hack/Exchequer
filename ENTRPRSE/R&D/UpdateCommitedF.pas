unit UpdateCommitedF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, BtSupU1;

type
  TfrmUpdateCommittedBal = class(TForm)
    lblProgress: TLabel;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FRunning : Boolean;
    procedure Execute;
    procedure ShowProgress(const s : string);
    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
  public
    { Public declarations }

  end;

  procedure UpdateCommittedValues;

var
  frmUpdateCommittedBal: TfrmUpdateCommittedBal;

implementation

Uses
  GlobVar,
  VARRec2U,
  VarConst,
  MiscU,
  BTrvU2,
  ETStrU,
  ETMiscU,
  ETDateU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  InvListU,
  CurrncyU,
  Invct2sU,
  ApiUtil;


{$R *.dfm}

procedure UpdateCommittedValues;
begin
  Screen.Cursor := crHourGlass;
  with TfrmUpdateCommittedBal.Create(Application) do
  Try
    ShowModal;
  Finally
    Free;
    Screen.Cursor := crDefault;
    msgBox('Update complete', mtInformation, [mbOK], mbOK, 'Update committed balances');
  End;
end;

procedure TfrmUpdateCommittedBal.FormActivate(Sender: TObject);
begin
  if not FRunning then
  begin
    //Start update
    FRunning := True;
    SendMessage(Handle,WM_CustGetRec,0,0);
  end;
end;

procedure TfrmUpdateCommittedBal.FormCreate(Sender: TObject);
begin
  FRunning := False;
end;

procedure TfrmUpdateCommittedBal.ShowProgress(const s: string);
begin
  lblProgress.Caption := s;
  lblProgress.Refresh;
  Application.ProcessMessages;
end;

procedure TfrmUpdateCommittedBal.Execute;
const
  RunNos : Array[1..2] of Integer = (OrdUSRunNo, OrdUPRunNo);
var
  Res, i : Integer;
  sKey : Str255;
  KPath : Integer;
  RecAddr : longint;
  NewOS, OldOS : Double;
  UOR : Byte;
begin
  {$IFDEF SOP}
  //Store position in transaction file
  Res := Presrv_BTPos(InvF, KPath, F[InvF], RecAddr, False, False);

  Try
    //Iterate through Run Nos for unposted SORs & PORs
    for i := 1 to 2 do
    with Inv do
    begin
      sKey := FullNomKey(RunNos[i]);

      Res := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvRNoK, sKey);
      while (Res = 0) and (Inv.RunNo = RunNos[i]) do
      begin

        //Set values according to change in system setup
        UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

        if Syss.IncludeVATInCommittedBalance then
        begin
          NewOS := TransOSWithVAT(Inv);
          OldOS := Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);
        end
        else
        begin
          OldOS := TransOSWithVAT(Inv);
          NewOS := Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);
        end;

        //Update with difference between new and old o/s value. (For some reason, UpdateOrdBal needs value to be multiplied by -1)
        UpdateOrdBal(Inv, (NewOS - OldOS) * DocCnst[InvDocHed] * DocNotCnst, 0, 0, False, 0);

        ShowProgress(Inv.OurRef);

        Res := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvRNoK, sKey);
      end;
    end; //for i := 1 to 2
  Finally
    //restore position
    Res := Presrv_BTPos(InvF, KPath, F[InvF], RecAddr, True, False);

    //Allow close
    FRunning := False;

    //Close
    PostMessage(Handle, WM_CLOSE, 0, 0);
  End;
  {$ENDIF}
end;

procedure TfrmUpdateCommittedBal.WMCustGetRec(var Message: TMessage);
begin
  Execute;
end;

procedure TfrmUpdateCommittedBal.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  //don't allow form to close while process is executing
  CanClose := not FRunning;
end;

end.
