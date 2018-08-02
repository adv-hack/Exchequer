unit LettrDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, GlobVar, VarConst, Menus, Mask, ExWrap1U,
  SpellCheck4Modal;

type
  TLetterDlg = class(TForm)
    Label81: Label8;
    Label83: Label8;
    Label84: Label8;
    Label82: Label8;
    DescMemo: TMemo;
    OkBtn: TButton;
    CancBtn: TButton;
    Label85: Label8;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    PathEdt: Text8Pt;
    DatTimEdt: Text8Pt;
    UserEdt: Text8Pt;
    TypeList: TSBSComboBox;
    OpenDialog1: TOpenDialog;
    btnBrowse: TButton;
    SpellCheck4Modal1: TSpellCheck4Modal;
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure CancBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure PathEdtDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PathEdtChange(Sender: TObject);
  private
    { Private declarations }

    PrevHState,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    showOnce : Boolean;

    procedure SetFormProperties;
    Procedure SetColours;
  public
    { Public declarations }
    Ok, Adding : Boolean;
    letterDlgMode : integer;
    procedure DispRec (Const LetterRec : MiscRec);
    procedure GetRec (Var LetterRec : MiscRec);
    procedure Store_FormCoord(UpMode  :  Boolean);
    procedure Find_FormCoord;
  end;

var
  LetterDlg : TLetterDlg;



Function LDateKey (Const TheDate : LongDate) : String;

Function TimeKey (Const TheTime : TimeTyp) : String;

Function DescrDialog (Const CSCode     : String;
                      Const SubCode    : Char;
                      Const DocName    : String;
                      Const LetterType : btLetterDocType) : Boolean;

Procedure ViewLetterDescr (Const GlobLetter : MiscRec);

Function DocTypeName(Const DocVers : btLetterDocType) : String;


Procedure ChangeLinkFolio(LinkType
                                 :  Char;
                          OCode,
                          NCode  :  Str10);

Procedure CopyLinkFolio(LinkType
                               :  Char;
                        OCode,
                        NCode  :  Str10);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


{$R *.DFM}

Uses
  ExtCtrls,
  CmpCtrlU,
  BtrvU2,
  BTSupU1,
  BTSupU2,
  BTKeys1U,
  ETStrU,
  ETMiscU,
  ETDateU,
  ColCtrlU,
  ExThrd2U,
  MsWord95;

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



{ ================== Procedure to Change All Codes Associated with One Link ============= }

Procedure ChangeLinkFolio(LinkType
                                 :  Char;
                          OCode,
                          NCode  :  Str10);

Const
  Fnum      =  MiscF;

  Keypath   =  MIk;


Var
  KeyS,
  KeyChk
        :  AnyStr;
  Locked:  Boolean;
  B_Func:  Integer;

  LAddr :  LongInt;

  TmpStat,
  TmpKPath    :  Integer;

  TmpRecAddr
              :  LongInt;

  TmpPWrd     :  MiscRec;


Begin

  KeyChk:=LetterTCode+LinkType+OCode;

  KeyS:=KeyChk;

  TmpPWrd:=MiscRecs^;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);


  B_Func:=B_GetNext;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);



  While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) do
  With MiscRecs^ do
  Begin

    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);


    If (Ok) and (Locked) then
    Begin

      If (btLetterRec.Version=DocWord95) then
      With btLetterRec do
      Begin

        AccCode   := NCode;

        If (SubType In [TradeCode[BOff], TradeCode[BOn]]) Then
          CustomKey := FullCustCode(AccCode) + LDateKey (LtrDate) + TimeKey (LtrTime)
        Else
          CustomKey := AccCode + LDateKey (LtrDate) + TimeKey (LtrTime);
      end
      else
        With btLinkRec do
        Begin
          AccCode   := NCode;

          If (SubType In [TradeCode[BOff], TradeCode[BOn]]) Then
            CustomKey := FullCustCode(AccCode) + LDateKey (LtrDate) + TimeKey (LtrTime)
          Else
            CustomKey := AccCode + LDateKey (LtrDate) + TimeKey (LtrTime);


        end;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      If (Debug) then Status_Means(Status);

      If (StatusOk) then
        B_Func:=B_GetGEq;

      Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
    end
    else
      B_Func:=B_GetNext;


    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


  end; {While..}

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  MiscRecs^:=TmpPWrd;
end; {Proc..}


{ ================== Procedure to Copy  All Codes Associated with One Link ============= }

Procedure CopyLinkFolio(LinkType
                               :  Char;
                        OCode,
                        NCode  :  Str10);

