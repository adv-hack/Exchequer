Unit Club2000;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$I DEFOVR.Inc}


{$O+,F+}

(*****
 Club Import Codes

   01 Opening Balance

        Check Card Exists

        if Not then Add The Card

        Reverse Any Current Non-Zero Balance

        Add Receipt for Balance

   02 Balance Incremented

        Check Card Exists

        Add Receipt for Balance

   03 Account Amended

        Check Card Exists

        Update Card Details

        Send Card Details To Till

   03 Account Deleted

        No Action - Cannot Process At This time

   03 Account Renumbered

        Check Card Exists

        Check New Card Doesn't Exist

        Update Card Details

        Relink Invoice Details

        Send Card Details To Till

   08 Card Allocated

        Check Card Doesn't Exist

        Add Card With Balance

   11 Data Export

        if Card Exists then Update Card Details

        Perform Opening Balance Processing

*****)

Interface


Uses GlobVar, StrUtil;


Type
  AddrType   = Array [1..25] Of Char;
  AmountType = Array [1..8] Of Char;
  PhoneType  = Array [1..20] Of Char;

  {Record structure used for the actual text file CSChange.dat}
  ClubLinkRecType = Record
    EventNo       : Array [1..8]  Of Char; {Unique ID comes from Syss.LastEventIn + 1 (then inc SysRec)}
    RecordNo      : Array [1..6]  Of Char; {Comes from Cust.CsRecNo}
    OldCardNo     : Array [1..6]  Of Char; {not used for add}
    NewCardNo     : Array [1..6]  Of Char; {Comes from AddRecord(iCardNo)}
    Suspend       : Char;                  {N - Cust.Hold = 0 / Y Cust.Hold = 5}

    Name          : Array [1..25] Of Char; {in the format "FIRSTNAME SURNAME"}
    Title         : Array [1..10] Of Char; {Cust.Title}
    Address1      : AddrType;              {Cust.Addr[1]}
    Address2      : AddrType;              {Cust.Addr[2]}
    Address3      : AddrType;              {Cust.Addr[3]}
    Address4      : AddrType;              {Cust.Addr[4]}
    PostCode      : Array [1..10] Of Char; {N/A}
    HomePhone     : PhoneType;             {Cust.Phone}
    WorkPhone     : PhoneType;             {Cust.Fax}

    TransCode     : Array [1..2]  Of Char; {see case in ProcessImpRec to get this}
    TransDate     : Array [1..10] Of Char; {today's date - now}
    Amount        : AmountType;            {for receipt}
    Balance       : AmountType;            {from Cust.CurrBalance}

    MembCode      : Array [1..4] Of Char;  {Cust.ClubNo}
    ClubCat       : Array [1..2] Of Char;  {Cust.ClubCat}

    Spare         : Array [1..10] Of Char; {fill with blank}
  end; { ClubLinkRecType }

{$IFNDEF CARDTK}
  CardLinkRecType = Record
    EventNo       : LongInt;
    RecordNo      : LongInt;
    OldCardNo     : String[6];
    NewCardNo     : String[6];
    Suspend       : Boolean;

    Name          : String[25];
    Title         : String[10];
    Address1      : String[30];
    Address2      : String[30];
    Address3      : String[30];
    Address4      : String[30];
    PostCode      : String[10];
    HomePhone     : String[20];
    WorkPhone     : String[20];

    TransCode     : Byte;
    TransDate     : Date;
    Amount        : Real;
    Balance       : Real;

    MemberCode    : String[4];
    Category      : String[2];

    NewCardNum    : LongInt;     { Used to check number is valid }
  end; { CardLinkRecType }

  ClubLinkFile = File Of ClubLinkRecType;

  Function GotClubFile : Boolean;
  procedure ImportClub2000;
  Function  BoolStr(Const BoolVal : Boolean) : String;
  procedure WL (Const Msg : String);
  procedure WI (Const Ind : Integer);
{$ENDIF}

  procedure ParseName(TheName : String; Var FName, SName : String30);

Implementation


Uses
  {Crt, Dos, EWinSBS, ETPrompt, ComnUnit, ComnU2, Utility, SysU1}
{$IFNDEF CARDTK}
  SysUtils, NeilProc, Dialogs, CardProc, BTSupU1, BTKeys1U, ExWrap1U, ExchLink, Forms, APIUtil
  ,VarConst, ETMiscU, ETDateU, BtrvU2, MainF, Progress, Controls, Windows,
{$ENDIF}
  ETStrU;

Const
  ImportFname = 'CSCHANGE.DAT';
  ExportFname = 'TILLTRAN.DAT';
  RenameFname = 'CSCHANGE.SBS';

Var
  WantLog  : Boolean;
  LogFile  : Text;
{  SaveProc : Pointer;}
  Indent   : Integer;

procedure ParseName(TheName : String; Var FName, SName : String30);
{Name must be in the following format : "FIRSTNAME SURNAME"}
{Examples :
"A J Jones"       will give : Fname = "A J" / Sname = "Jones"
"A J Jones Smith" would give : Fname = "A J Jones" / Sname = "Smith"
}
Var
  I   : Integer;
{        Sur : Boolean;}
begin
{        Sur := True;}
  FName := '';
  SName := '';
  TheName := Strip ('B', [#0, #32], TheName);

  if (Length(TheName) > 0) then begin
    for I := Length(TheName) DownTo 1 Do
      if (TheName[I] = ' ') Then
        Break;


    { Get rid of any blanks }
    FName := Strip ('B', [#0, #32], Copy (TheName, 1, I));
    SName := Strip ('B', [#0, #32], Copy (TheName, I, Length(TheName)));
  end; { if }
end;

{$IFNDEF CARDTK}

{***************************************************************************}
{* Misc routines for Logfile                                               *}
{***************************************************************************}
procedure WL (Const Msg : String);
Begin { WL }
  try
    if WantLog then begin
      if (Indent > 0) Then
        Writeln (LogFile, ' ':Indent, Msg)
      Else
        Writeln (LogFile, Msg);
    end; { if }
  except
    on E:Exception do showmessage('Club2000 WL (' + Msg + ') : ' + E.ClassName + ' - ' + E.Message);
  end;
end;  { WL }

procedure WI (Const Ind : Integer);
Begin { WI }
  if WantLog then begin
    Indent := Indent + Ind;
    if (Indent < 0) then Indent := 0;
  end; { if }
end;  { WI }

Function BoolStr(Const BoolVal : Boolean) : String;
Begin { BoolStr }
  if BoolVal then BoolStr := 'True'
  Else BoolStr := 'False';
end;  { BoolStr }


{***************************************************************************}
{* Import/Export Routines                                                  *}
{***************************************************************************}

{ Returns True if the club import file exists }
Function GotClubFile : Boolean;
Var
  TestF  : Text;
  bResult : Boolean;
  IO     : Integer;
Begin
  WL ('GotClubFile (' + Syss.MergePath + ImportFname + ')');
  WI (2);

{  bResult := False;}

  {$I-}
  AssignFile(TestF, Syss.MergePath + ImportFname);
  Reset (TestF);

  IO := IOResult;
  bResult := (IO = 0);

  if bResult then Close  (TestF);
  {$I+}

  GotClubFile := bResult;

  WL ('Result: ' + BoolStr(bResult) + ', ' + Form_Int(IO,3));
  WI (-2);
end;


{ Processes the Club2000 Import file }
procedure ImportClub2000;
var
  ExLocal : TdExLocal;
  FrmProgress : TFrmProgress;

  { Returns True if the club import file exists }
  Function GotSBSFile : Boolean;
  Var
    TestF  : Text;
    IO     : Integer;
    bResult : Boolean;
  begin
    WL ('GotSBSFile (' + Syss.MergePath + RenameFname + ')');
    WI (2);

{    bResult := False;}

    {$I-}
    AssignFile(TestF, Syss.MergePath + RenameFname);
    Reset  (TestF);

    IO := IOResult;
    bResult := (IO = 0);

    if bResult then Close (TestF);
    {$I+}

    GotSBSFile := bResult;

    WL ('Result: ' + BoolStr(bResult) + ', ' + Form_Int(IO,3));
    WI (-2);
  end;

  { processes the Import file }
  procedure ProcessFile (Const ImpFName : String; Const WantRen : Boolean);
  Var
    ImportFile : File Of ClubLinkRecType;
    ImportRec  : ClubLinkRecType;
    SBSRec     : CardLinkRecType;
    FileInfo : TSearchRec;

    procedure TxlateImpRec;
    begin { TxlateImpRec }
      FillChar (SBSRec, SizeOf (SBSRec), ' ');
      With SBSRec do begin
        EventNo       := IntStr(Strip('B', [#0, #32], ImportRec.EventNo));
        RecordNo      := IntStr(Strip('B', [#0, #32], ImportRec.RecordNo));

        { Old Card Number }
        Move (ImportRec.OldCardNo, OldCardNo[1], SizeOf (ImportRec.OldCardNo));
        OldCardNo[0] := Chr(SizeOf (ImportRec.OldCardNo));
        OldCardNo    := Strip ('B', [#0, ' '], OldCardNo) + ConstStr(' ', 6);

        { New Card Number }
        Move (ImportRec.NewCardNo, NewCardNo[1], SizeOf (ImportRec.NewCardNo));
        NewCardNo[0] := Chr(SizeOf (ImportRec.NewCardNo));
        NewCardNo    := Strip ('B', [#0, ' '], NewCardNo) + ConstStr(' ', 6);
        NewCardNum   := IntStr(Strip('B', [#0, #32], ImportRec.NewCardNo));

        { Suspended Flag }
        Suspend := (ImportRec.Suspend = 'Y');

        { Name }
        Move (ImportRec.Name, Name[1], SizeOf (ImportRec.Name));
        Name[0] := Chr(SizeOf (ImportRec.Name));
        Name    := Strip ('R', [#0, ' '], Name);
        if (not Syss.ImpLowerCase) then Name := UpCaseStr(Name);

        { Title }
        Move (ImportRec.Title, Title[1], SizeOf (ImportRec.Title));
        Title[0] := Chr(SizeOf (ImportRec.Title));
        Title    := Strip ('R', [#0, ' '], Title);
        if (not Syss.ImpLowerCase) then Title := UpCaseStr(Title);

        { Address1 }
        Move (ImportRec.Address1, Address1[1], SizeOf (ImportRec.Address1));
        Address1[0] := Chr(SizeOf (ImportRec.Address1));
        Address1    := Strip ('R', [#0, ' '], Address1);

        { Address2 }
        Move (ImportRec.Address2, Address2[1], SizeOf (ImportRec.Address2));
        Address2[0] := Chr(SizeOf (ImportRec.Address2));
        Address2    := Strip ('R', [#0, ' '], Address2);

        { Address3 }
        Move (ImportRec.Address3, Address3[1], SizeOf (ImportRec.Address3));
        Address3[0] := Chr(SizeOf (ImportRec.Address3));
        Address3    := Strip ('R', [#0, ' '], Address3);

        { Address4 }
        Move (ImportRec.Address4, Address4[1], SizeOf (ImportRec.Address4));
        Address4[0] := Chr(SizeOf (ImportRec.Address4));
        Address4    := Strip ('R', [#0, ' '], Address4);

        { Post Code }
        Move (ImportRec.PostCode, PostCode[1], SizeOf (ImportRec.PostCode));
        PostCode[0] := Chr(SizeOf (ImportRec.PostCode));
        PostCode    := Strip ('R', [#0, ' '], PostCode);

        { Home Phone Number }
        Move (ImportRec.HomePhone, HomePhone[1], SizeOf (ImportRec.HomePhone));
        HomePhone[0] := Chr(SizeOf (ImportRec.HomePhone));
        HomePhone    := Strip ('R', [#0, ' '], HomePhone);

        { Work Phone Number }
        Move (ImportRec.WorkPhone, WorkPhone[1], SizeOf (ImportRec.WorkPhone));
        WorkPhone[0] := Chr(SizeOf (ImportRec.WorkPhone));
        WorkPhone    := Strip ('R', [#0, ' '], WorkPhone);

        { Transaction Code }
        TransCode    := IntStr(Strip('B', [#0, #32], ImportRec.TransCode));

        { Transaction Date }
        Move (ImportRec.TransDate[9], TransDate[1], 2); { YY }
        Move (ImportRec.TransDate[4], TransDate[3], 2); { MM }
        Move (ImportRec.TransDate[1], TransDate[5], 2); { DD }
        TransDate[0] := #6;

        { Amount }
        Amount := RealStr(Strip ('B', [#0, ' '], ImportRec.Amount));

        { Balance }
        Balance := RealStr(Strip ('B', [#0, ' '], ImportRec.Balance));

        { Member Code }
        Move (ImportRec.MembCode, MemberCode[1], SizeOf (ImportRec.MembCode));
        MemberCode[0] := Chr(SizeOf (ImportRec.MembCode));
        MemberCode    := Strip ('R', [#0, ' '], MemberCode);

        { Club Category }
        Move (ImportRec.ClubCat, Category[1], SizeOf (ImportRec.ClubCat));
        Category[0]   := Chr(SizeOf (ImportRec.ClubCat));
        Category      := Strip ('R', [#0, ' '], Category);
      end; { With }
    end;  { TxlateImpRec }

    { Identifies and performs actions required for the record }
    procedure ProcessImpRec;

      procedure DispError (Const ErrType : Byte);
      var
        sMessage : string;
      begin
        Case ErrType Of
          1 : begin { Card already exists }
            sMessage := 'Card ' + Strip('R',[#0,' '],SBSRec.NewCardNo) + ' already exists' + CHR(13)
            + 'Event: ' + Form_Int(SBSRec.EventNo,0) + ', TransCode: ' + Form_Int(SBSRec.TransCode,0);
          end;

          2 : begin { Card doesn't exist }
            sMessage := 'Card ' + Strip('R',[#0,' '],SBSRec.NewCardNo) + ' not found' + CHR(13)
            + 'Event: ' + Form_Int(SBSRec.EventNo,0) + ', TransCode: ' + Form_Int (SBSRec.TransCode,0);
          end;

          3 : sMessage := 'Card Number "' + SBSRec.NewCardNo + '" is invalid'; { Card number is invalid }
        end; { Case }
        MsgBox(sMessage,mtWarning,[mbOK],mbOK,'Warning : ' + IntToStr(ErrType));
      end;

      procedure AddCard;
      Var
        KeyS             : Str255;
        PostNet, PostVAT : Real;
        FName, SName     : String30;
        iStatus : smallint;
      begin{AddCard}
        WL ('Card Added');

        { check card doesn't already exist }
        KeyS := SBSRec.NewCardNo;
        iStatus := Find_Rec(B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);

        if (iStatus <> 0) then begin
          if (SBSRec.NewCardNum > 0) then begin
            if CheckAbsFree then begin
              { record not found, or something }
              WL ('Add record');

              { Parse name into initials and surname }
              ParseName(SBSRec.Name, FName, SName);

              { Setup Customer }

              With ExLocal, LCust do begin
                LResetRec(CustF);
                {CustCode    := SBSRec.NewCardNo;}
                CustCode    := FullCustCode(SBSRec.NewCardNo);
                if Syss.UseIssueNumbers and (IssueNumber = 0) then IssueNumber := FIRST_ISSUE_NUMBER;
                {ClubNo      := SBSRec.MemberCode;}
                ClubNo      := LJVar(SBSRec.MemberCode,SizeOf(SBSRec.MemberCode) - 1{Fpos[MemNo].Len});
                {Company     := SBSRec.Name;}
                {Company     := LJVar(SBSRec.Name,Fpos[CompNo].Len);}
                Company     := LJVar(SName,SizeOf(SName) - 1{Fpos[CompNo].Len});
                if (not Syss.ImpLowerCase) then Company:=UpCaseStr(Company);
                TillNo      := Get_NextTillNo(TRUE);
                CustSupp    := TradeCode[TRUE];
                Addr[1]     := SBSRec.Address1;
                Addr[2]     := SBSRec.Address2;
                Addr[3]     := SBSRec.Address3;
                Addr[4]     := Strip ('B', [#0, #32], SBSRec.Address4) +
                               ' ' +
                               Strip ('B', [#0, #32], SBSRec.PostCode);
                Addr[4]     := Strip ('B', [#0, #32], Addr[4]);
                Phone       := SBSRec.HomePhone;
                Title       := SBSRec.Title;
                Fax         := SBSRec.WorkPhone;
                if SBSRec.Suspend then Hold := 5 Else Hold := 0;
                CSRecNo     := SBSRec.RecordNo;
                AllowCredit := Syss.DefCredit;
                CurrBalance := 0.0;

                { MH Added 03/03/97 }
                FirstName:=FName;
                ChrisName:=FName;

                { HM 28/09/98: Added Club Category }
                ClubCat := SBSRec.Category;
              end; { With }

              iStatus:=Add_Rec(F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK);
              ExLocal.LGetRecAddr(CustF);

              if iStatus = 0 then begin
                { Send Card Details to till }
                Cust2Till(ExLocal.LCust{,False,0});

                if (SBSRec.Balance <> 0.0) then begin
                  { put receipt through for topup }
                  PostNet := 0.0;
                  PostVAT := 0.0;
                  if Syss.LinkToExch then begin
                    { Create NOM as we are posting though to Enterprise }
                    Gen_Inv (ExLocal, 0, SBSRec.Balance, 0, 0, PostNet, PostVAT, 3, isUnknown);

                    { Post through to Exchequer/Enterprise }
{                    oExchequer.Control_NT(Inv, False, 0);  {* Add NTxFR *}
                  end { if }
                  Else begin
                    { Create SRI as not posting to Enterprise }
                    Gen_Inv(ExLocal, 0, SBSRec.Balance, 0, 0, PostNet, PostVAT, 1, isUnknown);
                  end; { Else }

                  { adjust last club amount by invoice amount, otherwise will get }
                  { processed by club twice                                       }
                  KeyS := SBSRec.NewCardNo;
                  iStatus := Find_Rec(B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);
                  if (iStatus = 0) And (ExLocal.LCust.CSRecNo = SBSRec.RecordNo) then begin
{                    ExLocal.LGetRecAddr(CustF);}
                    ExLocal.LCust.LastClubBal := -SBSRec.Balance;
                    {iStatus := }Put_Rec(F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK);
                    ExLocal.LGetRecAddr(CustF);
                  end; { if }
                end; { if }
              end; { if }
            end; { if }
          end { if }
          Else
            DispError (3); { Invalid Card Number }
        End
        Else begin
          ExLocal.LGetRecAddr(CustF);
          DispError (1);
        end;{if}
      end;{AddCard}

      procedure DeleteCard;
      Var
        KeyS     : Str255;
        iStatus : smallint;
      begin
        {*****************************************}
        WL ('Card Deleted (Expired) - not Coded');
        {*****************************************}

        { check card exists }
        KeyS := SBSRec.OldCardNo;
        iStatus := Find_Rec(B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);

        if (iStatus = 0) And (ExLocal.LCust.CSRecNo = SBSRec.RecordNo) then begin
          ExLocal.LGetRecAddr(CustF);
          { Check suspend flag }
          if (ExLocal.LCust.Hold = 0) then begin
            ExLocal.LCust.Hold := 5;
            iStatus := Put_Rec(F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK);
            if iStatus = 0 then begin
              ExLocal.LGetRecAddr(CustF);
              Cust2Till(ExLocal.LCust{,True,0});
            end;{if}
          end; { if }

          MsgBox('Card ' + Strip('R',[#0,' '],SBSRec.OldCardNo) + ' has been deleted in Club2000.' + CHR(13)
          + 'The Card has been suspended and must be deleted manually',mtWarning,[mbOK],mbOK,'Warning');
        end; { if }
      end;

      procedure RenumberCard;
      Var
        KeyS     : Str255;
        iStatus : smallint;

        procedure ChangeLinks(OCode,NCode : AnyStr; Fnum : Integer; KLen : Integer; KeyPth : Integer);
        Var
          KeyS   : AnyStr;
          Ok, Locked : Boolean;
          B_Func : Integer;
          OCode2 : AnyStr;
          iStatus : smallint;
        begin
          KeyS:=OCode;
          B_Func:=B_GetNext;
          FrmProgress.lStatus.Caption := 'Processing Changes';
          FrmProgress.lStatus.Refresh;
          iStatus := Find_Rec(B_GetGEq,F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypth,KeyS);
          While (CheckKey(OCode,KeyS,KLen,TRUE)) and (iStatus=0) do begin
            Ok := GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyPth,Fnum,TRUE,Locked);
            with ExLocal do begin
              LGetRecAddr(Fnum);
              Case Fnum of
                 InvF : begin
                   LInv.CustCode:=NCode;
                   { Change links for sales details }
                   OCode2 := FullNomKey(LInv.FolioNum) + #0#0#0#0;
                   OCode2[0] := #4;
                   ChangeLinks (oCode2, NCode, SalesDetF, 4, sdFolioK);
                   B_Func:=B_GetGEq;  { Cannot get next as record has been moved in index }
                 end;

                SalesDetF: begin
                  LSalesDet.sdCard := NCode;
                  B_Func:=B_GetNext; { Can get next record as index position is not changed }
                end;
              end;
            end;{with}

            if (Ok) and (Locked) then {iStatus:=}Put_Rec(F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,KeyPth);
            iStatus := Find_Rec(B_Func,F[Fnum],Fnum,ExLocal.LRecPtr[Fnum]^,Keypth,KeyS);
            ExLocal.LGetRecAddr(Fnum);
{            if (Debug) then Status_Means(iStatus);}
          end;{while}
{          FrmImportProgress.Hide;}
        end;{ChangeLinks}


      begin{RenumberCard}
        WL ('Card Renumbered');
        if (SBSRec.NewCardNum > 0) Then
          begin
            { check new card no doesn't already exist }
            KeyS := SBSRec.NewCardNo;
            iStatus := Find_Rec (B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);

            if (iStatus = 4) Then
              begin
                { Get card to renumber }
                KeyS := SBSRec.OldCardNo;
                iStatus := Find_Rec (B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);

                if (iStatus = 0) And (ExLocal.LCust.CSRecNo = SBSRec.RecordNo) Then
                  begin
                    ExLocal.LCust.CustCode := SBSRec.NewCardNo;

                    if SBSRec.Suspend Then
                      ExLocal.LCust.Hold := 5
                    Else
                      ExLocal.LCust.Hold := 0;

                    iStatus := Put_Rec(F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK);

                    if iStatus = 0 then begin
                      ExLocal.LGetRecAddr(CustF);
                      Cust2Till(ExLocal.LCust{,True,0});
                      ChangeLinks(SBSRec.OldCardNo,ExLocal.LCust.CustCode,InvF,Length(SBSRec.OldCardNo),InvCustK);

                      // Renumber cards held in the Function Booking database
                      RenumberFunctions(SBSRec.OldCardNo,ExLocal.LCust.CustCode);
                    end;
                  end { if }
                Else DispError (2); { card doesn't exist }
              End
            Else begin
              ExLocal.LGetRecAddr(CustF);
              DispError (1); { Card already exists }
            end;
          end { if }
        Else DispError (3); { Invalid Card number }
      end;{RenumberCard}

      procedure NewCardBal;
      Var
        KeyS             : Str255;
        PostNet, PostVAT : Real;
        iStatus : smallint;
      begin
        WL ('Card Balance');
        WI (2);

        { check card exists }
        KeyS := SBSRec.NewCardNo;
        iStatus := Find_Rec (B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);

        if (iStatus = 0) And (ExLocal.LCust.CSRecNo = SBSRec.RecordNo) then begin
          ExLocal.LGetRecAddr(CustF);

          { Check suspend flag }
          if ((SBSRec.Suspend) And (ExLocal.LCust.Hold = 0)) Or
             ((not SBSRec.Suspend) And (ExLocal.LCust.Hold <> 0)) then begin
            if SBSRec.Suspend Then
              ExLocal.LCust.Hold := 5
            Else
              ExLocal.LCust.Hold := 0;

            iStatus := Put_Rec(F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK);

            if iStatus = 0 then begin
              ExLocal.LGetRecAddr(CustF);
              Cust2Till(ExLocal.LCust{,True,0});
            end;
          end; { if }

          { Check the current balance is different from new balance }
          if (Round_Up(ExLocal.LCust.CurrBalance,2) <> Round_Up(-SBSRec.Balance,2)) then begin
            if (ExLocal.LCust.CurrBalance <> 0.0) then begin
              { zero any existing balance - no need to worry about sales on the }
              { till because they will still be there after this has been done  }
              PostNet := 0.0;
              PostVAT := 0.0;
              Gen_Inv (ExLocal{Cust}, 0, ExLocal.LCust.CurrBalance, 0, 0, PostNet, PostVAT, 4, isUnknown);

              { Post through to Exchequer/Enterprise }
{              oExchequer.AddNMTZero(Inv);}
            end; { if }

            { put receipt through for new balance if non-zero }
            if (SBSRec.Balance <> 0.0) then begin
              { add receipt - no discount should be given }
              PostNet := 0.0;
              PostVAT := 0.0;
              Gen_Inv (ExLocal, 0, SBSRec.Balance, 0, 0, PostNet, PostVAT, 4, isUnknown);

              { Post through to Exchequer/Enterprise }
{              oExchequer.AddNMTZero(Inv);}
            end; { if }

            { adjust last club amount by invoice amount, otherwise will get }
            { processed by club twice                                       }
            KeyS := SBSRec.NewCardNo;
            iStatus := Find_Rec(B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);
            if (iStatus = 0) And (ExLocal.LCust.CSRecNo = SBSRec.RecordNo) then begin
              ExLocal.LGetRecAddr(CustF);
              ExLocal.LCust.LastClubBal := -SBSRec.Balance;
              {iStatus := }Put_Rec(F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK);
              ExLocal.LGetRecAddr(CustF);
            end; { if }
          end; { if }
        End
        Else
          if (iStatus = 4) Then
            AddCard
          Else
            DispError (2);

        WI (-2);
      end;

      procedure CardTopup(Const Mode : Byte); {*CL12}
      Var
        KeyS                   : Str255;
        PostNet, PostVAT, oBal : Real;
        iStatus : smallint;
      begin
        WL ('Card Topup');
        WI (2);

        { check card exists }
        KeyS := SBSRec.NewCardNo;
        iStatus := Find_Rec(B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);

        if (iStatus = 0) And (ExLocal.LCust.CSRecNo = SBSRec.RecordNo) then begin
          ExLocal.LGetRecAddr(CustF);

          { Check suspend flag }
          if ((SBSRec.Suspend) And (ExLocal.LCust.Hold = 0)) Or ((not SBSRec.Suspend)
          And (ExLocal.LCust.Hold <> 0)) then begin
            if SBSRec.Suspend Then ExLocal.LCust.Hold := 5
            Else ExLocal.LCust.Hold := 0;

            iStatus := Put_Rec(F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK);

            if iStatus = 0 Then begin
              Cust2Till(ExLocal.LCust{,True,0});
              ExLocal.LGetRecAddr(CustF);
            end;{if}
          end; { if }

          if (SBSRec.Amount <> 0.0) then begin
            { Take copy of balance for later checking }
            oBal := ExLocal.LCust.CurrBalance;

            { put receipt through for topup }
            PostNet := 0.0;
            PostVAT := 0.0;
            If (Mode = 0) Then  {*CL12}
              { Normal Receipt }
              Gen_Inv (ExLocal, 0, SBSRec.Amount, 0, 0, PostNet,
                       PostVAT, 3, isUnknown)
            Else
              { Renewal Payment }
              Gen_Inv (ExLocal, 0, SBSRec.Amount, 0, 0, PostNet,
                       PostVAT, 11, isUnknown);

            { Post through to Exchequer/Enterprise }
{            oExchequer.Control_NT(Inv, False, 0);  {* Add NTxFR *}

            { adjust last club amount by invoice amount, otherwise will get }
            { processed by club twice                                       }
            KeyS := SBSRec.NewCardNo;
            iStatus := Find_Rec (B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);
            if (iStatus = 0) And (ExLocal.LCust.CSRecNo = SBSRec.RecordNo)
            And (ExLocal.LCust.CurrBalance <> oBal) then begin
              ExLocal.LGetRecAddr(CustF);
              ExLocal.LCust.LastClubBal := ExLocal.LCust.LastClubBal - SBSRec.Amount;
              {iStatus := }Put_Rec(F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK);
              ExLocal.LGetRecAddr(CustF);
            end; { if }
          end; { if }

          { nothing needs to be posted to Exchequer as this is done }
          { externally by the user                                  }
        End
        Else
          DispError (2);

        WI (-2);
      end;

      procedure CardAmendment;
      Var
        KeyS             : Str255;
        FName, SName     : String30;
        iStatus : smallint;
      begin
        WL ('Card Amended');
        WI (2);

        { check card exists }
        KeyS := SBSRec.NewCardNo;
        iStatus := Find_Rec (B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);

        if (iStatus = 0) And (ExLocal.LCust.CSRecNo = SBSRec.RecordNo) then begin
          { Got Card - Lock record }
          {Ok := }GetMultiRec(B_GetDirect,B_SingLock,KeyS,CustCodeK,CustF,FALSE,GlobLocked);
          ExLocal.LGetRecAddr(CustF);
          { Parse name into initials and surname }
          ParseName (SBSRec.Name, FName, SName);

          { make changes }
          With ExLocal.LCust do begin
            {ClubNo  := SBSRec.MemberCode;}
            ClubNo   := LJVar(SBSRec.MemberCode,SizeOf(SBSRec.MemberCode) - 1{Fpos[MemNo].Len});
            {Company := SBSRec.Name;}
            Company  := LJVar(SName,SizeOf(SName) - 1{Fpos[CompNo].Len});
            Addr[1]  := SBSRec.Address1;
            Addr[2]  := SBSRec.Address2;
            Addr[3]  := SBSRec.Address3;
            {Addr[4] := SBSRec.Address4;
            Addr[5] := SBSRec.PostCode;}
            Addr[4]  := Strip ('B', [#0, #32], SBSRec.Address4) +
                        ' ' +
                        Strip ('B', [#0, #32], SBSRec.PostCode);
            Addr[4]  := Strip ('B', [#0, #32], Addr[4]);

            Phone    := SBSRec.HomePhone;
            Title    := SBSRec.Title;
            Fax      := SBSRec.WorkPhone;

            if SBSRec.Suspend then Hold := 5 Else Hold := 0;

            { MH Added 03/03/97 }
            FirstName:=FName;
            ChrisName:=FName;

            { HM 28/09/98: Added Club Category }
            ClubCat := SBSRec.Category;
          end; { With }

          { update }
          iStatus := Put_Rec(F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK);

          { Update Till }
          if iStatus = 0 then begin
            ExLocal.LGetRecAddr(CustF);
            Cust2Till(ExLocal.LCust{,False,0});
          end;{if}
        end { if }
        Else
          DispError (2);

        WI (-2);
      end;

      procedure DataExport;
      Var
        KeyS             : Str255;
        PostNet, PostVAT : Real;
        FName, SName     : String30;
        iStatus : smallint;
      begin
        WL ('Data Export');
        WI (2);

        if (SBSRec.NewCardNum > 0) then begin
          { check card exists }
          KeyS := SBSRec.NewCardNo;
          iStatus := Find_Rec (B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);

          if (iStatus = 0) And (ExLocal.LCust.CSRecNo = SBSRec.RecordNo) then begin
            { Got Card - Lock record }
            {Ok:=}GetMultiRec(B_GetDirect,B_SingLock,KeyS,CustCodeK,CustF,FALSE,GlobLocked);
            ExLocal.LGetRecAddr(CustF);
            { Parse name into initials and surname }
            ParseName (SBSRec.Name, FName, SName);

            { make changes }
            With ExLocal.LCust do begin
              {ClubNo  := SBSRec.MemberCode;}
              ClubNo   := LJVar(SBSRec.MemberCode,SizeOf(SBSRec.MemberCode) - 1{Fpos[MemNo].Len});
              {Company := SBSRec.Name;}
              Company  := LJVar(SName,SizeOf(SName) -1{Fpos[CompNo].Len});
              Addr[1] := SBSRec.Address1;
              Addr[2] := SBSRec.Address2;
              Addr[3] := SBSRec.Address3;
              {Addr[4] := SBSRec.Address4;
              Addr[5] := SBSRec.PostCode;}
              Addr[4]  := Strip ('B', [#0, #32], SBSRec.Address4) +
                          ' ' +
                          Strip ('B', [#0, #32], SBSRec.PostCode);
              Addr[4]  := Strip ('B', [#0, #32], Addr[4]);
              Phone   := SBSRec.HomePhone;
              Title   := SBSRec.Title;
              Fax     := SBSRec.WorkPhone;

              if SBSRec.Suspend then Hold := 5 Else Hold := 0;

              { MH Added 03/03/97 }
              FirstName:=FName;
              ChrisName:=FName;

              { HM 28/09/98: Added Club Category }
              ClubCat := SBSRec.Category;
            end; { With }

            { update }
            iStatus := Put_Rec(F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK);

            { Update Till }
            if iStatus = 0 then begin
              ExLocal.LGetRecAddr(CustF);
              Cust2Till(ExLocal.LCust{,False,0});
            end;{if}

            { Check the current balance is different from new balance }
            if (Round_Up(ExLocal.LCust.CurrBalance,2) <> Round_Up(-SBSRec.Balance,2)) then begin
              { Zero any existing balance }
              if (ExLocal.LCust.CurrBalance <> 0.0) then begin
                { zero any existing balance - no need to worry about sales on the }
                { till because they will still be there after this has been done  }
                PostNet := 0.0;
                PostVAT := 0.0;
                Gen_Inv (ExLocal, 0, ExLocal.LCust.CurrBalance, 0, 0, PostNet, PostVAT, 4, isUnknown);

                { Post through to Exchequer/Enterprise }
//                oExchequer.AddNMTZero(Inv);
              end; { if }

              { put receipt through for new balance - if non-zero }
              if (SBSRec.Balance <> 0.0) then begin
                PostNet := 0.0;
                PostVAT := 0.0;
                Gen_Inv (ExLocal, 0, SBSRec.Balance, 0, 0, PostNet, PostVAT, 4, isUnknown);

                { Post through to Exchequer/Enterprise }
//                oExchequer.AddNMTZero(Inv);
              end; { if }
            end; { if }

            { adjust last club amount by invoice amount, otherwise will get }
            { processed by club twice                                       }
            KeyS := SBSRec.NewCardNo;
            iStatus := Find_Rec (B_GetEq, F[CustF], CustF, ExLocal.LRecPtr[CustF]^, CustCodeK, KeyS);
            if (iStatus = 0) And (ExLocal.LCust.CSRecNo = SBSRec.RecordNo) then begin
              ExLocal.LGetRecAddr(CustF);
              ExLocal.LCust.LastClubBal := -SBSRec.Balance;
              {iStatus := }Put_Rec(F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK);
              ExLocal.LGetRecAddr(CustF);
            end; { if }
          end { if }
          Else begin
            if (iStatus = 4) Then
              AddCard
            Else
              DispError (2);
          end; { Else }
        end { if }
        Else
          DispError (3); { Invalid Card number }

        WI (-2);
      end;

    begin{ProcessImpRec}
      GlobLocked := TRUE;
      GetMultiSys(TRUE, GlobLocked);

      { Check event number }
      if (SBSRec.EventNo > Syss.LastEventIn) Or
        ((SBSRec.EventNo < 10000) And (Syss.LastEventIn > 99990000)) then begin
        Case SBSRec.TransCode Of
          { New Card Balance }
          1  : NewCardBal;

          { Topup }
          2  : begin
                 if (SBSRec.OldCardNo <> SBSRec.NewCardNo) And
                    (SBSRec.NewCardNum = 0) then begin
                   { Delete Card }
                   DeleteCard;
                 end { if }
                 Else begin
                   if (SBSRec.OldCardNo <> SBSRec.NewCardNo) And
                      (SBSRec.NewCardNo <> '000000') Then
                     RenumberCard;

                   CardTopup(0);
                 end; { Else }
               end;

          { Misc Club Payments (Topup)}
          4, 5, 6, 7 : CardTopup(0);

          { Account amended }
          3  : begin
                 if (SBSRec.OldCardNo = SBSRec.NewCardNo) Then
                   CardAmendment
                 Else
                   if (SBSRec.NewCardNo = '000000') Then
                     DeleteCard
                   Else
                     RenumberCard;
               end;

          { Card Allocation }
          8  : AddCard;

          { Data Export - Used for initial load }
          11 : DataExport;

          { Club - Renewal Payment }
          12 : CardTopup(1); {*CL12}
        Else
          WL ('Unknown Transcode: ' + Form_Int(SBSRec.TransCode,2));
        end; { Case }

        { update event number }
        Syss.LastEventIn := SBSRec.EventNo;
        PutMultiSys;
      end { if }
      Else UnLockMultiSing(F[SysF], SysF, aiLockPos[SysF]);
{        iStatus := Find_Rec(B_Unlock,F[SysF],SysF,ExLocal.LRecPtr[SysF]^,0,KeyF);}
    end;

  begin{ProcessFile}
    WL ('ProcessFile: ' + ImpFName + ', ' + BoolStR(WantRen));
    WI (2);


    {$I-}

    { Open }
    AssignFile(ImportFile, ImpFname);

    FindFirst(ImpFname, faAnyFile, FileInfo);
    FrmProgress.ProgressBar1.Max := Round(FileInfo.Size / 256);
    SysUtils.FindClose(FileInfo);

    if WantRen then begin
      { Rename }
      Rename(ImportFile, Syss.MergePath + RenameFname);
      WL ('Rename: ' + Form_Int (IOResult, 3));
    end; { if }

    Reset(ImportFile);

    if (IOResult = 0) then begin
      { file opened successfully }
      WL ('Opened');

      { Process file }
      if not EOF (ImportFile) then begin
        { Display Progress Screen }

        FrmProgress.lStatus.Caption := 'Updating Members Accounts';
        FrmProgress.lStatus.Refresh;

        Repeat
          { get record }
          Read(ImportFile, ImportRec);

          { Process record }
          TxLateImpRec;
          WL ('Got Rec: ' + Form_Int(SBSRec.EventNo,3));
          FrmProgress.lName.Caption := Strip('B',[#0,' '],SBSRec.Name);
          FrmProgress.lName.Refresh;
          ProcessImpRec;
          FrmProgress.ProgressBar1.Position := FrmProgress.ProgressBar1.Position + 1;
        until EOF(ImportFile) or (IOResult <> 0);
      end; { if }

      { Close and delete file }
      CloseFile(ImportFile);
      Erase(ImportFile);
      WL ('Closed and Erased: ' + Form_Int (IOResult, 3));
    end; { if }

    WI (-2);
  end;{ProcessFile}

  { Checks for parameter to turn logfile on }
  procedure CheckParams;
  Var
    I : Word;
  Begin
    if (ParamCount > 0) then begin
      for I := 1 To ParamCount do begin
        if (ParamStr(I) = '/CLUBLOG') Then WantLog := True;
      end; {Loop..}
    end;{if}
  end; {Proc..}

Begin { ImportClub2000 }
  screen.cursor := crHourglass;

  {turn on logging if neccessary}
  WantLog := False;
  CheckParams;
  if WantLog then begin
    try
      Indent := 0;
      AssignFile(LogFile, 'CLUB2000.LOG');
      Rewrite(LogFile);
    except
      on E:Exception do showmessage('Club2000 OpenLog : ' + E.ClassName + ' - ' + E.Message);
    end;{try}
  end; { if }

  ExLocal.Create; {create local record instance}
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,0);
  try
    FrmProgress := TFrmProgress.Create(application);
    FrmProgress.Caption := 'Importing Club 2000...';
    FrmProgress.Show;
    FrmProgress.Refresh;

    WL('ImportClub2000');
    WI(2);

    { Check to see if we've got a previous SBS file }
    if GotSBSFile then ProcessFile(Syss.MergePath + RenameFname, False);

    { Check an import file exists }
    if GotClubFile then ProcessFile(Syss.MergePath + ImportFname, True)
    else msgBox('There is nothing to import',mtInformation,[mbOK],mbOK,'Club Import');

    GlobLocked := TRUE;
    GetMultiSys(TRUE,GlobLocked);
    Syss.UpRead := FALSE;
    PutMultiSys;
    WI(-2);
    ExLocal.Destroy; {destroy local record instance}

    FrmProgress.Close;
  finally
    FrmProgress.Release;
  end;{try}
  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);

  {turn off logging}
  if WantLog then begin
    WL ('ShutDown');
    Close (LogFile);
  end; { if }

  screen.cursor := crDefault;
end;{ImportClub2000 }


{ ExitProc
procedure ExitModule; Far;
Begin
  if WantLog then begin
    WL ('ShutDown');
    Close (LogFile);
  end; { if }

{  ExitProc := SaveProc;
end;}

{ Initialisation section }
Begin
{  SaveProc := ExitProc;
  ExitProc := @ExitModule;}


{$ENDIF}

End.


