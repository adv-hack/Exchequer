unit links;

interface

Uses
  Classes,
  GlobVar,
  {$IFDEF WIN32}
  VarRec2U,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst,
  VarCnst3,
  Dialogs,
  BtKeys1U,
  BtSupU1;

FUNCTION EX_GETLINK(P          : Pointer;
                    PSize      : LongInt;
                    SearchKey  : PChar;
                    SearchPath : SmallInt;
                    SearchMode : SmallInt;
                    Lock       : WordBool)  : SmallInt;
                            {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_STORELINK(P          : Pointer;
                      PSize      : LongInt;
                      SearchPath : SmallInt;
                      SearchMode : SmallInt)  : SmallInt;
                            {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_DELETELINK(P          : Pointer;
                       PSize      : LongInt;
                       SearchPath : SmallInt) : SmallInt;
                            {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

{$IFDEF COMTK}
procedure LetterToTKLetter(Lett : btLetterType; var TKLett : TBatchLinkRec);
procedure LinkToTKLink(Link : btLinkType; var TKLink : TBatchLinkRec);
procedure TKLetterToLetter(var Lett : btLetterType; TKLett : TBatchLinkRec);
procedure TKLinkToLink(var Link : btLinkType; TKLink : TBatchLinkRec);
function NomKeyFull(const s : ShortString) : longint;
{$ENDIF}



implementation

uses
  BtrvU2, EtDateU, SysUtils, DllMiscU, EtStrU, DllErrU, DLSQLSup;


const
  AttachSet = ['C','E','J', 'K','S','T'];

function NomKeyFull(const s : ShortString) : longint;
begin
  if length(s) = 4 then
    Move(s[1], Result, 4)
  else
    Result := 0;
end;


function RemoveZeros(const s : string) : string;
begin
//Need to remove #0s from end of fullnomcode before calling CheckExsists
  Result := s;
  While (Length(Result) > 0) and (Result[Length(Result)] = #0) do
    Delete(Result, Length(Result), 1);
end;

//PR: 02/03/2015 ABSEXCH-16179 Functions copied from LettrDlg.pas to build keystring
Function LDateKey (Const TheDate : LongDate) : String;
begin
  Result := ConstStr(' ', SizeOf (TheDate));
  Move (TheDate, Result[1], SizeOf (TheDate));
end;

Function TimeKey (Const TheTime : TimeTyp) : String;
begin
  Result := ConstStr(' ', SizeOf (TheTime));
  Move (TheTime, Result[1], SizeOf (TheTime));
end;


function StrToTimeTyp(TimeStr : string) : TimeTyp;
begin
   FillChar(Result, SizeOf(Result), 0);
   if Trim(TimeStr) <> '' then
   Try
     Result.HH := StrToInt(Copy(TimeStr, 1, 2));
     Result.MM := StrToInt(Copy(TimeStr, 4, 2));
     Result.SS := StrToInt(Copy(TimeStr, 7, 2));
   Except
   End;
end;

function AddZero(const s : string) : String;
begin
  if Length(s) = 1 then
    Result := '0' + s
  else
    Result := s;
end;

function TimeTypToStr(T : TimeTyp) : String;
begin
  Result := AddZero(IntToStr(T.HH)) + ':' +
            AddZero(IntToStr(T.MM)) + ':' +
            AddZero(IntToStr(T.SS));
end;

function LinkKeyString(TKLink : TBatchLinkRec) : ShortString;
begin
  //PR: 17/02/2015 ABSEXCH-14686 Amended to use LDateKey function to build keystring correctly
  with TKLink do
    Case lkAttachTo of
      'C', 'S', 'E' :
          Result := Copy(FullCustCode(lkCode) + LDateKey(lkDate) +
                                             TimeKey(StrToTimeTyp(lkTime)), 1, 20);
      else
      begin
        Result := Copy(FullNomKey(lkFolioKey) + LDateKey(lkDate) +
                                              TimeKey(StrToTimeTyp(lkTime)), 1, 20);
      end;
    end;

end;


function CompareLetter(Lett : btLetterType; TKLett : TBatchLinkRec) : Boolean;
begin
  Result := {(Trim(TkLett.lkUserCode) = Trim(Lett.UserCode)) and}
           (TkLett.lkDate = Lett.LtrDate) and
           (TkLett.lkTime = TimeTypToStr(Lett.LtrTime)) and
           (Trim(Lett.CustomKey) = Trim(LinkKeyString(TKLett)));
end;

function CompareLink(Link : btLinkType; TKLink : TBatchLinkRec) : Boolean;
begin
  Result := {(Trim(TkLink.lkUserCode) = Trim(Link.UserCode)) and }
           (TkLink.lkDate = Link.LtrDate) and
           (TkLink.lkTime = TimeTypToStr(Link.LtrTime)) and
           (Trim(Link.CustomKey) = Trim(LinkKeyString(TKLink)));
end;

procedure LetterToTKLetter(Lett : btLetterType; var TKLett : TBatchLinkRec);
begin
  TkLett.lkDate := Lett.LtrDate;
  TkLett.lkTime := TimeTypToStr(Lett.ltrTime);
  TkLett.lkUserCode := Lett.UserCode;
  TkLett.lkLetterDescription := Lett.LtrDescr;
  TkLett.lkLetterFileName := Lett.LtrPath;

  TKlett.lkLetterLink := 'L';
  TkLett.lkLinkType := 0;

end;

procedure LinkToTKLink(Link : btLinkType; var TKLink : TBatchLinkRec);
begin
  TKLink.lkDate := Link.LtrDate;
  TKLink.lkTime := TimeTypToStr(Link.ltrTime);;
  TKLink.lkUserCode := Link.UserCode;
  TKLink.lkLinkDescription := Link.LtrDescr;
  TKLink.lkLinkFileName := Link.LtrPath;

  TKLink.lkLetterLink := 'K';
  TKLink.lkLinkType := Ord(Link.Version) - 1;
end;

procedure TKLetterToLetter(var Lett : btLetterType; TKLett : TBatchLinkRec);
//Can only change description on a letter + can't add
begin
{   Lett.LtrDate := TkLett.lkDate;
   Lett.UserCode := LJVar(TkLett.lkUserCode, 10);}
   Lett.LtrDescr := TkLett.lkLetterDescription;
//   Lett.LtrPath := TkLett.lkLetterFileName;

{   Lett.LtrTime.HH := StrToInt(Copy(TKLett.lkTime, 1, 2));
   Lett.LtrTime.MM := StrToInt(Copy(TKLett.lkTime, 4, 2));
   Lett.LtrTime.SS := StrToInt(Copy(TKLett.lkTime, 7, 2));

   Lett.Version := DocWord95;}

end;

procedure TKLinkToLink(var Link : btLinkType; TKLink : TBatchLinkRec);
begin
   Link.LtrDate := TkLink.lkDate;
   Link.UserCode := LJVar(TkLink.lkUserCode, 10);
   Link.LtrDescr := TkLink.lkLinkDescription;
   Link.LtrPath := TkLink.lkLinkFileName;

   Link.LtrTime.HH := StrToInt(Copy(TKLink.lkTime, 1, 2));
   Link.LtrTime.MM := StrToInt(Copy(TKLink.lkTime, 4, 2));
   Link.LtrTime.SS := StrToInt(Copy(TKLink.lkTime, 7, 2));

   Link.Version := btLetterDocType(TKLink.lkLinkType + 1);
   //PR: 16/02/2017 ABSEXCH-18158 The spare1 field is part of the index but
   //wasn't being blanked, causing find to fail on get equal.
   FillChar(Link.Spare1, SizeOf(Link.Spare1), 0);
end;

function UserExists(const UserName : string) : Boolean;
var
  TUser : String;
  KeyS : Str255;
  Status : SmallInt;
begin
  TUser:=LjVar(UpperCase(UserName),LogInKeyLen); {LoginKeyLen);}

  KeyS:=FullPWordKey(PassUCode,C0,TUser);  {RecPFix, SubType, UserName}
  Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyS);

  Result := Status = 0;
end;



FUNCTION EX_GETLINK(P          : Pointer;
                    PSize      : LongInt;
                    SearchKey  : PChar;
                    SearchPath : SmallInt;
                    SearchMode : SmallInt;
                    Lock       : WordBool)  : SmallInt;
var
  Res : SmallInt;
  LinkRec : ^TBatchLinkRec;
  KeyS : Str255;
  Locked : Boolean;
begin
  LastErDesc:='';


  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchLinkRec)) then
  Begin
    If (Not (SearchPath In [0..1])) then
      SearchPath:=0;

      LinkRec := P;
      KeyS := StrPas(SearchKey);

      with LinkRec^ do
      begin

        if SearchPath = 1 then //on user
          KeyS := 'W' + LinkRec.lkAttachTo + Trim(KeyS)
        else
        begin
          Case lkAttachTo of
            'C',
            'S',
            'E'   : KeyS := FullCustCode(KeyS);
            'J',
            'K',
            'T'   : KeyS := FullNomKey(lkFolioKey); //PR: 19/02/2015 ABSEXCH-14686

            else
              KeyS := '';
          end; //Case

          //PR: 17/02/2015 ABSEXCH-14686 Use LDateKey to build CustomKey correctly
          KeyS := 'W' + LinkRec.lkAttachTo + {LJVar(KeyS, 6)}
                            Copy(KeyS + LDateKey(lkDate) + TimeKey(StrToTimeTyp(lkTime)), 1, 20);
        end; //else

        Case SearchMode of
          B_GetFirst  : begin
                          SearchMode := B_GetGEq;
                          if LinkRec.lkAttachTo in AttachSet then
                            KeyS := 'W' + LinkRec.lkAttachTo + #0
                          else
                            KeyS := 'WC' + #0;
                        end;
          B_GetLast   : begin
                          SearchMode := B_GetLessEq;
                          if LinkRec.lkAttachTo in AttachSet then
                            KeyS := 'W' + LinkRec.lkAttachTo + #255
                          else
                          KeyS := 'WT' + #255;
                        end;
        end;//case

        UseVariant(F[MiscF]);
        Result := Find_Rec(SearchMode, F[MiscF], MiscF, RecPtr[MiscF]^, SearchPath, KeyS);

        if Result = 0 then
        begin

          if (MiscRecs^.RecMfix = 'W') and ((MiscRecs^.SubType = lkAttachTo) or
                                             not (lkAttachTo in AttachSet))
                                       and (MiscRecs^.SubType in AttachSet) then
          begin
            if lkAttachTo in ['C','S','E'] then
            begin
              LinkRec^.lkCode := FullCustCode(MiscRecs.btLetterRec.AccCode);
              lkFolioKey := 0;
            end
            else
            begin
              LinkRec^.lkCode := '';
              LinkRec^.lkFolioKey := NomKeyFull(MiscRecs.btLetterRec.AccCode);
            end;

            LinkRec^.lkAttachTo := MiscRecs^.SubType;


            if MiscRecs.btLetterRec.Version = DocWord95 then
              LetterToTKLetter(MiscRecs.btLetterRec, LinkRec^)
            else
              LinkToTKLink(MiscRecs.btLinkRec, LinkRec^);

              If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
              {$IFDEF WIN32}
              begin
                UseVariant(F[MiscF]);
                If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,MiscF,SilentLock,Locked)) then
                  Result:=0;
                // If not locked and user hits cancel return code 84
                if (Result = 0) and not Locked then
                  Result := 84;
              end;
              {$ELSE}
              Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,MiscF,SilentLock,Locked));
              {$ENDIF}


          end //if Correct rectype found
          else
          begin
            if SearchMode = B_GetEq then
              Result := 4
            else
              Result := 9;
          end; //else

        end; //if Result = 0

      end;

  end
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(159, Result);