Const
  Fnum      =  MiscF;

  Keypath   =  MIk;


Var
  KeyS,
  KeyChk
        :  AnyStr;
  Locked:  Boolean;
  B_Func:  Integer;

  LAddr :  LongInt;

  TmpStat,
  TmpKPath    :  Integer;

  TmpRecAddr,
  TmpRecAddr2
              :  LongInt;

  TmpPWrd     :  MiscRec;


Begin

  KeyChk:=LetterTCode+LinkType+OCode;

  KeyS:=KeyChk;

  TmpPWrd:=MiscRecs^;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);


  B_Func:=B_GetNext;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);



  While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) do
  With MiscRecs^ do
  Begin

    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);


    If (Ok) and (Locked) then
    Begin

      If (btLetterRec.Version=DocWord95) then
      With btLetterRec do
      Begin

        AccCode   := NCode;

        If (SubType In [TradeCode[BOff], TradeCode[BOn]]) Then
          CustomKey := FullCustCode(AccCode) + LDateKey (LtrDate) + TimeKey (LtrTime)
        Else
          CustomKey := AccCode + LDateKey (LtrDate) + TimeKey (LtrTime);
      end
      else
        With btLinkRec do
        Begin
          AccCode   := NCode;

          If (SubType In [TradeCode[BOff], TradeCode[BOn]]) Then
            CustomKey := FullCustCode(AccCode) + LDateKey (LtrDate) + TimeKey (LtrTime)
          Else
            CustomKey := AccCode + LDateKey (LtrDate) + TimeKey (LtrTime);


        end;
      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      If (Debug) then Status_Means(Status);

      Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

      SetDataRecOfs(Fnum,LAddr);

      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

    end
    else
      B_Func:=B_GetNext;


    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


  end; {While..}

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  MiscRecs^:=TmpPWrd;
end; {Proc..}



{***********************************************************************}


{***********************************************************************}
{* DocTypeName: Returns a string description                           *}
{***********************************************************************}
Function DocTypeName(Const DocVers : btLetterDocType) : String;
begin
  Case DocVers Of
    DocWord95   : Result := 'Microsoft Word Document';
    lnkDoc      : Result := 'Document';
    lnkFax      : Result := 'Fax';
    lnkImage    : Result := 'Image';
    lnkPres     : Result := 'Presentation';
    lnkProgram  : Result := 'Program';
    lnkSound    : Result := 'Sound';
    lnkVideo    : Result := 'Video';
    lnkOther    : Result := 'Other';
    lnkSpreadSh : Result := 'Spreadsheet';
    lnkInternet : Result := 'Internet Document';
  Else
    Result := '';
  End; { Case }
end;


{***********************************************************************}
{* DescrDialog:                                                        *}
{*                                                                     *}
{* Adding       True if adding a new doc, False if editing existing    *}
{* DocName      Filename of document without path information          *}
{*                                                                     *}
{***********************************************************************}
Function DescrDialog (Const CSCode     : String;
                      Const SubCode    : Char;
                      Const DocName    : String;
                      Const LetterType : btLetterDocType) : Boolean;
Const
  FNum    = MiscF;
  KeyPath = MIK;
Var
  ExLocal    : TdExLocalPtr;
  PrevHState : Boolean;
  PrevCurs   : TCursor;
  DocPath    : String;
