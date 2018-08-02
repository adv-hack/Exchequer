unit PostMsgU;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, PostTran, GlobVar;

type
    TSelectedRecords = (selSingle, selTagged, selAll);



  TPostStatusFrm = class(TForm)
    SBSPanel3: TSBSPanel;
    Label1: Label8;
    CanCP1Btn: TButton;
    Label2: TLabel;
    procedure CanCP1BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);

    private

      Running,
      KeepRun    :  Boolean;

      PostTransactions
                 :  TPostTransactions;

      PostMode   : TSelectedRecords;

      KeyV       :  TModalResult;

      procedure ShutDown;


      Procedure Post;

    public
      { Public declarations }
      SingleMode  :  Boolean;

      procedure AdjustWidth(LabNo       :  Integer;
                            AbortMode   :  Byte;
                            PMode       : TSelectedRecords);


  end;

procedure PostSingleTransaction;
procedure PostTaggedTransactions;
procedure PostAllTransactions;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  StrUtil,
  ETStrU,
  ETMiscU,
  VarConst,
  BtrvU2,
  BTKeys1U,
  VARRec2U,
  UseDLLU;

{$R *.DFM}


{ ==================== Check for printout stop ================= }

Procedure Loop_CheckKey(Var Pchk  :  Boolean;
                        Var fRet  :  TModalResult);

Var
  mRet  :  Word;

Begin

  If (PChk) then

  {$B-}

    If (fRet=mrAbort) then
    Begin

      mRet:=MessageDlg('Halted!'+#13+'Continue?',mtConfirmation,[mbYes,mbNo],0);


      PChk:=(mRet<>mrNo);
      fret:=mrNone;
    end;

  {$B+}

end;


procedure TPostStatusFrm.CanCP1BtnClick(Sender: TObject);
begin
  KeyV:=mrAbort;

  Loop_CheckKey(KeepRun,KeyV);

  If (Not KeepRun) then
    CanCp1Btn.Enabled:=BOff;

  If (Assigned(PostTransactions)) then
    PostTransactions.AbortRun:=Not KeepRun;
end;





procedure TPostStatusFrm.ShutDown;

Begin
  If (Assigned(PostTransactions)) then
  Begin
    PostTransactions.Free;
    PostTransactions:=nil;
  end;

  PostMessage(Self.Handle,WM_Close,0,0);
end;


procedure TPostStatusFrm.AdjustWidth(LabNo       :  Integer;
                                     AbortMode   :  Byte;
                                     PMode       : TSelectedRecords);


Begin

  SingleMode:=(AbortMode=0);

  If (Not SingleMode) then
  With CanCP1Btn do
  Begin
    Visible:=BOn;
    Enabled:=BOn;
    Left:=((Self.Width div 2) - (Width div 2));
  end;

  PostMode:=PMode;

  Left := (Screen.Width div 2) - (Width div 2);
  Top := (Screen.Height div 2) - (Height div 2);

end;



procedure TPostStatusFrm.FormCreate(Sender: TObject);
begin
  ClientHeight:=129;
  ClientWidth:=299;

  SingleMode:=BOn;

  KeepRun:=Boff;

  Running:=BOff;
end;


//=======================================================================

procedure TPostStatusFrm.Post;
var
  Res : integer;
begin
  PostTransactions:=TPostTransactions.Create;

  with PostTransactions do
    try
      case PostMode of
        selSingle :
          begin
            Res := InsertTransaction;
            if Res > 0 then
            // WarnUser;
              MessageDlg(Format('Cannot post this transaction, status : %d ' + CRLF + '%s',
                [Res, ErrorMsg(Res)]), mtError, [mbOK], 0)
            else
            if Res < 0 then
              MessageDlg(Format('Unable to post this transaction:' + CRLF + '%s',
                [ErrorMsg(Res)]), mtWarning, [mbOK], 0);

          end;
        selTagged :
          IterateThroughOrders(true);
        selAll :
          IterateThroughOrders(false);
      end;
    finally
      Free;
      PostTransactions:=nil;
    end;
end; // Post



procedure TPostStatusFrm.FormActivate(Sender: TObject);
begin
  If (Not Running) then
  Begin
    Running:=BOn;

    Post;

    ShutDown;
  end;


end;



//=======================================================================

procedure RunPost(SelectedRecords : TSelectedRecords);

Const
    PostTit  :  Array[TSelectedRecords] of String[15] = ('single','tagged','all');

var
  MsgForm      :  TPostStatusFrm;
  CapTit       :  Str255;

begin
  CapTit:='Post '+PostTit[SelectedRecords]+' transactions.';

  MsgForm:=TPostStatusFrm.Create(Application.MainForm);


  try
    With MsgForm do
    Begin
      Caption:=CapTit;

      AdjustWidth(0,Ord(SelectedRecords<>selSingle),SelectedRecords);

      ShowModal;
    end;

  finally
    MsgForm.Free;

  end; {try..}


end; // Post

//-----------------------------------------------------------------------

procedure PostTaggedTransactions;
begin
  RunPost(selTagged);
end;

//-----------------------------------------------------------------------

procedure PostSingleTransaction;
// Notes : Internet daybook files are open
//         A record to post is within the ID, and InvF structures
begin
  RunPost(selSingle);
end;

//-----------------------------------------------------------------------

procedure PostAllTransactions;
begin
  RunPost(selAll);
end;



end.