end;

function ValidateLink(LinkRec : TBatchLinkRec; UpdateMode : SmallInt) : SmallInt;
var
  KeyS : Str255;
  td, tm, ty : Word;
begin
  Result := 0;
  with LinkRec do
  begin
    Case lkLetterLink of
      'L'  :  if Trim(lkLetterFileName) = '' then Result := 30000;
      'K'  :  if Trim(lkLinkFileName) = '' then Result := 30000;
      else
        Result := 30001
    end;//Case


{    if not UserExists(lkUserCode) then
      Result := 30002;}

    Case lkAttachTo of
       'C',
       'S'  :  begin
                 KeyS := FullCustCode(lkCode);
                 if not CheckExsists(KeyS, CustF, CustCodeK) then
                   Result := 30004;
               end;
       'E'  : begin
                 //PR: 08/11/2011 v6.9 Changed from using FullEmpCode, which adds #0s and wasn't finding the record
                 //Changed to use JMiscF rather than CustF to pass into CheckExsists. ABSEXCH-11646
                 KeyS := PartCCKey(JARCode,JASubAry[3])+LJVar(UpperCase(lkCode), 6);
                 if not CheckExsists(KeyS, JMiscF, JMK) then
                   Result := 30004;
              end;
       'J'  : begin
                 KeyS := RemoveZeros(FullNomKey(lkFolioKey));
                 if not CheckExsists(KeyS, JobF, JobFolioK) then
                   Result := 30004;
               end;
       'K'  :  begin
                 KeyS := RemoveZeros(FullNomKey(lkFolioKey));
                 if not CheckExsists(KeyS, StockF, StkFolioK) then
                   Result := 30004;
               end;
       'T'  :  begin
                 KeyS := RemoveZeros(FullNomKey(lkFolioKey));
                 if not CheckExsists(KeyS, InvF, InvFolioK) then
                   Result := 30004;
               end;
       else
         Result := 30003;
    end; //Case

    DateStr(lkDate,Td,Tm,Ty);
    if not ((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0)) then
      Result := 30005;

    Try
      td := StrToInt(Copy(lkTime, 1, 2));
      tm := StrToInt(Copy(lkTime, 4, 2));
      ty := StrToInt(Copy(lkTime, 7, 2));
      if not (td in [0..23]) and (tm in [0..59]) and (ty in [0..59]) then
        Result := 30006;
    Except
      Result := 30006;
    End;

    if lkLetterLink = 'K' then
      if not (lkLinkType in [0..9]) then
        Result := 30007;


  end;//with