Begin

  PrevCurs := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  Result := False;

  New (ExLocal, Create);
  ExLocal^.AssignFromGlobal(MiscF);
  ExLocal^.LGetRecAddr(MiscF);

  Try
    LetterDlg := TLetterDlg.Create(Application);
    Try

      LetterDlg.Adding := True;

      { Disable cancel button as doc already exists and cannot }
      { be cancelled at this stage                             }
      {LetterDlg.CancBtn.Visible := False;}

      With ExLocal^ Do Begin
        FillChar (LMiscRecs^, SizeOf (LMiscRecs^), #0);
        With LMiscRecs^ Do Begin
          RecMfix := LetterTCode;
          SubType := SubCode;

          If (LetterType = DocWord95) Then Begin
            { Letter }
            With btLetterRec Do Begin
              AccCode   := CSCode;
              LtrDate   := Today;
              GetCurrTime(LtrTime);
              LtrDescr  := '';
              LtrPath   := DocName;
              UserCode  := EntryRec^.Login;
              Version   := LetterType;

              { Set Keys }
              If (SubCode In [TradeCode[BOff], TradeCode[BOn]]) Then
                CustomKey := FullCustCode(AccCode) + LDateKey (LtrDate) + TimeKey (LtrTime)
              Else
                CustomKey := AccCode + LDateKey (LtrDate) + TimeKey (LtrTime);
              UserKey   := UpcaseStr(UserCode);
             End; { With }
          End { If }
          Else Begin
            { Link }
            With btLinkRec Do Begin
              AccCode   := CSCode;
              LtrDate   := Today;
              GetCurrTime(LtrTime);
              LtrDescr  := '';
              LtrPath   := DocName;
              UserCode  := EntryRec^.Login;
              Version   := LetterType;

              { Set Keys }
              If (SubCode In [TradeCode[BOff], TradeCode[BOn]]) Then
                CustomKey := FullCustCode(AccCode) + LDateKey (LtrDate) + TimeKey (LtrTime)
              Else
                CustomKey := AccCode + LDateKey (LtrDate) + TimeKey (LtrTime);
              UserKey   := UpcaseStr(UserCode);
            End; { With }
          End; { Else }
        End; { With }
        LetterDlg.DispRec(LMiscRecs^);
        Screen.Cursor := crDefault;

        SetAllowHotKey(BOff,PrevHState);
        Set_BackThreadMVisible(BOn);

        LetterDlg.ShowModal;
        
        Set_BackThreadMVisible(BOff);
        SetAllowHotKey(BOn,PrevHState);

        Screen.Cursor := crHourGlass;

        If LetterDlg.Ok Then Begin
          LetterDlg.GetRec(LMiscRecs^);

          { Insert new letter info rec }
          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
          Report_Berror (Fnum, Status);
        End { If }
        Else Begin
          { Cancelled - Delte existing Document }
          DocPath := FullDocPath + DocName;
          DeleteFile(PCHAR(DocPath));
        End; { Else }
      End; { With }

      Result := LetterDlg.Ok;
    Finally
      LetterDlg.Free;
    End;
  Finally
    Dispose (ExLocal, Destroy);
  End;

  Screen.Cursor := PrevCurs;
end;


{***********************************************************************}
{* Form Events                                                         *}
{***********************************************************************}
Procedure ViewLetterDescr (Const GlobLetter : MiscRec);
Const
  FNum    = MiscF;
  KeyPath = MIK;
Var
  ExLocal   : TdExLocalPtr;
  TmpLetter : MiscRec;
  PrevHState: Boolean;
  PrevCurs  : TCursor;
  KeyS      : Str255;
Begin

  PrevCurs := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  New (ExLocal, Create);
  ExLocal.AssignFromGlobal(MiscF);
  ExLocal.LGetRecAddr(MiscF);

  Try
    With EXLocal^ Do Begin
      { get and lock record }
      KeyS:='';
      LSetDataRecOfs(Fnum, LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}
      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}
      Report_BError(Fnum,Status);

      If (Status = 0) Then
        Ok:= LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked)
    End; { With }

    If (Status = 0) And Ok Then Begin
      LetterDlg := TLetterDlg.Create(Application);
      Try
        LetterDlg.DispRec(EXLocal.LMiscRecs^);

        Screen.Cursor := crDefault;

        SetAllowHotKey(BOff,PrevHState);
        Set_BackThreadMVisible(BOn);

        LetterDlg.ShowModal;

        Set_BackThreadMVisible(BOff);
        SetAllowHotKey(BOn,PrevHState);

        Screen.Cursor := crHourGlass;

        If LetterDlg.Ok Then
          With ExLocal^ Do Begin
            LetterDlg.GetRec(LMiscRecs^);

            { Re-Establish Position }
            TmpLetter := LMiscRecs^;
            LSetDataRecOfs(Fnum, LastRecAddr[Fnum]);
            Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0);
            LMiscRecs^ := TmpLetter;

            { Update existing letter info rec }
            Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
          End; { With }

        { Unlock locked record }
        ExLocal^.UnLockMLock(Fnum,0{ExLocal.LastRecAddr[Fnum]});
      Finally
        LetterDlg.Free;
      End;
    End; { If }
  Finally
    Dispose (ExLocal, Destroy);
  End;

  Screen.Cursor := PrevCurs;
end;

{***********************************************************************}
{* Form Events                                                         *}
{***********************************************************************}
procedure TLetterDlg.FormCreate(Sender: TObject);
Var
  I : btLetterDocType;
begin
  Ok := False;
  Adding := False;
  showOnce := true;
  {Find_FormCoord;}

  For I := lnkDoc To High (I) Do
    If (Trim(DocTypeName(I)) <> '') Then
      TypeList.Items.Add (DocTypeName(I));
