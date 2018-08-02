unit Utils;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, VarConst, CardProc,
  StdCtrls, TEditVal, NeilProc, EXWrap1U, GlobVar, BTKeys1U, BtrvU2, BTSupU1,
  ExtCtrls, MpComms, APIUtil, TCustom, Mask, ComCtrls;

type
  TFrmUtilities = class(TForm)
    btnDelete: TSBSButton;
    btnClose: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    edTrackNo: TEdit;
    Button5: TButton;
    Bevel2: TBevel;
    Label1: TLabel;
    SBSUpDown1: TSBSUpDown;
    edTillNo: Text8Pt;
    Label2: TLabel;
    Bevel4: TBevel;
    Button6: TButton;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUtilities: TFrmUtilities;

implementation

uses MainF, Comms;

{$R *.DFM}

procedure TFrmUtilities.btnDeleteClick(Sender: TObject);
var
  ExLocal : tdExLocal;
  KeyS : str255;
  iPos, iNewLength, iStatus : integer;
  aCust : array of CustRec;
begin
  if MsgBox('Are you sure you want to duplicate the customer file ?',mtConfirmation
  ,[mbYes,mbNo],mbNo,'Duplicate Cust.Dat') = mrYes then begin
    screen.cursor := crHourglass;
    ExLocal.Create;
    with ExLocal do begin

      {read in records before duff record}

      iNewLength := 1;
      {Get first Record}
      KeyS := '';
      iStatus := Find_Rec(B_GetFirst,F[CustF],CustF,LRecPtr[CustF]^,CustCodeK,KeyS);
      LGetRecAddr(CustF);
      while (iStatus = 0) do begin
        setlength(aCust,iNewLength);
        aCust[iNewLength - 1] := LCust;

        {Get Next Record}
        iStatus := Find_Rec(B_GetNext,F[CustF],CustF,LRecPtr[CustF]^,CustCodeK,KeyS);
        LGetRecAddr(CustF);
        inc(iNewLength);
      end;{while}


      {read in records after duff record}

      {get last record}
      KeyS := '';
      iStatus := Find_Rec(B_GetLast,F[CustF],CustF,LRecPtr[CustF]^,CustCodeK,KeyS);
      LGetRecAddr(CustF);
      while (iStatus = 0) do begin
        setlength(aCust,iNewLength);
        aCust[iNewLength - 1] := LCust;

        {Get Previous Record}
        iStatus := Find_Rec(B_GetPrev,F[CustF],CustF,LRecPtr[CustF]^,CustCodeK,KeyS);
        LGetRecAddr(CustF);
        inc(iNewLength);
      end;{while}

      Close_File(F[CustF]);
      FileNames[CustF] := Path1 + 'c:\CUST.NEW';
      Open_File(F[CustF],FileNames[CustF],0);

      {write new file}
      For iPos := 0 to iNewLength - 2 do begin
        {write record}
        LCust := aCust[iPos];
        Add_Rec(F[CustF],CustF,LRecPtr[CustF]^,CustCodeK);
      end;{for}

      setlength(aCust,0);
      Destroy;
    end;{with}
    screen.cursor := crdefault;
    MsgBox('Done',mtInformation,[mbOK],mbOK,'Duplicate Cust.Dat');
  end;{if}
end;

procedure TFrmUtilities.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFrmUtilities.Button1Click(Sender: TObject);
begin
  SetCommsWorking(TRUE);
  frmMain.DisableControls;
end;

procedure TFrmUtilities.Button2Click(Sender: TObject);
var
  aClerkData : TaClerkData;
begin
  FrmComms.GetClerkData(StrToInt(edTillNo.Text), TRUE, aClerkData)
end;

procedure TFrmUtilities.Button3Click(Sender: TObject);
var
  aHourSalesRecs : TaHourSalesRecs;
begin
  FrmComms.GetHourlySales(StrToInt(edTillNo.Text), TRUE, aHourSalesRecs);
end;

procedure TFrmUtilities.Button4Click(Sender: TObject);
var
  MemSalesRec : TMemSalesRec;
begin
  FillChar(MemSalesRec,SizeOf(MemSalesRec),#0);
  with FrmComms do begin
    if WaitForMemberInfo(StrToInt(edTillNo.Text), StrToInt(edTrackNo.Text), MemSalesRec)
    then SetMemberInfo(StrToInt(edTillNo.Text), MemSalesRec, TRUE, TRUE);
  end;{with}
end;

procedure TFrmUtilities.Button5Click(Sender: TObject);
var
  MemSalesRec : TMemSalesRec;
begin
  FrmComms.WaitForMemberInfo(StrToInt(edTillNo.Text), StrToInt(edTrackNo.Text), MemSalesRec)
end;

procedure TFrmUtilities.Button6Click(Sender: TObject);
begin
  Button6.Caption := MoneyToStr(FrmComms.GetBestBalance(1000, 1000, TRUE));
end;

end.
