unit statprnt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,VarRec2U, BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;

type

  TStatementReport = Object(TGenReport)
    HeaderRec : eBankHRecType; //Statement Header
    Balance : Double;
    GLDescr : string;
    function GetReportInput  :  Boolean; virtual;
    Procedure PrintReportLine; Virtual;
    function IncludeRecord  :  Boolean; Virtual;
    Procedure RepSetTabs; Virtual;
    procedure RepPrintPageHeader; Virtual;
    Procedure PrintEndPage; Virtual;
  end;

  Procedure AddBankStatementRep2Thread(LMode    :  Byte;
                                       HedRec   : eBankHRecType;
                                       GLDesc   : string;
                                       AOwner   :  TObject);


implementation

uses
  Dialogs,
  Forms,
  Printers,
  TEditVal,
  ETDateU,
  ETStrU,
  ExThrd2U,
  BtSupU1,
  RpDefine;

Function ReverseFullNomKey(ncode  :  Longint)  :  Str20;
Var
  TmpStr, TmpStr2  :  Str20;
  i : integer;
Begin
  FillChar(TmpStr,Sizeof(TmpStr),0);
  FillChar(TmpStr2,Sizeof(TmpStr2),0);

  Move(ncode,TmpStr[1],Sizeof(ncode));

  TmpStr[0]:=Chr(Sizeof(ncode));
  TmpStr2[0] := TmpStr[0];
  //reverse string
  for i := 1 to 4 do
    TmpStr2[i] := TmpStr[5-i];

  Result := TmpStr2;
end;


function TStatementReport.GetReportInput  :  Boolean;
begin
  RepTitle:= 'Bank Statement';
  PageTitle := 'Statement for ' + GLDescr;
  THTitle:=RepTitle;

  RFnum:=MLocF;
  Result := True;
end;

procedure TStatementReport.RepPrintPageHeader;
begin
  With RepFiler1 do
  Begin
    DefFont(0,[fsBold]);

    SendLine (#9 + 'Date'+ #9 + 'Reference' + #9#9 + 'Credit' + #9 + 'Debit' );

    DefFont(0,[]);
  end;
end;

Procedure TStatementReport.PrintReportLine;
var
  sCred, sDeb : string;
begin

  With MTExLocal^ do
  Begin
    DefFont (0,[]);

    with LMLocCtrl^.eBankLRec do
    begin
      sCred := '';
      sDeb := '';
      if ebLineValue > 0 then
        sCred := FormatFloat(GenRealMask,ebLineValue)
      else
        sDeb := FormatFloat(GenRealMask,ebLineValue);
      SendLine (#9 + POutDate(ebLineDate) +
                #9 + Trim(ebLineRef) +
                #9#9 + sCred +
                #9 + sDeb);

      Balance := Balance + ebLineValue;
    end;

  end;
end;

function TStatementReport.IncludeRecord  :  Boolean;
begin
  with MTExLocal^.LMLocCtrl^ do
    Result := (RecPFix = LteBankRCode) and
              (SubType = '5') and
              (eBankLRec.ebLineIntRef = HeaderRec.ebIntRef);
end;

Procedure TStatementReport.RepSetTabs;
begin
  With RepFiler1 do
  Begin
    SetTab (MarginLeft, pjLeft, 30, 4, 0, 0); //Date
    SetTab (NA, pjLeft, 118, 4, 0, 0);        //Ref
    SetTab (NA, pjLeft, 14, 4, 0, 0);         //Balance string
    SetTab (NA, pjRight, 18, 4, 0, 0);        //Credit
    SetTab (NA, pjRight, 18, 4, 0, 0);        //Debit
{    SetTab (NA, pjLeft, 31, 4, 0, 0);
    SetTab (NA, pjLeft, 20, 4, 0, 0);
    SetTab (NA, pjRight,20, 4, 0, 0);}

    SetTabCount;
  end;
end;

Procedure AddBankStatementRep2Thread(LMode    :  Byte;
                                     HedRec   :  eBankHRecType;
                                     GLDesc   : string;
                                     AOwner   :  TObject);


Var
  EntTest  :  ^TStatementReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;
        HeaderRec := HedRec;
        RepKey := LteBankRCode + '5' +
                  ReverseFullNomKey(HeaderRec.ebAccNOM) + ReverseFullNomKey(HeaderRec.ebIntRef);
        Balance := 0.0;
        HideRecCount := True;
        GLDescr := GLDesc;
        If (Create_BackThread) and (Start) then
        Begin
          With BackThread do
            AddTask(EntTest,ThTitle);
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;



procedure TStatementReport.PrintEndPage;
var
  sCred, sDeb : string;
begin
  with RepFiler1 do
  begin
    sCred := '';
    sDeb := '';
    if Balance >= 0 then
      sCred := FormatFloat(GenRealMask,Balance)
    else
      sDeb := FormatFloat(GenRealMask,Balance);
    DefLine(-2,TabStart(1),TabEnd(5),0);
    SendLine(#9 + ' ' + #9#9 + 'Balance:' + #9 + sCred +
             #9 + sDeb);
    SendLine('');
  end;

  inherited PrintEndPage;
end;

end.