end;

procedure TLetterDlg.FormDestroy(Sender: TObject);
begin
  {  }
end;

procedure TLetterDlg.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  {Store_FormCoord(Not SetDefault);}
end;

procedure TLetterDlg.OkBtnClick(Sender: TObject);
begin
  if (Label81.Caption = 'Webpage') and (Length(PathEdt.Text) >= 84) then
   ShowMessage(Format('The url you have entered is too long, you have used %d of ' +
    '84 characters.',[Length(PathEdt.Text)]))
  else
  begin
   Ok := (TypeList.Enabled And (TypeList.ItemIndex >= 0)) Or (Not TypeList.Enabled);
   Close;
  end
end;

procedure TLetterDlg.CancBtnClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

procedure TLetterDlg.DispRec (Const LetterRec : MiscRec);

  Procedure SetIdx (Capt : ShortString);
  Var
    I : SmallInt;
  Begin
    For I := 0 To (TypeList.Items.Count) Do
      If (TypeList.Items.Strings[I] = Capt) Then Begin
        TypeList.ItemIndex := I;
        Break;
      End; { If }
  End;

begin
  With LetterRec Do
    If (btLetterRec.Version = DocWord95) Then
      With btLetterRec Do Begin
        TypeList.Items.Clear;
        TypeList.Items.Add (DocTypeName(Version));
        TypeList.ItemIndex := 0;
        TypeList.enabled := False;

        { Display fields }
        PathEdt.Text   := FullDocPath + Trim(LtrPath);
        PathEdt.ReadOnly := True;
        PathEdt.OnDblClick := Nil;
        btnBrowse.Enabled := False;
        DatTimEdt.Text := POutDate(LtrDate) + '  ' + CurrTimeStr(LtrTime);
        UserEdt.Text   := UserCode;
        DescMemo.Text  := LtrDescr;
        LetterDlg.Caption := 'Letter Information';
      End { With }
    Else
      With btLinkRec Do
      Begin
        if (Version = lnkInternet) then
        begin
            Label81.Caption := 'Webpage';
            PathEdt.Width := 253;
            btnBrowse.Visible := false;
            TypeList.Enabled := false;
            LetterDlg.Caption := 'Webpage Information';
        end
        else
        begin
            Label81.Caption := 'Filename';
            btnBrowse.Enabled := true;
            LetterDlg.Caption := 'Link Information';
        end;

        PathEdt.Text   := Trim(LtrPath);
        //PathEdt.MaxLength := 84;
        SetIdx (DocTypeName(Version));
        DatTimEdt.Text := POutDate(LtrDate) + '  ' + CurrTimeStr(LtrTime);
        UserEdt.Text   := UserCode;
        DescMemo.Text  := LtrDescr;
      End; { With }
end;

procedure TLetterDlg.GetRec (Var LetterRec : MiscRec);
Var
  I : btLetterDocType;
begin
  With LetterRec Do
    If (btLetterRec.Version = DocWord95) Then
      With btLetterRec Do Begin
        LtrDescr := Trim(DescMemo.Text);
        LtrPath  := ExtractFileName(PathEdt.Text);
      End { With }
    Else
      With btLinkRec Do Begin
        LtrDescr := Trim(DescMemo.Text);
        LtrPath  := Trim(PathEdt.Text);

        For I := Low(btLetterDocType) To High(btLetterDocType) Do
          If (DocTypeName(I) = TypeList.Text) Then Begin
            Version := I;
            Break;
          End; { If }
      End; { With }
end;

procedure TLetterDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TLetterDlg.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);

end;

procedure TLetterDlg.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TLetterDlg.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
end;

Procedure TLetterDlg.SetColours;
Var
  N         : Integer;
begin
  For n:=0 to Pred(ComponentCount) do Begin
    If (Components[n] is Text8Pt) then
      With Components[n] as Text8Pt Do Begin
        Font.Assign(PathEdt.Font);
        Color:=PathEdt.Color;
      End; { If }

    If (Components[n] is Label8) then
      With Components[n] as Label8 Do Begin
        Font.Assign(Self.Font);
        Color:=Self.Color;
      End; { With }

    If (Components[n] is TMemo) then
      With Components[n] as TMemo Do Begin
        Font.Assign(PathEdt.Font);
        Color:=PathEdt.Color;
      End; { With }
  End; { For }
End;

