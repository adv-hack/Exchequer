unit CIS;

interface

uses
  GlobVar;

type

  ContEmploymentRec = Record
     SuppCode  : string[10];
     WStartDate,
     MStartDate,
     EndDate   : LongDate;
     Weeks,
     Months    : integer;
     TypeWanted : Byte; //0 = unassigned, 1 = Weeks, 2 = Months
  end;

var
  LastEmployment : ContEmploymentRec;
  GlobSDate, GlobEDate : LongDate;

  function ContEmploymentVar(const Supp : string; SDate, EDate : LongDate; WhichOne : integer) : Str20;
  procedure InitLastEmployment;

implementation

uses
  ExWrap1U, BtrvU2, Varconst, BTSupU1, EtDateU, SysUtils, EtStrU;

{ ======================= Calculate if a sub contract employee has worked x weeks or months continously ==================== }
{Suppcode is the suplier code associated with the sub contractor.
SDate,Edate start and end date of purchase invoices to search for.
Will return the period of continous employemtn found in Sdate and EDate.
EWeeks, EMonths, number of contious weeks and months found.
Function returns true id Eweeks or EMonths <>0}

{PR: This is based on EL's code in RepJCE2U (which I don't really understand).
The main difference is that whereas E's code is looking for a period of ce above a certain
number of weeks or months, we're looking for the longest period of ce within the specified
date range.}

Function ContinuousEmploy(SuppCode  :  Str10;
                          SDate,
                          EDate     :  LongDate;
                          EWeeks,
                          EMonths   :  Integer)  :  Boolean;
Const
  Fnum     =  InvF;
  Keypath  =  InvDateK;

Var
  n,fs       :  Byte;

  ResetWeeks,
  ContFound,
  FoundOk    :  Boolean;

  WBeginDate,
  MBeginDate,
  EndDate,
  LastMDate  :  LongDate;
  CEDays,
  CEMonths,
  MDiff,
  CEWeeks    :  Integer;
  KeyChk,
  KeyChk2,
  KeyS2      :  Str255;

  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr
             : LongInt;

  LastIDates : Array[1..7] of LongDate;

  MTExLocal : TdMTExLocalPtr;

  HighWSDate, HighMSDate, HighEDate : LongDate;
  HighWeeks, HighMonths : Integer;