end;


FUNCTION EX_STORELINK(P          : Pointer;
                      PSize      : LongInt;
                      SearchPath : SmallInt;
                      SearchMode : SmallInt)  : SmallInt;
var
  Res : SmallInt;
  LinkRec : ^TBatchLinkRec;
  KeyS : Str255;
  TempRes : Boolean;
begin
  LastErDesc:='';


  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchLinkRec)) then
  Begin
    If (Not (SearchPath In [0..1])) then
      SearchPath:=0;

      LinkRec := P;

      if (LinkRec^.lkLetterLink = 'L') and (SearchMode = B_Insert) then
        Result := 30002
      else
      begin
        with LinkRec^ do
        begin
          //If adding record, default date and time if not set
          if SearchMode = B_Insert then
          begin
            if Trim(lkDate) = '' then lkDate := Today;
            if Trim(lkTime) = '' then lkTime := FormatDateTime('hh:nn:ss', Now);
          end;
        end;

        Result := ValidateLink(LinkRec^, SearchMode);

        if Result = 0 then
        begin

          with LinkRec^ do
          begin
            if SearchMode = B_Update then
            begin
              if lkLetterLink = 'L' then
                TempRes := CompareLetter(MiscRecs^.btLetterRec, LinkRec^)
              else
                TempRes := CompareLink(MiscRecs^.btLinkRec, LinkRec^);

              if not TempRes then
                Result := 4
              else
              if (lkLetterLink = 'L') and (Trim(MiscRecs^.btLetterRec.LtrPath) <> Trim(lkLetterFileName)) then
                Result := 30008;
            end;

            if Result = 0 then
            begin
              LinkRec^.lkUserCode := UpperCase(LinkRec^.lkUserCode);
              if lkLetterLink = 'L' then
                TKLetterToLetter(MiscRecs^.btLetterRec, LinkRec^)
              else
                TKLinkToLink(MiscRecs^.btLinkRec, LinkRec^);

              if SearchMode = B_Update then
                 Result := Put_Rec(F[MiscF], MiscF, RecPtr[MiscF]^, SearchPath)
              else
              begin
                MiscRecs^.RecMfix := 'W';
                MiscRecs^.SubType := lkAttachTo;
                //PR: 17/02/2015 ABSEXCH-14686 Use LDateKey to build CustomKey correctly
                Case lkAttachTo of
                  'C', 'S', 'E' :
                    begin
                      MiscRecs^.btLetterRec.CustomKey := Copy(FullCustCode(lkCode) + LDateKey(lkDate) +
                                                         TimeKey(StrToTimeTyp(lkTime)), 1, 20);
                      MiscRecs.btLetterRec.AccCode := FullCustCode(lkCode);
                    end;
                  else
                  begin
                    MiscRecs^.btLetterRec.CustomKey := Copy(FullNomKey(lkFolioKey) + LDateKey(lkDate) +
                                                          TimeKey(StrToTimeTyp(lkTime)), 1, 20);
                    MiscRecs^.btLetterRec.AccCode := FullNomKey(lkFolioKey);
                  end;
                end;

                MiscRecs^.btLetterRec.UserKey := LJVar(lkUserCode, 20);

                Result := Add_Rec(F[MiscF], MiscF, RecPtr[MiscF]^, SearchPath);
              end;
            end;
          end; //with LinkRec^
        end; //if Result = 0
      end; //not letter or B_Update
  end //(P<>Nil) and (PSize=Sizeof(TBatchLinkRec))
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(160, Result);

end;

FUNCTION EX_DELETELINK(P          : Pointer;
                       PSize      : LongInt;
                       SearchPath : SmallInt) : SmallInt;
var
  LinkRec : ^TBatchLinkRec;
  TmpRes : Boolean;
begin
  TmpRes := False;
  LastErDesc:='';


  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchLinkRec)) then
  Begin

    LinkRec := P;

    if LinkRec.lkLetterLink = 'L' then
      //TmpRes := CompareLetter(MiscRecs^.btLetterRec, LinkRec^)
      Result := 30002
    else
      TmpRes := CompareLink(MiscRecs^.btLinkRec, LinkRec^);

    if TmpRes then
      Result := Delete_Rec(F[MiscF], MiscF, SearchPath)
    else
      Result := 4;

  end //(P<>Nil) and (PSize=Sizeof(TBatchLinkRec))
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(161, Result);

end;

end.