procedure TLetterDlg.SetFormProperties;
Var
  TmpPanel    :  Array[1..3] of TPanel;
  n           :  Byte;
  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;

Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do
    TmpPanel[n]:=TPanel.Create(Self);

  try
    TmpPanel[1].Font.Assign(PathEdt.Font);
    TmpPanel[1].Color:=PathEdt.Color;

    TmpPanel[2].Font.Assign(Self.Font);
    TmpPanel[2].Color:=Self.Color;

    ColourCtrl:=TCtrlColor.Create(Self);
    try
      With ColourCtrl do Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],0,Self.Caption+' Properties',BeenChange,ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then Begin
          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1  : Begin
                       PathEdt.Font.Assign(TmpPanel[1].Font);
                       PathEdt.Color:=TmpPanel[1].Color;
                     End;
                2  : Begin
                       Self.Font.Assign(TmpPanel[2].Font);
                       Self.Color:=TmpPanel[2].Color;
                     End;
              end; {Case..}
        end;

        SetColours;
      end;
    finally
      ColourCtrl.Free;
    end;
  Finally
    For n:=1 to 3 do
      TmpPanel[n].Free;
  end;

  If (ResetDefaults) then Begin
    GotCoord:=BOff;
    SetDefault:=BOn;
    Close;
  end;
end;

procedure TLetterDlg.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;


procedure TLetterDlg.Find_FormCoord;
Var
  ThisForm    : TForm;
  GlobComp    : TGlobCompRec;
Begin
  New(GlobComp,Create(BOn));
  Try
    ThisForm:=Self;

    With GlobComp^ do Begin
      GetValues:=BOn;

      PrimeKey:='S';

      If (GetbtControlCsm(ThisForm)) then Begin
        StoreCoord := True;
        HasCoord   := (HLite=1);
        LastCoord  := HasCoord;

        If (HasCoord) then {* Go get postion, as would not have been set initianly *}
          SetPosition(ThisForm);
      end;

      GetbtControlCsm(PathEdt);

      SetColours;
    end; {With GlobComp..}
  Finally
    Dispose(GlobComp,Destroy);
  End;
end;


procedure TLetterDlg.Store_FormCoord(UpMode  :  Boolean);
Var
  GlobComp : TGlobCompRec;
Begin
  New(GlobComp,Create(BOff));
  Try
    With GlobComp^ do Begin
      GetValues:=UpMode;

      PrimeKey:='S';

      ColOrd:=Ord(StoreCoord);

      HLite:=Ord(LastCoord);

      SaveCoord:=StoreCoord;

      If (Not LastCoord) then {* Attempt to store last coord *}
        HLite:=ColOrd;

      StorebtControlCsm(Self);

      StorebtControlCsm(PathEdt);
    end; {With GlobComp..}
  Finally
    {GlobComp.Destroy;}
    Dispose(GlobComp,Destroy);
  End;
end;


procedure TLetterDlg.PathEdtDblClick(Sender: TObject);
Var
  Temp1, Temp2 : PChar;
  PLen         : SmallInt;
  CDir         : String;
begin

  if Label81.Caption <> 'Webpage' then
  begin
    OpenDialog1.FileName := PathEdt.Text;
    OpenDialog1.HistoryList.Add (PathEdt.Text);

    // HM 07/11/00: Added save/restore of directory
    GetDir(0,CDir);

    If OpenDialog1.Execute Then Begin
      // HM 07/11/00: Added save/restore of directory
      ChDir(CDir);

      Temp1 := StrAlloc (250);
      Temp2 := StrAlloc (250);

      StrPCopy (Temp1, Trim(OpenDialog1.FileName));
      PLen := GetShortPathName (Temp1, Temp2, StrBufSize (Temp2));
      If (PLen > 0) Then
        // HM 07/11/00: Added relative path
        PathEdt.Text := ExtractRelativePath (SetDrive, Trim(StrPas(Temp2)));
        //PathEdt.Text := Trim(StrPas(Temp2));

      StrDispose (Temp1);
      StrDispose (Temp2);
    End { If OpenDialog1.Execute }
    Else
      // HM 23/05/00: Added save/restore of directory
      ChDir(CDir);
  end;
end;

procedure TLetterDlg.FormShow(Sender: TObject);
begin
 if Length(PathEdt.Text) = 0 then
  PathEdt.SetFocus;
end;

procedure TLetterDlg.PathEdtChange(Sender: TObject);
begin
 if (Label81.Caption = 'Webpage') and (Length(PathEdt.Text) >= 84) and (showOnce = true) then
 begin
  ShowMessage(Format('The url you have entered is too long, you have used %d of ' +
    '84 characters.',[Length(PathEdt.Text)]));
  showOnce := false;
 end;
end;

end.