Begin
  Result:=BOff;

  HighWeeks := 0;
  HighMonths := 0;
  HighWSDate := '';
  HighMSDate := '';
  HighEDate := '';

  New(MTExLocal, Create(21));
  Try
    TmpKPath:=GetPosKey;

    With MTExLocal^ do
    Begin
    {$IFDEF SENT}
      LSetDrive := SetDrive;
    {$ENDIF}
      Open_System(InvF, InvF);

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      KeyChk:=SDate; KeyChk2:=EDate;

      KeyS2:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS2);

      CEWeeks:=0; FillChar(LastIDates,Sizeof(LastIDates), 0);  CEDays:=0;  CEMonths:=0;  MDiff:=0;

      LastMDate:='';  ResetWeeks:=BOff;  ContFound:=BOff;  WBeginDate:=''; MBeginDate := ''; EndDate:='';

      While (LStatusOk) and (CheckKeyRange(KeyChk,KeyChk2,KeyS2,Length(KeyChk),BOff)) and (Not ContFound) do
      With LInv do
      Begin
        If (CheckKey(SuppCode,CustCode,Length(SuppCode),BOff)) and (InvDocHed In CISDocSet-CreditSet) then
        Begin
          fs:=0;  FoundOk:=BOff;

          {We have to compre against a whole week, or we will only be able to track exact 7 day gaps}
          For n:=Low(LastIDates) to High(LastIDates) do
          Begin
            FoundOk:=(TransDate=LastIDates[n]);

            If (FoundOk) then
              Break
            else
              If (LastIDates[n]='') and (fs=0) then
                fs:=n;
          end;

          If (Not FoundOk) and (fs>0) then
            LastIDates[fs]:=TransDate;

          ResetWeeks:=BOn;

          For n:=Low(LastIDates) to High(LastIDates) do
          Begin

            If (LastIDates[n]<>'') then {We have to start count again}
            Begin
              CEDays:=NoDays(LastIDates[n],TransDate);

              If (CEDays>7) then {There is a break in invoice run, so we count again}
              Begin
                LastIDates[n]:='';
              end
              else
              Begin
                If (fs<>n) then {Don't reset if we are comparing self}
                  ResetWeeks:=BOff;

                If (CEDays=7) then
                Begin
                  If (WBeginDate='') then
                    WBeginDate:=LastIDates[n];

                  Inc(CEWeeks);
                  LastIDates[n]:='';
                end;
              end;

              If (LastIDates[n]='') and (Not FoundOk) and (fs=0) then
              Begin
                LastIDates[n]:=TransDate;
                fs:=n;
              end;

            end; {Ignore blank slots}
          end; {Loop}

          If (ResetWeeks) then
          Begin
            if CEWeeks > HighWeeks then
            begin
              HighWSDate := WBeginDate;
              HighEDate := EndDate;
              HighWeeks := CEWeeks;
              HighMonths := CEMonths;
            end;
            CEWeeks:=0;
            WBeginDate:='';
          end;

          If (LastMDate='') then {We have to start count again}
          begin
            LastMDate:=TransDate;
            if HighMSDate = '' then
              HighMSDate := TransDate;
          end
          else
          Begin
            MDiff:=MonthDiff(LastMDate,TransDate);

            If (MDiff>1) then {There is a break in invoice run, so we count again}
            Begin
              if CEMonths > HighMonths then
                HighMSDate := MBeginDate;
              LastMDate:=''; CEMonths:=0;  MBeginDate:='';
            end
            else
            Begin
              If (MDiff<>0) then
                Inc(CEMonths);

              If (MBeginDate='') then
                MBeginDate:=LastMDate;

              LastMDate:=TransDate;
            end;


          end;

          If (TransDate>EndDate) then
            EndDate:=TransDate;

        end;

  {      With CRepParam^ do
          ContFound:=(((CEWeeks>ExpTol) and (RepType=1)) or ((CEMonths>ExpTol) and (RepType=0)));}

       { If (Not ContFound) then}
          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS2);

      end;

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
    end; {With..}

    if CEWeeks > HighWeeks then
    begin
      HighWSDate := WBeginDate;
      HighEDate := EndDate;
      HighWeeks := CEWeeks;
      HighMonths := CEMonths;
    end;

    if ((LastEmployment.TypeWanted in [0, 1]) and (HighWeeks > 0)) or
       ((LastEmployment.TypeWanted = 2) and (HighMonths > 0)) then
    begin
      LastEmployment.WStartDate := HighWSDate;
      LastEmployment.MStartDate := HighMSDate;
      LastEmployment.EndDate := HighEDate;
      LastEmployment.Weeks := HighWeeks;
      LastEmployment.Months := HighMonths;
    end
    else
    begin
      LastEmployment.WStartDate := '';
      LastEmployment.MStartDate := '';
      LastEmployment.EndDate := '';
      LastEmployment.Weeks := HighWeeks;
      LastEmployment.Months := HighMonths;
    end;


{    EWeeks:=HighWeeks; EMonths:=HighMonths;
    SDate:=HighSDate; EDate:=HighEDate;}

{    If (ContFound) then
    Begin
      SDate:=BeginDate; EDate:=EndDate;
    end;
    Result:=ContFound;  }

  Finally
    Dispose(MTExLocal);
  End;
end;

function ContEmploymentVar(const Supp : string; SDate, EDate : LongDate; WhichOne : integer) : Str20;
begin
  if Trim(Supp) <> Trim(LastEmployment.SuppCode) then
  begin
    LastEmployment.SuppCode := Trim(Supp);
    LastEmployment.WStartDate := SDate;
    LastEmployment.MStartDate := SDate;
    LastEmployment.EndDate := EDate;
    LastEmployment.Weeks := 0;
    LastEmployment.Months := 0;


    Case WhichOne of
      2, 3 : if LastEmployment.TypeWanted = 0 then
               LastEmployment.TypeWanted := WhichOne - 1;
    end;

    with LastEmployment do
      ContinuousEmploy(SuppCode, WStartDate, EndDate, Weeks, Months);

  end;

  Case WhichOne of
    0  : if LastEmployment.TypeWanted = 2 then
           Result := LastEmployment.MStartDate
         else
           Result := LastEmployment.WStartDate;
    1  : Result := LastEmployment.EndDate;
    2  : Result := Form_Int(LastEmployment.Weeks, 0);
    3  : Result := Form_Int(LastEmployment.Months, 0);
  end;

end;

procedure InitLastEmployment;
begin
  FillChar(LastEmployment, SizeOf(LastEmployment), 0);
  GlobSDate := '';
  GlobEDate := '';
end;

Initialization

end.
