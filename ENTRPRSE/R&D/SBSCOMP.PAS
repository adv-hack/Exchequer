unit Sbscomp;

interface

{$F+}

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,ExtCtrls,GlobVar,VarConst,BtrvU2,ETStrU,BtSupU1,
  Mask, Grids, Buttons,SBSPanel,SBSComp2, SortViewU,

  // MH 26/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  ExportListIntf,

  SButton;



Const
  NofScanFilters  =  4;
  MaxMULCols      =  30;
  YNState         :  Array[BOff..BOn] of Str5 = ('FALSE','TRUE');


type

  FilterType    =  Array[1..NofScanFilters,0..1] of Str10;

  //HV 19/05/2017 2017-R2 ABSEXCH-18380: Exchequer Lists Crash with Range Check Error displaying > 101 rows, increasing the size of the arrays
  PageAType  =  Array[0..200] of LongInt;
  KeyAType   =  Array[0..200] of Str255;

  //PR: 25/10/2010 Extended TStringGrid class to handle WM_CAPTURECHANGED message as the mouse up event
  //doesn't occur when a different app takes the focus - this may have been causing a crash.
  TStringGridEx = Class(TStringGrid)
  private
    // CJS 2015-05-05 - v7.0.14 - PPD - T2-119 - Extend Btrieve List Components to support Cell based colouring
    // The Position property holds the column position of this string-grid in
    // the list (as TMULCtrl is based on a set of string-grids, one grid for
    // each column).
    FPosition: Integer;
  public
    Procedure WMCaptureChanged(Var Message  :  TMessage); Message WM_CAPTURECHANGED;
    property Position: Integer read FPosition write FPosition;
  end;

  //PR: 25/10/2010
  PMULBox    =  TStringGridEx;
//  PMULBox    =  TStringGrid;

  PMulBoxes  =  Array[0..MaxMULCols] of PMULBox;

  CoorType   =  Array[0..MaxMULCols] of Word;

  SGDispFormat  =  (SGText,SGFloat);


  TColAppear  =  Record
                  AltDefault  :  Boolean;

                  HBkColor,
                  HTextColor  :  TColor;

                  DispFormat  :  SGDispFormat;

                  NoDecPlaces :  Byte;

                  // MH 05/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality, a string
                  // allows more flexibility and simplifies the passing of the data through the various layers
                  // to get to the code that actually implements it
                  ExportMetadata : ANSIString;
                end;

  TSelectCol  = Record
                  CurrentCol  :  TStringGrid;
                  LastTCol,
                  LastBCol    :  TColor;
                  InUse       :  LongInt;
                end;

  // CJS 2015-05-05 - v7.0.14 - PPD - T2-119 - Extend Btrieve List Components to support Cell based colouring
  // Simple record structure to pass details of the current cell.
  TCellDetails = record
    Font      : TFont;
    TextColour: TColor;
    BackColour: TColor;
    RecAddress: LongInt;
    Contents  : string;
  end;

  TColAppearList  =  Array[0..MaxMULCols] of TColAppear;


  TMULCtrl = class(TPanel)

    //PR: 25/10/2010
    MUListBox1: TStringGridEx;
//    MUListBox1: TStringGrid;

    Constructor Create(AOWner  :  TComponent); override;

    Destructor  Destroy; override;

    Function ValidLine  :  Boolean;

    procedure MUListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetButtnStat;
    procedure ListCreate; Virtual;
    procedure ListDestroy;

    procedure ScrollSelCol(MoveX  :  Integer);

    procedure SetSelectCol(Sender  :  TStringGrid);

    procedure RestoreSelectCol;

    procedure ReSetSelectCol(Sender  :  TStringGrid);

    procedure InitSelectCol;

    Procedure Set_Buttons(HostPanel   :  TSBSPanel);

    Procedure ReFresh_Buttons;

    // CJS 2015-05-05 - v7.0.14 - PPD - T2-119 - Extend Btrieve List Components to support Cell based colouring
    procedure ModifyCell(Col, Row: LongInt; var CellDetails: TCellDetails); virtual;

    procedure MULDrawCell(Sender: TObject; Col, Row:
                          LongInt; Rect: TRect; State: TGridDrawState);

    procedure ButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MUListBox1Click(Sender: TObject);

    procedure MUListBoxSelectCell(Sender: TObject; Col, Row: Longint;
                              var CanSelect: Boolean);

    procedure Set_ButtonsVisible(State :  Boolean);

    procedure MUListBox1MouseDown(Sender: TObject; Button: TMouseButton;
                                  Shift: TShiftState; X, Y: Integer);

    procedure MUListBox1MouseUp(Sender: TObject; Button: TMouseButton;
                                  Shift: TShiftState; X, Y: Integer);

    procedure MUListBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    procedure MUListBox1MouseKeyDown(Sender: TObject; var Key: Word;
                                     Shift: TShiftState);


    procedure BtnPanelMouseDown(Sender: TObject;
                                Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  private
    fInProc  :  Boolean;
    fDoingDestroy
             :  Boolean;
    THeight,
    TIHeight,
    ItemScrn :  Integer;

    LKeyTime,
    KeyTime  :  TDateTime;

    MsgForm  :  TForm;

    FSQLCacheID: Integer;
    FUseVariant: Boolean;
    FSQLCacheExpiryTime: TDateTime;
    FSQLCacheTimeOut: Integer;
    FSQLWhereClause: string;
    FSQLColumns: string;

    // MH 01/03/2018 2018-R2 ABSEXCH-19172: Added flag to disable popup window which hides the List Export progress dialog
    RunningListExport : Boolean;

    Function ReadInListF  :  Boolean;

    Procedure SetInListF(FO  :  Boolean);

    Function CalcSame(TFilt,TChk  :  Str20;
                      FiltLen     :  Byte;
                      Same,AsIs   :  Boolean)  :  Boolean;

    Function PassFilter(Key2Chk     :  Str255)  :  Boolean;



    Procedure Move_Row(From,Too  :  Byte);


    Procedure Show_Row(From,Too  :  Byte);

    Procedure Delete_Row(Too  :  Byte);

    Procedure SetCursor(Wait  :  Boolean);

    Procedure SetHome;

    Procedure PgDeleteLine(FPos  :  LongInt;
                           AKey  :  Str255);

    Procedure AddLine(FPos  :  LongInt;
                      AKey  :  Str255);

    Procedure InsertLine(FPos  :  LongInt;
                         AKey  :  Str255);



    Function Check_Seek(FWrd  :  Boolean;
                        FPos  :  LongInt;
                        ChkMode
                              :  Boolean)  :  Boolean;


    Procedure NextLine;
    Procedure PrevLine;


    Procedure PageEnd;

    Function BuildFindKey(KeyS  :  Str255;
                          VKey  :  Word)  :  Str255; Virtual;

    Procedure PageFind(StartPos  :  Integer;
                   Var VKCode    :  Word);


    procedure MUListBoxDblClick(Sender: TObject);

    procedure SetUseVariant(const Value: Boolean);
    function GetSortViewEnabled: Boolean;

  protected
    FSortView: TBaseSortView;
    procedure SetSortView(const Value: TBaseSortView);
    function GetSortView: TBaseSortView;
    //PR: 07/10/2011 Added SetEndKey method to allow descendants to override (ABSEXCH-11736)
    procedure SetEndKey(var KeyS : Str255); virtual;
  public

    MUListBoxes   :  PMULBoxes;

    VisiList      : TVisiList;

    LButtonPanel  :  TSBSPanel;

    BitBtns       :  Array[1..6] of TScrollButton;

    {BitBtns       :  Array[1..6] of TBitBtn;}

    //PR/CS Changed to 200 elements.
    EmphRow       :  Array[0..200] of Byte;
//    EmphRow       :  Array[0..100] of Byte;

    {LeftCoor      :  CoorType;
    WidthCoor     :  CoorType;}

    MUTotCols,
    TotBtns       :  Byte;

    ItemCount,
    ScreenLeft,
    ScreenRight,
    ScreenTop,
    ScreenBot     :  Integer;

    CanDown,
    CanUp,
    ChangeState,
    BeenDClick,
    AutoRepeat1,
    ListStarted,
    InPageUpDn,
    InPgHome,
    InPgEnd,
    AlreadyMove,
    AddUpdateFail :      Boolean;

    MessHandle    :      HWnd;

    PageKeys      :      ^PageAType;
    KeyAry        :      ^KeyAType;
    ColAppear     :      ^TColAppearList;

    CurrLine,
    Mode,
    CXColNo       :      Byte;
    FilterMode,
    DisplayMode   :      Byte;
    ListKey,
    KeyRef,
    KeyRef2,
    KeyFind       :      Str255;

    Filter        :      FilterType;

    TabStart,
    TotCol,
    KeyLen,
    Keypath,
    ScanFileNum   :      Integer;

    StartLess,
    ExitScan,
    DelExternal,
    AllowIns,
    KPlaceOnList,
    AbortOnEmpty,
    InputOnLine,
    StopEdit,
    LongIntLink,
    NoUpCaseCheck,
    CalcEndKey,
    UseSet4End,
    KeyPosOnly,
    AutoDirec,
    ButtonsVisible,
    LinkOtherDisp,
    fInListFind,  //This seems to be a flag to prevent buttons from being triggered by key presses when typing into the list.
    fInListLoop,
    YieldMessage,
    IgnoreMsg,
    IRQSearch,
    ChooseXCol,
    Fill2End
                  :      Boolean;

    WM_ListGetRec :      LongInt;

    ListLocal     :      Pointer;

    ExtRecPtr     :      Pointer;      {* Pointer to record used for Extended search *}

    ExtObjPtr     :      Pointer;      {* Pointer to Object used for extended search *}

    HighLiteStyle :      Array[1..7] of TFontStyles;

    SelectCol     :      ^TSelectCol;


    Procedure RePaint_Row;

    Function ExtFilter  :  Boolean; Virtual;  {* Extended search rec filter *}

    Function GetExtList(B_End      :  Integer; {* Extended search routine *}
                    Var KeyS       :  Str255)  :  Integer; Virtual;

   { CJS 09/03/2011 - ABSEXCH-9887 - Amendment to reduce flickering }
    Procedure DispExtMsg(State  :  Boolean; ForceClose: Boolean = False);

    Function LineOk(KeyS  :  Str255)  :  Boolean;

    Procedure GetMatch(B_Begin,
                       B_End         :  Integer;
                   Var Key2Match     :  str255);

    Function There_Others  :  Boolean;

    Function GoodEnough  :  Boolean;

    Function GetCode(Mode      :  Integer)  :  Boolean;

    Function CheckInListFocus  :  Boolean;

    Function ListStillBusy  :  Boolean;

    Procedure InitPage;

    Procedure ExtObjCreate; Virtual;

    Procedure ExtObjDestroy; Virtual;

    Procedure Set_Row(Too  :  Byte);

    Procedure Update_Row(RowX  :  Integer);

    Procedure Update_Select(RowX  :  Integer;
                            UpRow :  Boolean);

    Procedure StartList(Fnum,KeypathS :  Integer;
                        Key2F,
                        Key2R,
                        LKey         :  Str255;
                        KLen         :  Integer;
                        PrimeOnly    :  Boolean;
                        WhereClause  :  string = '';
                        Columns      :  string = ''); Virtual;

    Procedure AddNewRow(StartPos  :  LongInt;
                        EditMode  :  Boolean);

    Procedure PageUpDn(StartPos  :  LongInt;
                       Fwrd      :  Boolean);

    Function SetCheckKey  :  Str255; Virtual;

    Function SetFilter  :  Str255; Virtual;

    Function Ok2Del :  Boolean; Virtual;

    Function CheckRowEmph :  Byte ; Virtual;

    Function OutLine(Col  :  Byte)  :  Str255; Virtual;

    Procedure SetMoveData(IVal  :  LongInt); Virtual;


    Procedure MoveEmUp(KeyChk,
                       KeyS,
                       KeyLimit:  Str255;
                       IncBy   :  LongInt);

    Procedure Find_OnList(KeyChk     :  Str255;
                          SearchNdx  :  Integer);

    function Find_OnActualList(FNum: Integer; Key: Str255; Ndx: Integer): Boolean;

    Procedure RefreshLine(CNo  :  Byte;
                          FWd  :  Boolean);

    Procedure GetSelRec(Update  :  Boolean);

    Procedure Send_ListRecMsg(MMode     :  Byte;
                              AddParam  :  Word;
                              MX,MY     :  LongInt);

    Procedure ReSizeOneCol(Start  :  Integer);

    procedure SetListFocus;

    Procedure InitVarCol(Start  :  Integer);

    Procedure RefreshAllCols;

    Procedure HideAllCols(SetHide  :  Boolean);

    Procedure ApplyReSizeAllCols(Start,BarOfSet  :  Integer;
                                 UseOfSet        :  Boolean);

    Procedure ReSizeAllCols(Start,BarOfSet  :  Integer);

    Procedure ReSizeMoveCol(Start,SBOffSet  :  Integer);

    Procedure MoveListCol(FromCol,ToCol,SBOffSet  :  Integer);

    Procedure FinishColMove(SBOffSet  :  Integer;
                            Resized   :  Boolean);

    Procedure ReColorCol(NewFont  :  TFont;
                         NewColor :  TColor;
                         UpLabel  :  Boolean);

    Procedure ReColorBar(NewFont  :  TFont;
                         NewColor :  TColor);

    Procedure ReAssignCols;

    Procedure HideCols(HideMode  :  Boolean);

    Procedure Intercept_ListClick(Mode      : SmallInt;
                                  MX,MY     :  LongInt); Virtual;

    procedure RefreshCache;

    // CJS 2015-06-25 - ABSEXCH-16552 - Set-unset PPD does not check for empty lines
    function SelectedRowIsValid: Boolean;

    // CJS 2015-05-22 - v7.0.14 - PPD Amendments
    // Moved this from private to pubic so that it can be called externally
    procedure PrepareSQLCall;

    // MH 26/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
    Procedure ExportList (ExportIntf : IExportListData; Const CommandID : Integer; Const ProgressHWnd : HWnd);

    Property InListFind  :  Boolean read ReadInListF write SetInListF;
    Property InListLoop  :  Boolean read fInListLoop write fInListLoop;

    property SQLCacheID: Integer read FSQLCacheID;
    property UseVariant: Boolean read FUseVariant write SetUseVariant;
    property SQLCacheTimeOut: Integer read FSQLCacheTimeOut write FSQLCacheTimeOut;

    { This property must be completely replaced in descendant classes, which
      should replace the GetSortView function with a function which casts
      the return value to the correct TSortView descendant class, and **must**
      replace SetSortView with a procedure which calls the inherited
      SetSortView procedure. This is clumsy, but seems the least error-prone
      way of ensuring that SortView is set up correctly. }
    property SortView: TBaseSortView read GetSortView write SetSortView;

    { We can't call FSortView.Enabled directly, in case FSortView hasn't yet
      been assigned. Instead, this function is used, which checks whether
      FSortView is nil or not. It returns False in that case, otherwise it
      returns the FSortView.Enabled value. }
    property SortViewEnabled: Boolean read GetSortViewEnabled;

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Uses
  {$IFDEF EXSQL}
  SQLUtils,
  {$ENDIF}
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    MadExceptSupport,
  {$ENDIF}
  TEditVal;

{ ================== List Supporting Routines =================== }


Function TMULCtrl.SetCheckKey  :  Str255;


Var
  DumStr  :  Str255;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  Case ScanFileNum of

    CustF  :  DumStr:=Cust.CustCode;

  end;

  SetCheckKey:=DumStr;
end;




Function TMULCtrl.SetFilter  :  Str255;

Begin

  Case ScanFileNum of
    CustF  :  SetFilter:=Cust.CustSupp;

  end; {Case..}

end;


Function TMULCtrl.Ok2Del :  Boolean;

Begin
  Case DisplayMode of
    1..13  :  Ok2Del:=BOn;
    else      Ok2Del:=BOff;
  end; {Case..}
end;


Function TMULCtrl.CheckRowEmph :  Byte;
Begin
  Result:=0;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }

Function TMULCtrl.OutLine(Col  :  Byte)  :  Str255;

Begin
   With Cust do
     Case Col of
       0  :  OutLine:=CustCode;
       1  :  OutLine:=Company;
       {$IFNDEF WCA}
       2  :  OutLine:=Contact;
       3  :  OutLine:=Phone;
       4  :  OutLine:=Fax;
       5  :  OutLine:=FormatFloat(GenRealMask,Balance);
       {$ENDIF}
     end; {Case..}
end;


{ =========== Function to Return True if Search Keys Match (Less WildCards) =========== }

Function TMULCtrl.CalcSame(TFilt,TChk  :  Str20;
                           FiltLen     :  Byte;
                           Same,AsIs   :  Boolean)  :  Boolean;

Var
  n  :  Byte;


Begin
  Tchk:=Copy(TChk,1,FilTLen);

  n:=1;

  While (n<=FiltLen) do
    If (TFilt[n] In WildChars) then
    Begin
      Delete(TFilt,n,1);
      Delete(TChk,n,1);

      Dec(FiltLen)

    end
    else
      Inc(n);

  CalcSame:=(((CheckKey(TFilt,TChk,FiltLen,AsIs)) and (Same)) or
             ((Not CheckKey(TFilt,TChk,FiltLen,AsIs)) and (Not Same))
             or (FiltLen=0));
end; {Func..}



{ ======= Extended search routines ========= }


Function TMULCtrl.ExtFilter  :  Boolean;

Begin
  Result:=BOff;
end;

Function  TMULCtrl.GetExtList(B_End      :  Integer;
                          Var KeyS       :  Str255)  :  Integer;

Begin
  Result:=4;


end;


Procedure TMULCtrl.DispExtMsg(State  :  Boolean; ForceClose: Boolean = False);

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.DispExtMsg';
  {$ENDIF}

  // MH 01/03/2018: Appears to send a message to the window containing the list to stop Eduardo's weird ****
  // code from destroying the components when the list loses focus. 
  Send_ListRecMsg(0,21-Ord(State),0,0);

  // MH 01/03/2018 2018-R2 ABSEXCH-19172: Added flag to disable popup window which hides the List Export progress dialog
  If (Not RunningListExport) Then
  Begin
    If (State) then
    Begin
      if MsgForm = nil then
      begin
        MsgForm:=CreateMessageDialog('Please Wait...'+#13+'...Searching...',mtInformation,[]);
        MsgForm.Show;
      end;
      MsgForm.Update;
      // Sleep(500);
    end
    { CJS 09/03/2011 - ABSEXCH-9887 - Amendment to reduce flickering }
    else if ForceClose and (MsgForm <> nil) then
    begin
      MsgForm.Free;
      MsgForm := nil;
    end;
  End; // If (Not RunningListExport)
end;


{ =========== Function to Check if Search key passes Filter Tests ============== }


Function TMULCtrl.PassFilter(Key2Chk     :  Str255)  :  Boolean;


Var
  BResult
          :  Boolean;
  FiltLen1,
  FiltLen2,
  ChkLen,
  Count   :  Byte;


Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.PassFilter';
  {$ENDIF}

  Count:=1; BResult:=BOn;

  ChkLen:=Length(Key2Chk);

  While (BResult) and (Count<=NofScanFilters) do
  Begin
    FiltLen1:=Length(Filter[Count,0]);
    FiltLen2:=Length(Filter[Count,1]);

    If (ChkLen>=FiltLen1) and (ChkLen>=FiltLen2) then
      BResult:=(CalcSame(Filter[Count,0],Key2Chk,FiltLen1,BOn,NoUpCaseCheck)  and
                CalcSame(Filter[Count,1],Key2Chk,FiltLen2,BOff,NoUpCaseCheck))
    else
      BResult:=BOff;

    Inc(Count);

  end;

  If (BResult) and (ExtRecPtr<>NIL) then   {* Perform addtional filtering for extended search *}
    BResult:=ExtFilter;

  if SortViewEnabled and BResult then
    if not SortView.IsBuildingFile then
      BResult := FSortView.InList;

  PassFilter:=BResult;
end; {Func..}





{ =========== Procedure to Return Next Matched Record in the List =========== }

Procedure TMULCtrl.GetMatch(B_Begin,
                            B_End         :  Integer;
                        Var Key2Match     :  Str255);
Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.GetMatch';
  {$ENDIF}

  Begin
    {$IFDEF EXSQL}
    if UsingSQL then PrepareSQLCall;
    {$ENDIF}
    Status:=Find_Rec(B_Begin,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,Key2Match);

    if (StatusOk) and (SortViewEnabled) then
      Status := FSortView.SyncRecord;

    While (StatusOk) and (CheckKeyRange(KeyRef,KeyRef2,Key2Match,KeyLen,NoUpCaseCheck)) and
          (Not PassFilter(SetFilter))
          and ((Not IRQSearch) or (Not YieldMessage)) do
    Begin
       {* Bug found whereby processing at this point caused a mouseup event to
          be missed, when live linking to another list,
          In some cases during a refresh it is necessary to ignore yield *}

       If (YieldMessage) and (Not IgnoreMsg) then
         Application.ProcessMessages;

//       If (ExtRecPtr<>nil) and (ExtObjPtr<>nil) and (FSQLCacheID = 0) then
       if (not SortViewEnabled) and (ExtRecPtr<>nil) and (ExtObjPtr<>nil) and (FSQLCacheID = 0) then
         Status:=GetExtList(B_End,Key2Match)
       else
       begin
         {$IFDEF EXSQL}
         if UsingSQL then PrepareSQLCall;
         {$ENDIF}
         Status:=Find_Rec(B_End,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,Key2Match);
       end;

      if (StatusOk) and (SortViewEnabled) then
        Status := FSortView.SyncRecord;

    end;

    If (Not StatusOk) or (Not CheckKeyRange(KeyRef,KeyRef2,Key2Match,KeyLen,NoUpCaseCheck)) or (Not PassFilter(SetFilter)) then
    begin
      ResetRec(ScanFileNum);
      { CJS 09/03/2011 - ABSEXCH-9887 - Amendment to reduce flickering }
      DispExtMsg(False, True);
    end;

  end; {With..}

end; {Proc..}


{ =========== Check for similar codes which would also part match ======= }


Function TMULCtrl.There_Others  :  Boolean;


Var
  KeyS         :  Str255;

  TmpStatus,
  TmpKPath,
  TmpStat
               :  Integer;


  Count,
  TmpRecAddr   :  LongInt;


  FoundOk      :  Boolean;




  {$IFDEF Exl_On}

    ExTmpPWrd     :  EPassWordRec;  {* This is for crystal! *}

  {$ENDIF}


  {TmpPWrd     :  PassWordRec;   This is for crystal! *}


Begin

  Count:=1;

  FoundOk:=BOff;

  TmpStatus:=Status;


  TmpKPath:=GetPosKey;

  {$IFDEF EXSQL}
  if UsingSQL then PrepareSQLCall;
  {$ENDIF}
  TmpStat:=Presrv_BTPos(ScanFileNum,TmpKPath,F[ScanFileNum],TmpRecAddr,BOff,BOff);

  {PushHot(PopGlob);}


  {$IFDEF Exl_On}

    ExTmpPWrd:=EPassWord;

  {$ENDIF}


  {TmpPWrd:=PassWord;}


  KeyS:=KeyRef;

  GetMatch(B_GetGEq,B_GetNext,KeyS);


  While (StatusOk) and (CheckKey(KeyRef,KeyS,KeyLen,NoUpCaseCheck)) and (Not FoundOk) do
  Begin

    FoundOk:=(Count>1);

    Inc(Count);

    GetMatch(B_GetNext,B_GetNext,KeyS);

  end; {While..}


  {$IFDEF EXSQL}
  if UsingSQL then PrepareSQLCall;
  {$ENDIF}
  TmpStat:=Presrv_BTPos(ScanFileNum,TmpKPath,F[ScanFileNum],TmpRecAddr,BOn,BOn);

  {PopHot(PopGlob);}

  {$IFDEF Exl_On}

    EPassWord:=ExTmpPWrd;

  {$ENDIF}

  {PAssWord:=TmpPWrd;}


  Status:=TmpStatus;

  There_Others:=FoundOk;

end; {Func..}



{ ============= Function to Check if Part Find Good Enough ============ }

Function TMULCtrl.GoodEnough  :  Boolean;



Var
  TempRecPos  :  Longint;
  GotCode     :  Str255;


Begin
  TempRecPos:=0; GotCode:='';

  {$B-}


  If (StatusOk) and (Not PassFilter(SetFilter)) and (KeyRef='') then
    Status:=4;

  If (((Not StatusOk) or (Not PassFilter(SetFilter)))
     or ((StatusOk) and (There_Others))) and (KeyRef<>'') then

  Begin

  {$B+}

    GotCode:=KeyRef;

    GetMatch(B_GetGEq,B_GetNext,GotCode);

    If (CheckKey(KeyRef,GotCode,KeyLen,NoUpCaseCheck)) and (Status<>B_Eof) then
    Begin
      {$IFDEF EXSQL}
      if UsingSQL then PrepareSQLCall;
      {$ENDIF}
      Status:=GetPos(F[ScanFileNum],ScanFileNum,TempRecPos);

      GetMatch(B_GetNext,B_GetNext,GotCode);

      If (Not CheckKey(KeyRef,GotCode,KeyLen,NoUpCaseCheck)) or (Status=B_Eof) then
      Begin
        SetDataRecOfs(ScanFileNum,TempRecPos);

        {$IFDEF EXSQL}
        if UsingSQL then PrepareSQLCall;
        {$ENDIF}
        Status:=GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,0);

        if SortViewEnabled then
          FSortView.SyncRecord;

      end
      else
        Status:=4;
    end
    else
      Status:=4;
  end;


  GoodEnough:=StatusOk;

end;



{ ============= Function to Get Code ============= }

Function TMULCtrl.GetCode(Mode      :  Integer)  :  Boolean;

Const
  DMode  = 1;

Var
  FoundOk  :  Boolean;


Begin
  FoundOk:=BOff;


  ResetRec(ScanFileNum);

  {$IFDEF EXSQL}
  if UsingSQL then PrepareSQLCall;
  {$ENDIF}
  Status:=Find_Rec(B_GetEq,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,ListKey);

  If (Mode=-1) then
    FoundOk:=StatusOk
  else
    FoundOk:=GoodEnough;


  GetCode:=FoundOk;
end;


Function TMULCtrl.CheckInListFocus  :  Boolean;

Var
  n  :  Byte;

Begin
  Result:=Boff;

  For n:=0 to MUTotCols do
  Begin
    if Assigned(MUListBoxes[n]) then //PR/CS 27/10/2010
    begin
       Result:=MUListBoxes[n].Focused;

       If (Result) then
         Exit;
    end;
  end; {Loo..}
end;

Procedure TMULCtrl.Move_Row(From,Too  :  Byte);

Var
  n  :  Byte;

Begin

  {With MUListBox1 do
    Cells[0,Too]:=Cells[0,From];}

  For n:=0 to MUTotCols do
    if Assigned(MUListBoxes[n]) then
    begin
      if (From < MUListBoxes[n].RowCount) and
         (Too < MUListBoxes[n].RowCount) then //PR/CS 27/10/2010
            With MUListBoxes[n] do
               Cells[0,Too]:=Cells[0,From];
    end;


end;


Procedure TMULCtrl.Set_Row(Too  :  Byte);

Var
  OCO,
  n  :  Byte;

Begin

  {With MUListBox1 do
    Cells[n,Too]:=OutLine(0);}
  if (Too <= High(EmphRow)) then
    EmphRow[Too]:=CheckRowEmph
  else
    raise Exception.Create('TMULCtrl.Set_Row: Bold Index out of range (' + IntToStr(Too) + ').');

  For n:=0 to MUTotCols do
  Begin


    With VisiList do
    Begin
      OCO:=FindxColOrder(n);

      VisiRec:=List[OCO];
    end;

    If (Not VisiList.VisiRec^.HidePanel) then
      if Assigned(MUListBoxes[n]) then //PR/CS 27/10/2010
      begin
        if (Too < MUListBoxes[n].RowCount) then
          With MUListBoxes[n] do
            Cells[0,Too]:=OutLine(n);
      end;
  end;

end;


Procedure TMULCtrl.Update_Row(RowX  :  Integer);

Var
  n       :  Byte;
Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.Update_Row';
  {$ENDIF}

  // V6.00 Fix to prevent infinite loop under SQL
  //PR/CS: 27/10/2010 Moved fInProc := False to inside the not fInProc block.
  If (not fInProc) then
  Try
    fInProc:=BOn;
    With MUListBox1 do
      Row:=RowX;

    For n:=0 to MUTotCols do
      if Assigned(MUListBoxes[n]) then
      begin
        if (RowX >= 0) and (RowX < MUListBoxes[n].RowCount) then
          With MUListBoxes[n] do
            Row:=RowX;
      end;
   Finally
     finProc:=BOff;
   End; {Try..}
end; {Proc..}


Procedure TMULCtrl.RePaint_Row;

Var
  n  :  Byte;
Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.RePaint_Row';
  {$ENDIF}

  For n:=0 to MUTotCols do
    if Assigned(MUListBoxes[n]) then //PR/CS 27/10/2010
      With MUListBoxes[n] do
        Refresh;

end; {Proc..}


Procedure TMULCtrl.Update_Select(RowX  :  Integer;
                                 UpRow :  Boolean);

Var
  n        :  Byte;
  SelRect  :  TGridRect;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.Update_Select';
  {$ENDIF}

  With MUListBox1 do
  Begin

    If (UpRow) then
      Update_Row(RowX);

    Col:=0;
    SelRect.Left:=0;
    SelRect.Top:=RowX;
    SelRect.Right:=0;
    SelRect.Bottom:=RowX;
    Selection:=SelRect;

  end;

  For n:=0 to MUTotCols do
    if Assigned(MUListBoxes[n]) then
    begin
      if (RowX >= 0) and (RowX < MUListBoxes[n].RowCount) then //PR/CS 27/10/2010
      With MUListBoxes[n] do
      Begin
        Row:=RowX;
        Col:=0;
        SelRect.Left:=0;
        SelRect.Top:=RowX;
        SelRect.Right:=0;
        SelRect.Bottom:=RowX;
        Selection:=SelRect;
      end;
    end; //if assigned


end; {Proc..}

Procedure TMULCtrl.Show_Row(From,Too  :  Byte);

Var
  n  :  Byte;

Begin

  For n:=From to Too do
    if Assigned(MUListBoxes[n]) then //PR/CS 27/10/2010
       With MUListBoxes[n] do
         Update;


end;

Procedure TMULCtrl.Delete_Row(Too  :  Byte);

Var
  n  :  Byte;

Begin

  {With MUListBox1 do
    Cells[n,Too]:=OutLine(0);}

  For n:=0 to MUTotCols do
    if Assigned(MUListBoxes[n]) then //PR/CS 27/10/2010
    begin
      if (Too < MUListBoxes[n].RowCount) then
        With MUListBoxes[n] do
          Cells[0,Too]:='';
    end;

end;


Procedure TMULCtrl.SetCursor(Wait  :  Boolean);

Var
  n  :  Byte;

Begin


  For n:=0 to MUTotCols do
    if Assigned(MUListBoxes[n]) then //PR/CS 27/10/2010
      With MUListBoxes[n] do
        If (Wait) then
          Cursor:=CrHourGlass
        else
          Cursor:=CrDefault;

end;


procedure TMULCtrl.ExtObjCreate;

Begin
  ExtRecPtr:=nil;
  ExtObjPtr:=nil;
end;


Function TMULCtrl.ReadInListF  :  Boolean;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.ReadInListF';
  {$ENDIF}

  Result:=fInListFind;

  fInListFind:=BOff;
end;

Procedure TMULCtrl.SetInListF(FO  :  Boolean);

Begin
  If (FO<>fInListFind) then
    fInListFind:=FO;
end;



Function TMULCtrl.ListStillBusy  :  Boolean;

Begin
  Result:=InListFind or ListStarted or InPageUpDn or InPgHome or InPgEnd or InListLoop;
  if (SortViewEnabled) then
    if SortView.IsBuildingFile then
      Result := True;
end;


Constructor TMULCtrl.Create(AOwner  :  TComponent);

Var
 n  :  Byte;

Begin
  Inherited Create(AOwner);

  fInProc := False;
  fDoingDestroy:=False;

  MUTotCols:=3;
  CanUp:=False;
  ItemCount:=-1;
  CurrLine:=0;
  AutoRepeat1:=False;
  BeenDClick:=False;
  AlreadyMove:=BOff;
  InListFind:=BOff;
  InListLoop:=BOff;
  YieldMessage:=BOff;
  IgnoreMsg:=BOff;
  IRQSearch:=BOff;
  ListStarted:=BOff;
  InPageUpDn:=BOff;
  InPgHome:=BOff;
  InPgEnd:=BOff;
  AddUpdateFail:=BOff;

  Fill2End:=BOff;
  ChooseXCol:=BOff;
  CXColNo:=0;
  FilterMode:=0;
  StartLess:=BOff;

  FillChar(EmphRow,Sizeof(EmphRow),0);

  ListLocal:=nil;

  MessHandle:=0;

  TotBtns:=6;
  ChangeState:=False;

  ScreenTop:=0; ScreenLeft:=0;
  ScreenRight:=0; ScreenBot:=0;

  New(PageKeys);
  New(KeyAry);
  New(ColAppear);
  New(SelectCol);


  FillChar(Filter,Sizeof(Filter),0);

  FillChar(PageKeys^,Sizeof(PageKeys^),0);
  FillChar(KeyAry^,Sizeof(KeyAry^),0);
  FillChar(ColAppear^,Sizeof(ColAppear^),0);

  FillChar(SelectCol^,Sizeof(SelectCol^),0);

  For n:=0 to MaxMULCols do
  With ColAppear^[n] do
  Begin
    HTextColor:=clHighLightText;
    HBkColor:=clHighLight;

    DispFormat:=SGText;
  end;

  FUseVariant := False;
  FSQLCacheID := 0;

  TabStart:=0;

  VisiList:=TVisiList.Create;

  FSQLCacheTimeOut := 10;

  // MH 01/03/2018 2018-R2 ABSEXCH-19172: Added flag to disable popup window which hides the List Export progress dialog
  RunningListExport := False;
end;

procedure TMULCtrl.ListCreate;

Var
  n  :  Byte;

  L,T,W,H
     :  Integer;

begin

  //PR: 25/10/2010 Change to use TStringGridEx to allow handling of CaptureChanged message
  MUListBox1:=TStringGridEx.Create(Self);
//  MUListBox1:=TStringGrid.Create(Self);

  VisiList.SetCoord(0,MUListBox1);

  With MUListBox1 do
  Begin

    BorderStyle:=BsNone;
    ParentCtl3d:=BOff;
    Ctl3d:=BOff;
    TabStop := BOff;
    ColCount := 0;
    ColWidths[0]:=0;
    FixedCols := 0;
    FixedRows := 0;
    GridLineWidth := 0;
    TabOrder:=TabStart;
    
    { CJS 2012-06-22: ABSEXCH-11527 - Btrieve list font size }
    DefaultRowHeight := abs(Font.Height) + 5;

    Color:=Self.Color;
    ParentColor := BOff;

    ScrollBars := ssNone;
    Visible:=BOff;
    Options:=Options + [GoDrawFocusSelected]-[GoRangeSelect];

    THeight:=Height;
    TIHeight:=DefaultRowHeight;

    RowCount:=Trunc((THeight-2)/TIHeight);
    ItemScrn:=Pred(RowCount);

    Font:=Self.Font;

    FillChar(HighLiteStyle,Sizeof(HighliteStyle),0);


    OnMouseDown:=MUListBox1MouseDown;
    OnMouseUp:=MUListBox1MouseUp;
    {OnMouseMove:=MUListBox1MouseMove;}
    OnClick:=MUListBox1Click;
    OnDblClick:=MUListBoxDblClick;
    OnKeyDown:=MUListBox1KeyDown;

  end;

  MUListBox1.Parent:=Parent;

  For n:=0 to MUTotCols do
  Begin
  //PR: 25/10/2010 Change to use TStringGridEx to allow handling of CaptureChanged message
    MUListBoxes[n]:=TStringGridEx.Create(Self);
//    MUListBoxes[n]:=TStringGrid.Create(Self);

    With MUListBoxes[n] do
    Begin
      // CJS 2015-05-05 - v7.0.14 - PPD - T2-119 - Extend Btrieve List Components to support Cell based colouring
      // Store the 'column' position of this string-grid
      Position := n;

      InitVarCol(n);

      BorderStyle:=MUListBox1.BorderStyle;
      Ctl3d:=MUListBox1.Ctl3d;
      TabOrder := MUListBox1.TabOrder+n;
      Tag:=n;
      TabStop := BOn;
      ColCount := 0;
      DefaultRowHeight := MUListBox1.DefaultRowHeight;

      FixedCols := MUListBox1.FixedCols;
      FixedRows := MUListBox1.FixedRows;
      Font:=MUListBox1.Font;
      GridLineWidth := MUListBox1.GridLineWidth;
      ParentColor := MUListBox1.ParentColor;
      Color := MUListBox1.Color;

      {Brush.Style:=bsClear;} {* Weird effects! *}

      ParentCtl3d:=MUListBox1.ParentCtl3d;
      RowCount := MUListBox1.RowCount;
      ScrollBars := MUListBox1.ScrollBars;
      Options:=MUListBox1.Options;
      OnMouseDown:=MUListBox1.OnMouseDown;
      OnMouseUp:=MUListBox1.OnMouseUp;
      OnMouseMove:=MUListBox1.OnMouseMove;
      OnClick:=MUListBox1.OnClick;
      OnDblClick:=MUListBox1.OnDblClick;
      OnKeyDown:=MUListBox1.OnKeyDown;
      //Name:='SG'+IntToStr(n);

      If (n=0) then
        OnSelectCell:=MUListBoxSelectCell;


      If (ColAppear^[n].AltDefault) then {* If col will be different from standard *}
      Begin
        OnDrawCell:=MULDrawCell;
        DefaultDrawing:=BOff;
      end;

    end;

    MUListBoxes[n].Parent:=Parent;


  end; {Loop..}


  { == Init Main ScanParam vars == }

  Mode:=0; KeyLen:=0; Keypath:=0; ScanFileNum:=0;

  ExitScan:=BOff;
  DelExternal:=BOff;
  AllowIns:=BOff;
  KPlaceOnList:=BOff;
  AbortOnEmpty:=BOff;
  InputOnLine:=BOff;
  StopEdit:=BOff;
  LongIntLink:=BOff;
  NoUpCaseCheck:=BOff;
  CalcEndKey:=BOff;
  UseSet4End:=BOff;
  KeyPosOnly:=BOff;
  AutoDirec:=BOff;
  ButtonsVisible:=BOn;


  ExtObjCreate;

end;


{ === Kick off list === }

Procedure TMULCtrl.StartList(Fnum,KeypathS :  Integer;
                             Key2F,
                             Key2R,
                             LKey         :  Str255;
                             KLen         :  Integer;
                             PrimeOnly    :  Boolean;
                             WhereClause  :  string;
                             Columns      :  string);
Var
  OldYMsg  :  Boolean;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.StartList';
  {$ENDIF}

  {= Temp Set up for Cust List =}

  ListStarted:=BOn;

  ScanFileNum:=Fnum;
  KeyPath:=KeyPathS;
  KeyRef:=Key2F;
  KeyRef2:=Key2R;
  ListKey:=LKey;
  KeyFind:='';
  KeyLen:=KLen;

  {$IFDEF EXSQL}
  // CJS 30/11/2010 - Always clear any existing prefill cache (this was
  // originally inside the 'if ... (WhereClause...' check below, which meant
  // that it was not getting cleared if a list switched from using a cache to
  // not using a cache). Also clear any columns.
  if UsingSQL and (FSQLCacheID <> 0) then
  begin
    DropCustomPrefillCache(FSQLCacheID);
    FSQLCacheID := 0;
  end;

  if UsingSQL and ((WhereClause <> '') or (Columns <> '')) then
  begin
    if (UseVariant) then
      raise Exception.Create('UseVariant and Prefilled Cache are mutually ' +
                             'exclusive, but the application has attempted ' +
                             'to set Prefilled Cache when UseVariant is active.');
    FSQLWhereClause := WhereClause;
    FSQLColumns := Columns;
    {
    if (FSQLCacheID <> 0) then
    begin
      DropCustomPrefillCache(FSQLCacheID);
      FSQLCacheID := 0;
    end;
    }
    Status := CreateCustomPrefillCache(SetDrive + Filenames[FNum], WhereClause, Columns, FSQLCacheID);
    FSQLCacheExpiryTime := Now + SQLCacheTimeOut;
  end;
  {$ENDIF}

  if (SortViewEnabled) then
  begin
    SortView.HostLongIntLink := LongIntLink;
    LongIntLink := True;
  end
  else if (FSortView <> nil) then
    LongIntLink := SortView.HostLongIntLink;

  {* Allow processing of messages, so window updates can continue *}

  OldYMsg:=YieldMessage;

  YieldMessage:=((Parent is TWinControl) and (Not PrimeOnly));

  If (YieldMessage) then
    TWinControl(Parent).Refresh;

  If (Not PrimeOnly) then
  Begin
    InitPage;

    If (LinkOtherDisp) then
    Begin
      GetSelRec(BOff);
      Send_ListRecMsg(0,1,0,0);
    end;

  end;

  YieldMessage:=OldYMsg;

  ListStarted:=BOff;

end;


{ == Set Auto List Buttons == }


Procedure TMULCtrl.Set_Buttons(HostPanel   :  TSBSPanel);


Const
  GlyphName  :  array[1..6] of TSButtonType = (btTop, btPageUp, btOneUp, btOneDown, btPageDown, btBottom);

Var
  n  :  Byte;

  BotStart
     :  Integer;

  bsStyle : TSButtonStyle;

Begin

  If (ISWINXPTheme) then
    bsStyle:=bsXP
  else
    bsStyle:=bsStandard;

  For n:=1 to TotBtns do
    BitBtns[n]:=TScrollButton.Create(Self);

  With BitBtns[1] do
  Begin
    Left:=1;
    Top:=1;
    {Width:=16;
    Height:=16;}
    OnMouseDown:=ButtonMouseDown;
    OnMouseUp:=ButtonMouseUp;
    SendKeyDown:=MUListBox1MouseKeyDown;
    Tag:=1;
    {Glyph.Handle:=LoadBitMap(HInstance,GlyphName[1]);
    NumGlyphs:=1;}
    TabStop:=False;
    ButtonStyle := bsStyle;
    ButtonType := btTop;

    bRunningXP:=IsWINXP;

    TabOrder:=Succ(MUListBoxes[MUTotCols].TabOrder);
    Visible:=ButtonsVisible;

    BotStart:=HostPanel.Height-(Height*3)-1;
  end;


  For n:=2 to TotBtns do
  With BitBtns[n] do
  Begin
    Left:=BitBtns[n-1].Left;
    Top:=BitBtns[n-1].Top+BitBtns[n-1].Height;

    If (n=4) then
      Top:=BotStart;

    Width:=BitBtns[n-1].Width;
    Height:=BitBtns[n-1].Height;
    OnMouseDown:=BitBtns[n-1].OnMouseDown;
    OnMouseUp:=BitBtns[n-1].OnMouseUp;

    SendKeyDown:=BitBtns[n-1].SendKeyDown;
    Tag:=n;
    ButtonStyle := bsStyle;

    ButtonType := GlyphName[n];

    TabStop:=BitBtns[n-1].TabStop;

    bRunningXP:=IsWINXP;

    TabOrder:=Succ(BitBtns[n-1].TabOrder);
    Visible:=BitBtns[1].Visible;
  end;

  For n:=1 to TotBtns do
  Begin
    BitBtns[n].Parent:=HostPanel;
  end;

  LButtonPanel:=HostPanel;

  LButtonPanel.OnMouseDown:=BtnPanelMouseDown;

  If (bsStyle=bsXP) then {Alter appearance of panel to flat}
  With LButtonPanel do
  Begin
    Color:=clWindow;
    BevelOuter:=bvNone;
  end;

end; {Set Buttons}


{$IFDEF ENTXP}

Procedure TMULCtrl.Set_Buttons(HostPanel   :  TSBSPanel);


Const
  GlyphName  :  array[1..6] of PChar = ('LSTHOME','LSTPGUP','LSTUP','LSTDN','LSTPGDN','LSTEND');

Var
  n  :  Byte;

  BotStart
     :  Integer;


Begin

  For n:=1 to TotBtns do
    BitBtns[n]:=TBitBtn.Create(Self);

  With BitBtns[1] do
  Begin
    Left:=1;
    Top:=1;
    Width:=16;
    Height:=16;
    OnMouseDown:=ButtonMouseDown;
    OnMouseUp:=ButtonMouseUp;
    OnKeyDown:=MUListBox1MouseKeyDown;
    Tag:=1;
    Glyph.Handle:=LoadBitMap(HInstance,GlyphName[1]);
    NumGlyphs:=1;
    TabOrder:=Succ(MUListBoxes[MUTotCols].TabOrder);
    Visible:=ButtonsVisible;

    BotStart:=HostPanel.Height-(Height*3)-1;
  end;


  For n:=2 to TotBtns do
  With BitBtns[n] do
  Begin
    Left:=BitBtns[n-1].Left;
    Top:=BitBtns[n-1].Top+BitBtns[n-1].Height;

    If (n=4) then
      Top:=BotStart;

    Width:=BitBtns[n-1].Width;
    Height:=BitBtns[n-1].Height;
    OnMouseDown:=BitBtns[n-1].OnMouseDown;
    OnMouseUp:=BitBtns[n-1].OnMouseUp;

    OnKeyDown:=BitBtns[n-1].OnKeyDown;
    Tag:=n;
    Glyph.Handle:=LoadBitMap(HInstance,GlyphName[n]);
    NumGlyphs:=1;
    TabOrder:=Succ(BitBtns[n-1].TabOrder);
    Visible:=BitBtns[1].Visible;

  end;

  For n:=1 to TotBtns do
  Begin
    BitBtns[n].Parent:=HostPanel;
  end;

  LButtonPanel:=HostPanel;

  LButtonPanel.OnMouseDown:=BtnPanelMouseDown;

end; {Set Buttons}
{$ENDIF}


{ == Set Auto List Buttons == }

Procedure TMULCtrl.ReFresh_Buttons;



Var
  n  :  Byte;
  BotStart
     :  Integer;


Begin
  BotStart := 0;
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.ReFresh_Buttons';
  {$ENDIF}

  //PR: 10/02/2011 Added check that BitBtns haven't already been destroyed
  if Assigned(BitBtns[1]) then
  With BitBtns[1] do
  Begin
    Left:=1;
    Top:=1;
    BotStart:=LButtonPanel.Height-(Height*3)-1;
    BringToFront;
  end;


  For n:=2 to TotBtns do
  if Assigned(BitBtns[n]) then //PR: 10/02/2011 Added check that BitBtns haven't already been destroyed
  With BitBtns[n] do
  Begin
    Left:=BitBtns[n-1].Left;
    Top:=BitBtns[n-1].Top+BitBtns[n-1].Height;

    If (n=4) then
      Top:=BotStart;

    BringToFront;
  end;

end; {Set Buttons}



{ == Destroy List resources == }

procedure TMULCtrl.ExtObjDestroy;
Begin
  ExtRecPtr:=nil;
  ExtObjPtr:=nil;
end;


procedure TMULCtrl.ListDestroy;
Var
  n  :  Byte;

begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.ListDestroy';
  {$ENDIF}

  if SortViewEnabled then
    SortView.CancelBuild;

  If (Assigned(PageKeys)) then
  Begin
    Dispose(PageKeys);
    PageKeys:=nil;
  end;

  If (Assigned(KeyAry)) then
  Begin
    Dispose(KeyAry);
    KeyAry:=nil;
  end;

  If (Assigned(ColAppear)) then
  Begin
    Dispose(ColAppear);
    ColAppear:=nil;
  end;

  If (Assigned(SelectCol)) then
  Begin
    Dispose(SelectCol);
    Selectcol:=nil;
  end;

//PR: 19/05/2016 ABSEXCH-17487 StringGrids and BitBtns don't need to be destroyed here, as
//                             they are all parented and will be destroyed when the parent component is destroyed.
//                             Depending upon the order in which components are being destroyed they may have already
//                             been destroyed (but not nilled) at this point, which causes an access violation when
//                             this function tries to free them.
(*
  For n:=0 to MUTotCols do
    If (MUListBoxes[n]<>Nil) then
    Begin
      MUListBoxes[n].Free;
      MUListBoxes[n]:=nil;
    end;

  For n:=1 to TotBtns do
    If (BitBtns[n]<>Nil) then
    Begin
      BitBtns[n].Free;
      BitBtns[n]:=nil;
    end;
*)
  ExtObjDestroy;


  If (VisiList<>nil) then
  Begin
    VisiList.Free;
    VisiList:=nil;
//    MUListBox1.Free;
  end;

  if (SQLCacheID <> 0) then
  begin
    {$IFDEF EXSQL}
    SQLUtils.DropCustomPrefillCache(SQLCacheID);
    {$ENDIF}
  end;
end;

{ == Destroy List component == }

Destructor  TMULCtrl.Destroy;
Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.Destroy';
  {$ENDIF}

  If (Not fDoingDestroy) then
  Begin
    fDoingDestroy:=True;

    ListDestroy;

    Inherited Destroy;
  end;

end;


  { =================== Procedrue to Move to Top of List =============== }

Procedure TMULCtrl.SetHome;
Var
  KeyS    :  Str255;
  RecAddr :  LongInt;
  mbRet   :  Word;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.SetHome';
  {$ENDIF}

  Begin
    ItemCount:=-1;

    Blank(KeyS,Sizeof(KeyS));

    KeyS:=KeyRef;

    ExitScan:=BOff;

    If (StartLess) then
      KeyS:=ListKey
    else
      KeyS:=KeyRef;

    GetMatch(B_GetGEq,B_GetNext,KeyS);

    If (LineOk(KeyS)) then
    Begin
      {$IFDEF EXSQL}
      if UsingSQL then PrepareSQLCall;
      {$ENDIF}
      Status:=GetPos(F[ScanFileNum],ScanFileNum,RecAddr);
      AddLine(RecAddr,SetCheckKey);
    end
    else
    Begin
      ResetRec(ScanFileNum);

      ExitScan:=BOn;

      If (AbortOnEmpty) then
      Begin

        mbRet:=MessageDlg('Unable to find any matching entries!',mtInformation,[mbOk],0);

        Send_ListRecMsg(0,9999,0,0);
      end;
    end;
  end; {with..}

  { CJS 13/04/2011 - ABSEXCH-9887 - Amendment to reduce flickering }
  DispExtMsg(False, True);

end;



Procedure TMULCtrl.InitPage;

Var
  n  :  Integer;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.InitPage';
  {$ENDIF}

  InPgHome:=BOn;

  If (Not IRQSearch) then
  Begin
    {* Reset here again, to avoid corruption during deletion of last item *}

    FillChar(PageKeys^,Sizeof(PageKeys^),0);
    FillChar(KeyAry^,Sizeof(KeyAry^),0);


    SetHome;
    CanDown:=Not ExitScan;

    SetCursor(BOn);

    If (CanDown) then
    Begin
      Repeat

        NextLine;

        If (YieldMessage) and (Not Fill2End) then
          RePaint_Row;

      Until (Not CanDown) or (ItemCount>=ItemScrn) or ((IRQSearch) and (YieldMessage));
    end;

    SetCursor(BOff);

    CanDown:=(ITemCount>=0);

    If (CanDown) then
    Begin
      UpDate_Row(0);

      If (Not IRQSearch) and (ItemCount<>ItemScrn) and (Fill2End) then
      Begin
        n:=0;

        Repeat

          PrevLine;

          Inc(n);


        Until (Not CanUp) or (ItemCount=ItemScrn) or ((IRQSearch) and (YieldMessage));

        UpDate_Row(n);

      end;
    end;



    For n:=Succ(ItemCount) to ItemScrn do
      Delete_Row(n);

    SetButtnStat;

    SetCursor(BOff);
  end; {v5.71 Don't reprocess this list if search interrupted as values found already get lost}
  InPgHome:=BOff;

  { CJS 01/07/2011 - ABSEXCH-9887 - Amendment to reduce flickering }
  DispExtMsg(False, True);

end; {Proc..}


{ ========= Function to Check still belongs to list ====== }

Function TMULCtrl.LineOk(KeyS  :  Str255)  :  Boolean;

Var
  TmpBo  :  Boolean;
  TStr   :  Str255;

Begin

  TStr:=SetFilter;

  TmpBo:=((Status=0) and (CheckKeyRange(KeyRef,KeyRef2,KeyS,KeyLen,NoUpCaseCheck)));

  If (TmpBo) then
    TmpBo:=PassFilter(TStr);

  Result:=TmpBo
end;

{ === Refresh display on a line x line basis ===}

Procedure TMULCtrl.RefreshLine(CNo  :  Byte;
                               FWd  :  Boolean);
Var
  StrSanity  :  Str255;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.RefreshLine';
  {$ENDIF}

  Blank(StrSanity,Sizeof(StrSanity));

  If (PageKeys^[CNo]<>0) then
  Begin
    SetDataRecOfs(ScanFileNum,PageKeys^[CNo]);
    {$IFDEF EXSQL}
    if UsingSQL then PrepareSQLCall;
    {$ENDIF}
    Status:=GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,0);

    if SortViewEnabled then
      FSortView.SyncRecord;

    If (LineOk(SetCheckKey)) then
    Begin
      If (Fwd) then
      Begin
        Set_Row(CNo);

        UpDate_Row(Cno);
      end;
    end
    else
    Begin
      StrSanity:=Trim(SetCheckKey);

      If (StrSanity<>'') then {* v5.70 Corrupt indexes where causing this routine to loop by calling itself. A check is made here for a blank index as a way of preventing the problem *}
      Begin
        If (Cno<>0) then
          PageUpDn(0,BOn)
        else
          InitPage;
      end;
      {* Establish new pos}

    end;
  end; {If Valid address..}

end; {proc..}

Procedure TMULCtrl.GetSelRec(Update  :  Boolean);
Begin

  If (ValidLine) then
    RefreshLine(MUListBoxes[0].Row,UPDate);

end;



Function TMULCtrl.ValidLine  :  Boolean;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.ValidLine';
  {$ENDIF}

  Result:=(PageKeys^[MUListBoxes[0].Row]<>0);

  If (Result) then
  Begin
    RefreshLine(MUListBoxes[0].Row,Boff);
    Result:=LineOk(SetCheckKey);
  end;
end;


Procedure TMULCtrl.AddLine(FPos  :  LongInt;
                           AKey  :  Str255);

Begin
  Inc(ItemCount);

  PageKeys^[ItemCount]:=FPos;

  KeyAry^[ItemCount]:=AKey;

  Set_Row(ItemCount);

end;

Procedure TMULCtrl.InsertLine(FPos  :  LongInt;
                              AKey  :  Str255);

Var
  n  :  Byte;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.InsertLine';
  {$ENDIF}

  For n:=1 to ItemScrn do
    Move_Row(n,Pred(n));


  For n:=1 to ItemScrn do
  Begin
    PageKeys^[Pred(n)]:=PageKeys^[n];
    KeyAry^[Pred(n)]:=KeyAry^[n];
    EmphRow[Pred(n)]:=EmphRow[n];
  end;

  Set_Row(ItemScrn);

  PageKeys^[ItemScrn]:=Fpos;
  KeyAry^[ItemScrn]:=AKey;

  UpDate_Row(ItemScrn);

  CanUp:=True;
end;


Procedure TMULCtrl.PgDeleteLine(FPos  :  LongInt;
                                AKey  :  Str255);

Var
  n  :  Byte;
Begin


  For n:=ItemScrn downto 1 do
  Begin
    PageKeys^[n]:=PageKeys^[Pred(n)];
    KeyAry^[n]:=KeyAry^[Pred(n)];
    EmphRow[n]:=EmphRow[Pred(n)];
    Move_Row(Pred(n),n);
  end;


  Set_Row(0);

  If (ItemCount<ItemScrn) then
    Inc(ItemCount);

  PageKeys^[0]:=FPos;
  KeyAry^[0]:=AKey;

  CanDown:=True;
end;

Function TMULCtrl.Check_Seek(FWrd  :  Boolean;
                             FPos  :  LongInt;
                             ChkMode
                                   :  Boolean)  :  Boolean;

Var
  B_Func,
  B_Func2 :  Integer;
  KeyS    :  Str255;
  GotOk   :  Boolean;


Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.Check_Seek';
  {$ENDIF}

  If (FWrd) then
  Begin
    B_Func:=B_GetGEq;
    B_Func2:=B_GetNext;
    end
  else
  Begin
    B_Func:=B_GetLessEq;
    B_Func2:=B_GetPrev;
  end;

  KeyS:=KeyAry^[Fpos];

  GotOk:=(PageKeys^[Fpos]<>0);

  If (GotOk) then
  Begin
    SetDataRecOfs(ScanFileNum,PageKeys^[FPos]);
    {$IFDEF EXSQL}
    if UsingSQL then PrepareSQLCall;
    {$ENDIF}
    Status:=GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,0);

    GotOk:=(LineOk(SetCheckKey));

    If (GotOk) then
    begin
      GetMatch(B_Func2,B_Func2,KeyS);
    end
    else
      If (Not ChkMode) then {* Atempt to get another valid record *}
      Begin
        KeyS:=KeyAry^[Fpos];

        If (KeyS='') then
          KeyS:=KeyRef;

        GetMatch(B_Func,B_Func2,KeyS);
      end;


    GotOk:=(LineOk(KeyS));
  end
  else
    ResetRec(ScanFileNum);

  Check_Seek:=GotOk;


end; {Func..}




Procedure TMULCtrl.NextLine;

Var
  RecAddr  :  LongInt;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.NextLine';
  {$ENDIF}

  If (Check_Seek(BOn,ItemCount,BOff)) then
  Begin
    {$IFDEF EXSQL}
    if UsingSQL then PrepareSQLCall;
    {$ENDIF}
    Status:=GetPos(F[ScanFileNum],ScanFileNum,RecAddr);

    If (ItemCount>=ItemScrn) then
      InsertLine(RecAddr,SetCheckKey)
    else
      AddLine(RecAddr,SetCheckKey);

    CanDown:=Check_Seek(BOn,ItemCount,BOn);

  end
  else
    CanDown:=BOff;

  ChangeState:=True;



end; {Proc..}



Procedure TMULCtrl.PrevLine;

Var
  RecAddr  :  LongInt;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.PrevLine';
  {$ENDIF}

  If (Check_Seek(BOff,0,BOff)) then
  Begin

    {$IFDEF EXSQL}
    if UsingSQL then PrepareSQLCall;
    {$ENDIF}
    Status:=GetPos(F[ScanFileNum],ScanFileNum,RecAddr);

    If (Status=0) then
    Begin
      PgDeleteLine(RecAddr,SetCheckKey);
      CanUp:=Check_Seek(BOff,0,BOn);
    end
    else
      CanUp:=False;
  end
  else
    CanUp:=False;

  ChangeState:=True;

end; {Proc..}

{== Control page up/Dn ==}

Procedure TMULCtrl.PageUpDn(StartPos  :  LongInt;
                            Fwrd      :  Boolean);

Var
  n     :  Byte;
  TmpI  :  Integer;
  GotOk :  Boolean;
  RecAddr
        :  LongInt;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.PageUpDn';
  {$ENDIF}

  InPageUpDn:=BOn;

  Try
    If (Not IRQSearch) then
    Begin

      TmpI:=MuListBox1.Row;

      SetCursor(BOn);

      SetDataRecOfs(ScanFileNum,PageKeys^[StartPos]);
      {$IFDEF EXSQL}
      if UsingSQL then PrepareSQLCall;
      {$ENDIF}
      Status:=GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,0);

      if SortViewEnabled then
        FSortView.SyncRecord;

      GotOk:=LineOk(SetCheckKey);

      If (Not GotOk) then
        GotOk:=Check_Seek(FWrd,StartPos,BOff);

      If (GotOk) then
      Begin
        CanDown:=BOn;
        CanUp:=BOn;

        ItemCount:=-1;

        FillChar(PageKeys^,Sizeof(PageKeys^),0);
        FillChar(KeyAry^,Sizeof(KeyAry^),0);

        {$IFDEF EXSQL}
        if UsingSQL then PrepareSQLCall;
        {$ENDIF}
        Status:=GetPos(F[ScanFileNum],ScanFileNum,RecAddr);

        AddLine(RecAddr,SetCheckKey);

        While (((CanDown) and (FWrd)) or ((CanUp) and (not FWrd))) and (ItemCount<ItemScrn) and (Not IRQSearch) do
        Begin

          Case Fwrd of
            BOff  :  PrevLine;
            BOn   :  NextLine;
          end; {Case..}
        end;

        If (ItemCount<ItemScrn) then
        Begin
          If (Not Fwrd) then
            PageUpDn(0,(Not Fwrd))
          {else
          Begin
            While (CanUp) and (ItemCount<ItemScrn) do
              PrevLine;
          end;}
        end;

        ResetRec(ScanFilenum);

        For n:=Succ(ItemCount) to ItemScrn do
          Delete_Row(n);

        With MuListBox1 do
          If (ItemCount<TmpI) then
          Begin
            TmpI:=ItemCount;
          end;


        Update_Select(TmpI,BOn);


      end {If Record found ok..}
      else
        PageKeys^[StartPos]:=0; {* Reset row found *}

      {v5.60. If you page from the middle of a page, CanUp/Down will always be false, extra check needed}
        If (TmpI>0) and (TmpI<ItemCount) and ((Not CanUp) or (Not CanDown)) and (PageKeys^[TmpI]<>0) then
        Begin
          CanUp:=(TmpI>0);
          CanDown:=(TmpI<ItemCount);
        end;
      end; {v5.71 Don't reprocess this list if search interrupted as values found already get lost}
  finally

    SetCursor(BOff);

    InPageUpDn:=BOff;

    { CJS 13/04/2011 - ABSEXCH-9887 - Amendment to reduce flickering }
    DispExtMsg(False, True);

  end; {Try..}


end;


Procedure TMULCtrl.AddNewRow(StartPos  :  LongInt;
                             EditMode  :  Boolean);

Var
  TmpI,
  TmpR  :  Integer;
  GotOk :  Boolean;
  RecAddr
        :  LongInt;
  KeyS  :  Str255;

  DisableLink
        :  Boolean;

Begin
  AddUpdateFail:=BOff;

  {$IFDEF EXSQL}
  if UsingSQL then PrepareSQLCall;
  {$ENDIF}
  Status:=GetPos(F[ScanFileNum],ScanFileNum,RecAddr);

  SetDataRecOfs(ScanFileNum,RecAddr);

  {$IFDEF EXSQL}
  if UsingSQL then PrepareSQLCall;
  {$ENDIF}
  Status:=GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,0);

  if SortViewEnabled then
    FSortView.SyncRecord;

  If (LinkOtherDisp) then
  Begin
    TmpI:=Status; {* Preserve Status here! *}
    Send_ListRecMsg(0,1,0,0);
    Status:=TmpI;
  end;

  DisableLink:=LinkOtherDisp;  {* Temporarily stop updating other list, as good chance other list has called this routine *}

  LinkOtherDisp:=BOff;

  TmpR:=StartPos;

  If (Not EditMode) then
  Begin
    If (ItemCount<ItemScrn) then
      TmpR:=Succ(ItemCount)
    else
      TmpR:=ItemCount;
  end;

  KeyS:=SetCheckKey;

  GotOk:=LineOk(KeyS);

  If (Not GotOk) then
    GotOk:=Check_Seek(BOff,StartPos,BOff);

  If (GotOk) then
  Begin

    FillChar(PageKeys^,Sizeof(PageKeys^),0);
    FillChar(KeyAry^,Sizeof(KeyAry^),0);

    TmpI:=0;

    While (LineOk(SetCheckKey)) and (TmpI<=Pred(TmpR)) do
    Begin

      GetMatch(B_GetPrev,B_GetPrev,KeyS);

      If (LineOk(SetCheckKey)) then
      Begin
        KeyAry^[0]:=SetCheckKey;
        {$IFDEF EXSQL}
        if UsingSQL then PrepareSQLCall;
        {$ENDIF}
        Status:=GetPos(F[ScanFileNum],ScanFileNum,PageKeys^[0]);
        Inc(TmpI);
      end;

    end;

    If (TmpI=0) then {* This is the beginning of the list...*}
      TmpR:=0;

    KeyAry^[TmpR]:=KeyS;
    PageKeys^[TmpR]:=RecAddr;


    IF (TmpI<ItemScrn) and (Not EditMode) then
      TmpR:=TmpI
    else
      TmpR:=TmpI;

    MUListBox1.Row:=TmpR;

    {* Refresh page *}

    PageUpDn(0,BOn);

  {* Resetablish file position *}

  SetDataRecOfs(ScanFileNum,RecAddr);
  {$IFDEF EXSQL}
  if UsingSQL then PrepareSQLCall;
  {$ENDIF}
  Status:=GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,0);

  if SortViewEnabled then
    FSortView.SyncRecord;

  {Set_Row(TmpR);}

  end {If Record found ok..}
  else
    AddUpdateFail:=BOn;

  LinkOtherDisp:=DisableLink;

end;

{ === Control End Page === }

Procedure TMULCtrl.PageEnd;

Var
  KeyS         :  Str255;
  LongIntConv  :  LongInt;


Begin
  InPgEnd:=BOn;

  Blank(KeyS,Sizeof(KeyS));
  Blank(LongIntConv,Sizeof(LongIntConv));

  KeyS:=KeyRef;

  If (Length(KeyS)>0) then
  Begin

    CalcEndKey:=BOn;   {* Set we are calculating an end key *}

    If (LongIntLink) then  {* Special Handling needed as sequence is numeric not Ascii Add 1 to raw figure *}
    Begin
      Move(KeyS[1],LongIntConv,Sizeof(LongIntConv));

      Inc(LongIntConv);

      Move(LongIntConv,KeyS[1],Sizeof(LongIntConv));
    end
    else
      If (UseSet4End) then
      Begin

        KeyS:=SetCheckKey;

        CalcEndKey:=BOff;

      end
      else
        SetEndKey(KeyS); //PR: 07/10/2011 ABSEXCH-11736
{        If (KeyRef[Length(KeyRef)]<>NdxWeight) then
          KeyS[Length(KeyS)]:=Succ(KeyS[Length(KeyS)])
        else
          KeyS:=Copy(KeyRef,1,KeyLen);}
  end
  else
    FillChar(KeyS,Sizeof(KeyS),255);

  GetMatch(B_GetLess,B_GetPrev,KeyS);

  If (LineOk(KeyS)) then
  Begin
    CanUp:=BOn;
    {$IFDEF EXSQL}
    if UsingSQL then PrepareSQLCall;
    {$ENDIF}
    Status:=GetPos(F[ScanFileNum],ScanFileNum,PageKeys^[0]);
    KeyAry^[0]:=KeyS;
    PageUpDn(0,BOff);

    If (MuListBox1.Row>=0) then
    Begin
      SetDataRecOfs(ScanFileNum,PageKeys^[MuListBox1.Row]);
      {$IFDEF EXSQL}
      if UsingSQL then PrepareSQLCall;
      {$ENDIF}
      Status:=GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,0);
      CanUp:=Check_Seek(BOff,MuListBox1.Row,BOn);
      CanDown:=Check_Seek(BOn,MuListBox1.Row,BOn);
    end
    else
    Begin
      CanUp:=Check_Seek(BOff,0,BOn);
      CanDown:=BOff;
    end;


  end;

  InPgEnd:=BOff;
end; {Proc..}

{ == Control Find on list by keypress == }

Function TMULCtrl.BuildFindKey(KeyS  :  Str255;
                               VKey  :  Word)  :  Str255;

Var
  TmpS  :  Str255;

Begin
  TmpS:=KeyS+Chr(VKey);

  {MaskEdit1.Text:=TmpS;}

  BuildFindKey:=TmpS;
end;


Procedure TMULCtrl.PageFind(StartPos  :  Integer;
                        Var VKCode    :  Word);

Var
  KeyS  :  Str255;
  LenKey:  Byte;

Begin
  Blank(KeyS,Sizeof(KeyS));
  LenKey:=0;

  KeyTime:=Now;

  {ShowMessage(FloatToStr(KeyTime-LKeyTime));}

  If ((KeyTime-LKeyTime)>=0.0001) then
  Begin
    KeyFind:='';
  end;

  If (KeyFind[1]=#27) then
    FillChar(KeyFind,Sizeof(KeyFind),#0);

  Case VKCode of
    VK_Back   :
                  Begin
                    LenKey:=Length(KeyFind);

                    If (LenKey>0) then
                      Delete(KeyFind,LenKey,1);
                  end;
    VK_Delete  :  Begin
                    KeyFind:='';
                  end;

    else          Begin
                    If (VKCode In [VK_NumPad0..VK_NumPad9]) then {* Convert to number *}
                      VKCode:=VKCode-$30;

                    If (VKCode In [$BF,$BA,$BD,$DC,$BE]) then {-/*|.}
                      VKCode:=VKCode-144;

                    //PR: 04/02/2009 20071214162821 Added $6A and $6D ('*' & '-' on the number pad
                    If (VKCode In [$6A, $6B, $6D, VK_Decimal]) then {+.}
                      VKCode:=VKCode-64;

                    If (VKCode In [$DC]) then {\}
                      VKCode:=VKCode-128;

                    KeyFind:=BuildFindKey(KeyFind,VKCode);

                    VKCode:=0;

                    InListFind:=BOn;
                  end;

  end; {Case..}

  KeyS:=KeyRef+KeyFind;

  If (Not CheckKey(KeyS,KeyAry^[StartPos],Length(KeyS),BOff)) then
  Begin
    GetMatch(B_GetGEq,B_GetNext,KeyS);

    If (LineOk(KeyS)) then
    Begin
      CanDown:=BOn;
      CanUp:=BOff;
      {$IFDEF EXSQL}
      if UsingSQL then PrepareSQLCall;
      {$ENDIF}
      Status:=GetPos(F[ScanFileNum],ScanFileNum,PageKeys^[0]);
      KeyAry^[0]:=KeyS;
      PageUpDn(0,BOn);
      CanUp:=Check_Seek(BOff,0,BOn);
      Update_Select(0,BOn);

      If (ValidLine) then
        Send_ListRecMsg(0,1,0,0); {Update display}
    end;
  end; {If typed a change..}

  LKeyTime:=KeyTime;
end; {Proc..}


procedure TMULCtrl.MUListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

Const
  YNBO  :  Array[False..True] of String[5] = ('False','True');
Var

  UpLiveLink,
  SelCell,
  CanU,CanD
    :  Boolean;

  OldRow,
  TRow
    :  Integer;

begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.MUListBox1KeyDown';
  {$ENDIF}

  InListFind:=BOff;

  If ((Not (ssCtrl In Shift)) and (Not (ssAlt In Shift))) and (Not ListStillBusy) then
  Begin



    CanU:=CanUp;
    CanD:=CanDown;

    SelCell:=BOn;

    UpLiveLink:=BOff;

    TRow:=MUListBox1.Row;

    OldRow:=MUListBoxes[0].Row;


    Update_Select(MUListBox1.Row,BOff);

    With MUListBox1 do
    Begin
      Case Key of

        VK_Down  :  If (Row=ItemScrn) then
                    Begin
                      If (CanDown) then
                      Begin
                        NextLine;

                        UpLiveLink:=(Row=OldRow);
                      end;
                    end
                    else
                    Begin
                      RefreshLine(Row,BOn);

                      If (Row>=Pred(ItemCount)) then
                        CanDown:=Check_Seek(BOn,ItemScrn,BOn);


                      TRow:=Row+Ord((Shift=[SSLeft]));

                      UpDate_Row(TRow);

                      If (OldRow>=Low(PageKeys^)) and (OldRow<=High(PageKeys^)) then
                        CanUp:=(PageKeys^[OldRow]<>0);

                    end;

        VK_Up    :  If (Row=0) then
                    Begin
                      If (CanUp) then
                      Begin
                        PrevLine;
                        UpLiveLink:=(Row=OldRow);
                      end;
                    end
                    else
                    Begin
                      RefreshLine(Row,BOn);

                      If (Row=1) then
                        CanUp:=Check_Seek(BOff,0,BOn);

                      TRow:=Row-Ord(Shift=[SSLeft]);

                      UpDate_Row(TRow);

                      If (OldRow>=Low(PageKeys^)) and (OldRow<=High(PageKeys^)) then
                        CanDown:=(PageKeys^[OldRow]<>0);


                    end;
        VK_Next  :  Begin

                      If (ItemCount=ItemScrn) and (CanDown) then
                      With MUListBox1 do
                      Begin

                        PageUpDn(ItemCount,BOn);

                        CanUp:=True;

                        UpLiveLink:=(Row=OldRow);
                      end;

                    end;

        VK_Prior :  Begin

                      If (ItemCount>=0) and (CanUp) then
                      With MUListBox1 do
                      Begin
                        PageUpDn(0,BOff);
                        CanDown:=True;
                        UpLiveLink:=(Row=OldRow);
                      end;

                    end;

        VK_Home  :  If (ItemCount>=0) then
                    Begin
                      InitPage;
                      UpLiveLink:=(Row=OldRow);
                    end;

        VK_End   :  If (ItemCount>0) and (CanDown) then
                    Begin
                      PageEnd;
                      UpLiveLink:=(Row=OldRow);
                    end;
        VK_Left,
        VK_Right :  Begin
                      If (ChooseXCol) then
                        ScrollSelCol((1*Ord(Key=VK_Right))+(-1*Ord(Key=VK_Left)));
                    end;

        $30..$5A,
        $6A,$6B,$BD,$BE,$BF,$DC,$6D, //PR: 04/02/2009 20071214162821 Added $6D ('-' on the number pad.)
        VK_NumPad0..VK_NumPad9,
        VK_Decimal,
        VK_Back,VK_Delete
                 :  If (ItemCount>=0) and (Shift=[]) then
                      PageFind(Row,Key);

        VK_Return :  If (PageKeys^[MUListBox1.Row]<>0) then
                       Send_ListRecMsg(0,0,0,0);
      end; {Case..}

      If (UpLiveLink) then
        MUListBoxSelectCell(MUListBox1,Col,Row,SelCell);

    end;

    Show_Row(0,MUTotCols);


    Update_Select(MUListBox1.Row,BOff);

    If (CanU<>CanUp) or (CanD<>CanDown) then
      SetButtnStat;

    {If (Shift=[ssLeft]) then
      MUListBoxes[0].SetFocus;}
  end;
end;


procedure TMULCtrl.ScrollSelCol(MoveX  :  Integer);

Var
  CCol  :  Integer;

Begin
  If (Assigned(SelectCol)) then
    With SelectCol^ do
    Begin
      CCol:=CurrentCol.Tag;

      If ((CCol+MoveX)>MUTotCols) then
        CCol:=0
      else
        If ((CCol+MoveX)<0) then
          CCol:=MUTotCols
        else
          CCol:=CCol+MoveX;

      ReSetSelectCol(MUListBoxes[CCol]);
    end; {With..}
end; {Proc..}

procedure TMULCtrl.SetSelectCol(Sender  :  TStringGrid);

Begin
  If (Assigned(SelectCol)) then
    With SelectCol^ do
    Begin
      CurrentCol:=Sender;
      LastTCol:=Sender.Font.Color;
      LastBCol:=Sender.Color;
      Sender.Font.Color:=clWhite;
      Sender.Color:=clRed;
      Inc(InUse);
    end;
end;


procedure TMULCtrl.RestoreSelectCol;

Begin
  With SelectCol^ do
  Begin
    CurrentCol.Font.Color:=LastTCol;
    CurrentCol.Color:=LastBCol;

  end;
end;


procedure TMULCtrl.ReSetSelectCol(Sender  :  TStringGrid);

Begin
  If (Sender<>SelectCol^.CurrentCol) then
  Begin
    RestoreSelectCol;
    SetSelectCol(Sender);
  end;
end;


procedure TMULCtrl.InitSelectCol;

Begin
  If (ChooseXCol) and (SelectCol^.InUse<2) then
    SetSelectCol(MUListBoxes[CXColNo]);
end;


procedure TMULCtrl.SetButtnStat;
Var
  n  :  Byte;
begin
  For n:=1 to TotBtns do
  If (BitBtns[n]<>Nil) then
    With BitBtns[n] do
      Enabled:=(((CanUp) and (n<4)) or ((CanDown) and (n>=4)));

end;

// CJS 2015-05-05 - v7.0.14 - PPD - T2-119 - Extend Btrieve List Components to support Cell based colouring
// Override this method in descendant classes to amend the display. This
// default does nothing, so there is no need to call inherited from the
// descendant classes.

// Note that when this method is called, the current record in the database is
// not necessarily the record which is being displayed on the current line, so
// the Record Address stored in CellDetails.RecAddress will need to be used to
// get the correct record.
procedure TMULCtrl.ModifyCell(Col, Row: Integer; var CellDetails: TCellDetails);
begin
//  if (Row = 5) and (Col = 1) then
//    CellDetails.BackColour := $00FF00;
end;

procedure TMULCtrl.MULDrawCell(Sender: TObject; Col, Row:
                               LongInt; Rect: TRect; State: TGridDrawState);
       VAR
         R        : TRect;
         S        : String;
         SGTagNo,
         TotDecPs : Byte;

         OldFontColor,
         OldBrushColor : TColor;

         CellDetails: TCellDetails;


       BEGIN
         {$IFDEF MADEXCEPT}
           // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
           If MadExceptListLogging Then
             MadExceptSupport.MadExceptLoggingString := ClassName + '.MULDrawCell';
         {$ENDIF}

         SGTagNo:=(Sender as TStringGrid).Tag;
         // CJS: Added manual range checking, because BtrvU2 switches range-checking off.
         if (SGTagNo > MaxMULCols) then
           Exit;

         WITH (Sender as TStringGrid).Canvas DO
         Begin
           TotDecPs:=ColAppear^[SGTagNo].NoDecPlaces;

           Font := (Sender as TStringGrid).Font;

           OldFontColor := Font.Color;
           OldBrushColor := Brush.Color;

           // CJS: Added manual range checking, because BtrvU2 switches range-checking off.
           If (Row >= Low(EmphRow)) and (Row <= High(EmphRow)) then
           Begin
             {MessageBeep(0);

             SetTextColor( Handle, ColorToRGB( clWhite) );
             SetBkColor( Handle, ColorToRGB( clRed) );}

             // CJS: Added manual range checking, because BtrvU2 switches range-checking off.
             if (EmphRow[Row] >= Low(HighLiteStyle)) and (EmphRow[Row] <= High(HighLiteStyle)) then
               Font.Style:=HighLiteStyle[EmphRow[Row]];

           end
           else
           begin
             Font.Style:=[];
           end;

           // CJS 2015-05-05 - v7.0.14 - PPD - T2-119 - Extend Btrieve List Components to support Cell based colouring
           // Store the record address for the current row, so that the
           // ModifyCell procedure has access to it.
           CellDetails.RecAddress := PageKeys^[Row];
           CellDetails.Font       := Font;
           CellDetails.Contents   := Trim((Sender as TStringGrid).Cells[Col,Row]);

           if ( gdFocused in State ) or ( gdSelected in State ) then
           begin
             SetTextColor( Handle, ColorToRGB( ColAppear^[SGTagNo].HTextColor) );
             SetBkColor( Handle, ColorToRGB( ColAppear^[SGTagNo].HBkColor) );

              // CJS 2015-05-05 - v7.0.14 - PPD - T2-119 - Extend Btrieve List Components to support Cell based colouring
             CellDetails.TextColour := ColAppear^[SGTagNo].HTextColor;
             CellDetails.BackColour := ColAppear^[SGTagNo].HBkColor;
           end
           else
           Begin
             SetTextColor( Handle, ColorToRGB( OldFontColor ) );
             SetBkColor( Handle, ColorToRGB( (Sender As TStringGrid).Color) );

              // CJS 2015-05-05 - v7.0.14 - PPD - T2-119 - Extend Btrieve List Components to support Cell based colouring
             CellDetails.TextColour := OldFontColor;
             CellDetails.BackColour := (Sender as TStringGrid).Color;
           end;

           // CJS 2015-05-05 - v7.0.14 - PPD - T2-119 - Extend Btrieve List Components to support Cell based colouring
           // Allow ModifyCell to amend the display of this cell, passing it
           // the current display details
           // CJS 2015-05-29 - ABSEXCH-16442 - don't do this if the row is
           // selected -- use the default colours.
           if not(( gdFocused in State ) or ( gdSelected in State )) then
             ModifyCell((Sender as TStringGridEx).Position, Row, CellDetails);

           // Copy any changes back
           SetTextColor(Handle, ColorToRGB(CellDetails.TextColour));
           SetBkColor(Handle, ColorToRGB(CellDetails.BackColour));

           S := (Sender as TStringGrid).Cells[Col,Row];

           R := Rect;

           If (ColAppear^[SGTagNo].DispFormat=SGFloat) and (S<>'') then
           BEGIN
             SetTextAlign(Handle, TA_RIGHT); {Windows API function}

             If (TotDecPs<>0) then
               R.Right := R.Right - TextWidth(DecimalSeparator+ConstStr('0',ColAppear^[SGTagNo].NoDecPlaces)) - 4;

             IF Pos(DecimalSeparator, S) > 0 THEN
               S := Copy(S, 1, Pos(DecimalSeparator, S)-1);
             TextRect(R, R.Right, R.Top+2, S); {note R.Right, not R.Left}

             S := (Sender as TStringGrid).Cells[Col, Row];

             IF Pos(DecimalSeparator, S) > 0 THEN
               S := Copy(S, Pos(DecimalSeparator, S), 255)
             ELSE S := '';

             SetTextAlign(Handle, TA_LEFT);
             R.Left := R.Right;
             R.Right := Rect.Right;

             If (TotDecPs>0) and (S<>'') then
               TextRect(R, R.Left, R.Top+2, S);

           END
           else
           Begin
             TextRect(R, R.Left, R.Top+2, S); {note R.Right, not R.Left}
           end;

           SetBkColor( Handle, ColorToRGB( OldBrushColor ) );
           SetTextColor( Handle, ColorToRGB( OldFontColor ) );


         end; {With..}
       END;

procedure TMULCtrl.ButtonMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

Var
  PseudoK  :  Word;
  ElTime,
  NTime    :  Cardinal;
  Ok2Rep   :  Boolean;
  BtId     :  Integer;
  TheSBtn  :  TScrollButton;
  Interval : Integer;
  Msg: tagMSG;
  XPos, YPos: Integer;
begin
  ElTime := 0;
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.ButtonMouseDown';
  {$ENDIF}

  If (Not ListStillBusy) then
  Begin

    InListFind:=BOff;

    PseudoK:=VK_Up;

    BtId:=0;


    If (Sender is TScrollButton) then
    Begin
      TheSBtn:=TScrollButton(Sender);
      BtId:=TheSBtn.Tag;
    end
    else
      //theSBtn:=nil;
      EXIT; //CS: 27/10/2010


{$IFDEF ENTXP}

    If (Sender is TBitBtn) then
      With (Sender as TBitBtn) do
        BtId:=Tag;
{$ENDIF}

    Case BtId of
      1  :  PseudoK:=VK_Home;
      2  :  PseudoK:=VK_Prior;
      3  :  PseudoK:=VK_Up;
      4  :  PseudoK:=VK_Down;
      5  :  PseudoK:=VK_Next;
      6  :  PseudoK:=VK_End;
    end; {Case..}

    AutoRepeat1:=(Not (PseudoK In [VK_Home,VK_End]));

    Ok2Rep:=True;
    Interval := 150;

    Repeat

      If (Ok2Rep) then
      Begin
        MUListBox1KeyDown(Sender,PseudoK,[ssLeft]);
        ELTime:=GetTickCount;
        if (Interval > 30) then
          Interval := Interval - 10;
      end;

      NTime:=GetTickCount;

      Ok2Rep:=(Longint(NTime-ElTime)>Interval);

      if PeekMessage(Msg, 0, WM_MOUSEFIRST, WM_MOUSELAST,  PM_REMOVE) then
      begin
        if (Msg.message = WM_LBUTTONUP) then
        begin
          AutoRepeat1 := False;
        end
        else if (Msg.message = WM_MOUSEMOVE) then
        begin
          XPos := Lo(Msg.LParam);
          YPos := (Msg.LParam shr 16);
          if not((XPos >= 0) and (XPos < TheSBtn.ClientWidth) and
                 (YPos >= 0) and (YPos <= TheSBtn.ClientHeight)) then
            AutoRepeat1 := False;
        end;
      end;

      PeekMessage(Msg, 0, WM_KEYFIRST, WM_KEYLAST,  PM_REMOVE);

      If (Assigned(TheSBtn)) and AutoRepeat1 then
        AutoRepeat1:=((csLButtonDown in TheSBtn.ControlState) and TheSBtn.bMouseOver);

    Until (Not AutoRepeat1) or ((Not CanUp) and (BtID <4)) or ((Not CanDown) and (BtId>=4));

    AutoRepeat1:=False;

    If (Assigned(TheSBtn)) then
    With TheSBtn do
    If (Not Focused) then
    Begin
      If CanFocus then
        SetFocus;
    end;
  end;
end;

procedure TMULCtrl.ButtonMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  AutoRepeat1:=False;

end;


procedure TMULCtrl.MUListBox1Click(Sender: TObject);

Var
  CanD,CanU  :  Boolean;

begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.MUListBox1Click';
  {$ENDIF}

  {If (Not ListStillBusy(BOff)) then v4.32, do not check this here as it resets InListFind causing all sorts of problems}
  Begin
    CanD:=BOn; {v5.60 I think that unless I can restore the check for up and down when you are at the top and bottom of
                the list (disabled in v4.32.001 for a GFP in find, its better to assume you can go up and down after a click}
    CanU:=BOn;

    If (Sender is TStringGrid) then
      With (Sender as TStringGrid) do
      Begin

        Update_Select(Row,BOn);

        {* v4.30c, checks added on click so button status gets updated *}
        If (PageKeys^[MUListBoxes[0].Row]<>0) then
        Begin
          If (Row>0) and (Not CanU) then
          Begin
            CanU:=BOn;

          end
          else
            If (Row<ItemScrn) and (Not CanD) then
            Begin
              CanD:=BOn;

            end
            else
              If (Row=0) then
              Begin
                {CanU:=Check_Seek(BOff,0,BOn); *Removed v4.32.001 as cause of
                                                list GPF in find, when find mode on auto close
                If (ValidLine) then; {Restore record}

              end
              else
                If (Row=ItemScrn) then
                Begin
                  {CanD:=Check_Seek(BOn,Row,BOn);*Removed v4.32.001 as cause of
                                                list GPF in find, when find mode on auto close
                  If (ValidLine) then; {Restore record}

                end;

          If (CanD<>BitBtns[1].Enabled) or (CanU<>BitBtns[4].Enabled) then {v5, check made on actual button status, as candown was out of synch with btn.enabled}
          Begin
            CanUp:=CanU; CanDown:=CanD;
            SetButtnStat;

          end;
        end;

         Send_ListRecMsg(0,3,0,0);
      end;
  end;
end;

procedure TMULCtrl.MUListBoxSelectCell(Sender: TObject; Col, Row: Longint;
                                   var CanSelect: Boolean);

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.MUListBoxSelectCell';
  {$ENDIF}

  If (Sender is TStringGrid) then
  Begin

    If (LinkOtherDisp) and (PageKeys^[Row]<>0) then
    Begin
      RefreshLine(Row,BOff);
      Send_ListRecMsg(0,1,0,0);
    end;
  end;
end;

procedure TMULCtrl.Set_ButtonsVisible(State :  Boolean);

Var
  n  :  Byte;
Begin

  For n:=1 to TotBtns do
    BitBtns[n].Visible:=State;

  ButtonsVisible:=State;

end;

procedure TMULCtrl.MUListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

Var
  PsudeoK   :  Word;
  ListPoint :  TPoint;
  NoGo      :  Boolean;
  RClickRow :  Integer;
begin
  If (Not ListStillBusy) then
  Begin

    NoGo:=BOff;

    RClickRow:=0;

    InListFind:=BOff;

    If (ChooseXCol) then
      ReSetSelectCol(TStringGrid(Sender));

    If (Sender is TStringGrid) and (Not BeenDClick) then
      With (Sender as TStringGrid) do
      Begin

        If (ssLeft in Shift) then
        Begin
          Update_Select(Row,BOn);

          AutoRepeat1:=BOn;

          PsudeoK:=VK_Down;

          If (Not AlreadyMove) then
          Begin
            AlreadyMove:=BOn;

            With MUListBoxes[0] do
            Begin
              ListPoint.X:=1;
              ListPoint.Y:=1;
              ListPoint:=ClientToScreen(ListPoint);

              ScreenTop:=ListPoint.Y;
              ScreenLeft:=ListPoint.X;

              ScreenBot:=ScreenTop+Height;
            end;

            With MUListBoxes[MUTotCols] do
            Begin
              ListPoint.X:=1;
              ListPoint.Y:=1;
              ListPoint:=ClientToScreen(ListPoint);

              ScreenRight:=ListPoint.X+Width;
            end;



            Repeat

              GetCursorPos(ListPoint);

              Update_Select(Row,BOff);

              If (ListPoint.X>=ScreenLeft) and (ListPoint.X<=ScreenRight) then
              Begin
                NoGo:=BOff;

                If (ListPoint.Y>ScreenBot) then
                  PsudeoK:=VK_Down
                else
                  If (ListPoint.Y<ScreenTop) then
                    PsudeoK:=VK_Up
                  else
                    NoGo:=BOn;

                If (Not NoGo) then
                Begin

                  MUListBox1KeyDown(Sender,PsudeoK,Shift);
                end;
              end;

              Application.ProcessMessages;

            Until (Not AutoRepeat1) or (IRQSearch);

            AlreadyMove:=BOff;
          end;
        end {If Left button down}
        else
          If (ssRight In Shift) then {* Send message right button clicked *}
          Begin
            RClickRow:=Trunc(Y/DefaultRowHeight);

            If (RClickRow>ItemScrn) then
              RClickRow:=ItemScrn;

            If (RClickRow<0) then
              RClickRow:=0;

            Update_Select(RClickRow,BOn);


            ListPoint:=ClientToScreen(Point(X,Y));

            Send_ListRecMsg(0,2,ListPoint.X,ListPoint.Y);

            Intercept_ListClick(2,ListPoint.X,ListPoint.Y);

          end;

            {Set_ButtonsVisible(Not ButtonsVisible);}

      end {If Correct sender/With}
      else
        BeenDClick:=BOff;
  end;
end; {Proc..}


procedure TMULCtrl.MUListBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

begin
  If (Sender is TStringGrid) then
    With (Sender as TStringGrid) do
    Begin
      AutoRepeat1:=BOff;


    end;
end; {Proc..}


procedure TMULCtrl.MUListBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Var
  PsudeoK  :  Word;
  ElTime,
  NTime    :  LongInt;
  Ok2Rep   :  Boolean;
  TStr     :  Str255;
  ListPoint:  TPoint;

begin
  PsudeoK:=VK_Down;

  If (Sender is TStringGrid) and (AutoRepeat1) and (Not AlreadyMove) and (PageKeys^[MUListBox1.Row]<>0) then
    With (Sender as TStringGrid) do
    Begin
      {Update_Select(Row,BOn);}
      AlreadyMove:=BOn;

      Repeat

        GetCursorPos(ListPoint);

        If (ListPoint.X>=MUListBox1.Left) and
           (ListPoint.X<=MUListBoxes[MUTotCols].Left+MUListBoxes[MUTotCols].Width) and
           (ListPoint.Y>MUListBox1.Top+MUListBox1.Height) then
          MUListBox1KeyDown(Sender,PsudeoK,Shift);

        Application.ProcessMessages;

      Until (Not AutoRepeat1) or (IRQSearch);

      AlreadyMove:=Boff;

    end; {If Sender wrong..}
end; {Proc..}


procedure TMULCtrl.MUListBox1MouseKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

Begin

  MUListBox1KeyDown(Sender,Key,[SSLeft]);

  If (Sender is TScrollButton) then
    With Sender as TScrollButton do
    If (Not Focused) then
    Begin
      If CanFocus then
        SetFocus;

    end;
end;


procedure TMULCtrl.MUListBoxDblClick(Sender: TObject);

Var
  Shift       :  TShiftState;
  PsudeoKey   :  Word;


begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.MUListBoxDblClick';
  {$ENDIF}

  If (Not ListStillBusy) then
  Begin
    Shift:=[];
    PsudeoKey:=Vk_Return;

    BeenDClick:=BOn;

    If (Sender is TStringGrid) then
      With (Sender as TStringGrid) do
      Begin
        MUListBox1KeyDown(Sender,PsudeoKey,Shift);

        {* This flag necessary as Mouse doen seems to get called twice, one for each click? *}

        BeenDCLick:=BOn;
      end;
  end;
end;



procedure TMULCtrl.BtnPanelMouseDown(Sender: TObject;
                                     Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  PDirec  :  Boolean;
  SRow    :  Integer;

Begin
  With LButtonPanel do
  Begin
    PDirec:=(Y>(Height/2));

    SRow:=MUListBoxes[0].Row;
    If (PDirec) then
    Begin
      If (SRow=0) then
        SRow:=ItemScrn;
    end
    else
    Begin
      If (SRow=ItemScrn) then
        SRow:=0;
    end;

    If (ButtonsVisible) and (ItemCount>=ItemScrn) then
      PageUpDn(SRow,PDirec);
  end;
end;


{ == Procedure to Send Message to Get Record == }
{ == Codes in use ==}

{
 0  =  Double Click/ Enter. Get record highlighted
 1  =  Linked list, as highlight moves send message so that some
       other synchronised display is updated
 2  =  Right button clicked. Send message so that a pop up menu can be shown at the
       position of the click
 3 = Sent on on click event from the panels

 20,
 21 =  Send message during the display of a get extended operation which stops
       any resource saving routines from activating when the main form looses focus
       once the message is removed, the switch is re-instated.
 9999 = No records found, force calling routine to abort
}

Procedure TMULCtrl.Send_ListRecMsg(MMode     :  Byte;
                                   AddParam  :  Word;
                                   MX,MY     :  LongInt);


Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

  LocalStatus
           :  Integer;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.Send_ListRecMsg';
  {$ENDIF}

  LocalStatus:=Status;

  FillChar(Message1,Sizeof(Message1),0);

  {* Get focused record before sending message *}

  {$B-}

  If (Not (AddParam In [1,20,21,3 ])) and (ValidLine) then
    RefreshLine(MUListBoxes[0].Row,BOff);

  {$B+}

  With Message1 do
  Begin
    MSg:=WM_ListGetRec;
    LParamLo:=MX;
    LParamHi:=MY;
    WParam:=AddParam;

    MessResult:=SendMEssage(MessHandle,Msg,WParam,LParam);
  end;

  Status:=LocalStatus;

  Intercept_ListCLick(AddParam,MX,MY);
end; {Proc..}


{ ============= Generic Virtual procedure to modify renumbered record ========== }

Procedure TMULCtrl.SetMoveData(IVal  :  LongInt);

Begin

end;

{ ============ Procedure to Insert/Delete List Lines =========== }

Procedure TMULCtrl.MoveEmUp(KeyChk,
                            KeyS,
                            KeyLimit:  Str255;
                            IncBy   :  LongInt);


Var
  FoundOk,
  Locked       :  Boolean;

  TmpKPath,
  TmpStat      :  Integer;

  LAddr,
  MarkerAddr,
  LMarkerAddr,
  MarkerCount,
  TmpRecAddr   :  LongInt;

  MarkerKey    :  Str255;





Begin

  SetCursor(BOn);

  FoundOk:=BOff; Locked:=BOff;

  KeyLimit:=Strip('R',[#0],KeyLimit);

  TmpKPath:=GetPosKey;

  {$IFDEF EXSQL}
  if UsingSQL then PrepareSQLCall;
  {$ENDIF}
  TmpStat:=Presrv_BTPos(ScanFileNum,TmpKPath,F[ScanFileNum],TmpRecAddr,BOff,BOff);

  MarkerKey:=KeyLimit;  MarkerAddr:=0;  MarkerCount:=0;  LMarkerAddr:=0;

  {* We should not be going past this record twice *}

  {$IFDEF EXSQL}
  if UsingSQL then PrepareSQLCall;
  {$ENDIF}
  Status:=Find_Rec(B_GetGEq,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,Keypath,MarkerKey);

  If (CheckKey(KeyChk,MarkerKey,Length(KeyChk),BOn)) then
  Begin
    {$IFDEF EXSQL}
    if UsingSQL then PrepareSQLCall;
    {$ENDIF}
    Status:=GetPos(F[ScanFileNum],ScanFileNum,MarkerAddr);
  end;

  {$IFDEF EXSQL}
  if UsingSQL then PrepareSQLCall;
  {$ENDIF}
  Status:=Find_Rec(B_GetLessEq,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,Keypath,KeyS);

  {$IFDEF EXSQL}
  if UsingSQL then PrepareSQLCall;
  {$ENDIF}
  Status:=GetPos(F[ScanFileNum],ScanFileNum,LMarkerAddr);

  While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) and (KeyS>=KeyLimit) and (MarkerCount<3) do
  Begin
    FoundOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,Locked,LAddr);

    MarkerCount:=MarkerCount+(Ord((MarkerAddr<>0) and (MarkerAddr=LAddr)));

    If (FoundOk) and (Locked) and (MarkerCount<3) then
    Begin

      SetMoveData(IncBy);

      Status:=Put_Rec(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath);

      Report_BError(ScanFileNum,Status);

      Status:=UnLockMultiSing(F[ScanFileNum],ScanFileNum,LAddr);
    end;

    MarkerCount:=MarkerCount+Ord(LMarkerAddr=LAddr);

    Status:=Find_Rec(B_GetPrev,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,Keypath,KeyS);
  end; {While..}

  {$IFDEF EXSQL}
  if UsingSQL then PrepareSQLCall;
  {$ENDIF}
  TmpStat:=Presrv_BTPos(ScanFileNum,TmpKPath,F[ScanFileNum],TmpRecAddr,BOn,BOff);

  SetCursor(BOff);

end; {Loop..}



Procedure TMulCtrl.Find_OnList(KeyChk     :  Str255;
                               SearchNdx  :  Integer);

Var
  KeyS    :  Str255;

  CurrPath:  Integer;

  RecAddr :  LongInt;

Begin


  CurrPath:=KeyPath;

  KeyPath:=SearchNdx;

  KeyS:=KeyChk;

  GetMatch(B_GetGEq,B_GetNext,KeyS);

  If (StatusOk) and (CheckKEy(KeyChk,KeyS,Length(KeyChk),BOff)) then
  Begin
    {$IFDEF EXSQL}
    if UsingSQL then PrepareSQLCall;
    {$ENDIF}
    Status:=GetPos(F[ScanFileNum],ScanFileNum,RecAddr);

    PageKeys^[0]:=RecAddr;
    KeyAry^[0]:=SetCheckKey;

    PageUpDn(0,BOn);

    RefreshLine(0,BOn);

  end
  else {* Warn can't find.. *}
    KeyPath:=CurrPath;

end;

{
  Find_OnActualList is only used if a SortView is active. When we do a
  find, it has to be against the actual file that is being viewed, rather than
  the Sort View temporary file.
}
function TMulCtrl.Find_OnActualList(FNum: Integer; Key: Str255; Ndx: Integer): Boolean;
var
  TempKeyPath: Integer;
  TempFNum: Integer;
  TempKey: Str255;
  RecAddr: LongInt;
begin
  // Store the details of the temporary file.
  TempKeyPath := KeyPath;
  TempFNum    := ScanFileNum;

  // Point the details at the actual file.
  ScanFileNum := FNum;
  KeyPath     := Ndx;

  // Switch off the Sort View, and do the search.
  FSortView.Enabled := False;
  TempKey := Key;
  GetMatch(B_GetGEq, B_GetNext, TempKey);
  Result := (StatusOk and (CheckKey(Key, TempKey, Length(Key), BOff)));

  // Restore the details of the temporary file.
  FSortView.Enabled := True;
  KeyPath       := TempKeyPath;
  ScanFileNum   := TempFNum;

  // If the search succeeded, locate the record in the temporary file which
  // matches the record in the actual file, if any. Return False if this
  // record cannot be found.
  if Result then
  begin
    Result := (FSortView.SyncTemp = 0);
    if Result then
    begin
      Status := GetPos(F[ScanFileNum], ScanFileNum, RecAddr);

      PageKeys^[0] := RecAddr;
      KeyAry^[0]   := SetCheckKey;

      PageUpDn(0, BOn);
      RefreshLine(0, BOn);
    end;
  end;
end;



Procedure TMULCtrl.ReSizeOneCol(Start  :  Integer);

Var
  LOrder   :  Integer;

Begin

  With VisiList do
  Begin
    VisiRec:=List[Start];
    LOrder:=VisiRec^.ColOrder;
  end;

  VisiList.SetCoord(Start,MUListBoxes[LOrder]);


end; {Proc..}


procedure TMULCtrl.SetListFocus;

Var
  LOrder   :  Integer;

Begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.SetListFocus';
  {$ENDIF}

  With VisiList do
  Begin
    VisiRec:=List[0];

    If (Assigned(MUListBoxes[VisiRec^.ColOrder])) then
      With MUListBoxes[VisiRec^.ColOrder] do
      Begin
        If (CanFocus) then
          SetFocus;
      end;
  end;


end; {Proc..}



Procedure TMULCtrl.InitVarCol(Start  :  Integer);

Var
  LOrder   :  Integer;

Begin

  With VisiList do
  Begin
    LOrder:=FindxColOrder(Start);

    If (LOrder<>-1) then
      SetCoord(LOrder,MUListBoxes[Start])
    else
      MUListBoxes[Start].Visible:=BOff;
  end;


end; {Proc..}


Procedure TMULCtrl.ApplyReSizeAllCols(Start,BarOfSet  :  Integer;
                                      UseOfSet        :  Boolean);

Var
  n,
  NewLeft  :  Integer;

Begin
  NewLeft := 0;
  With VisiList do
  If (Start<Count) then
  Begin
    VisiRec:=List[Start];

    try

      If (VisiRec<>nil) then
        With VisiRec^ do
        Begin
          NewLeft:=(ThisObj as TSBSPanel).Left;

          If (Not HidePanel) then
          Begin

            NewLeft:=NewLeft+(ThisObj as TSBSPanel).Width+SpaceGap;

            If (Not GotPanel) then
            Begin
              With (PanelObj as TSBSPanel) do
                Width:=(ThisObj as TSBSPanel).Width;{+2;}
            end
            else
            Begin
              With (LabelObj as TSBSPanel) do
              Begin
                n:=Width;

                Width:=(ThisObj as TSBSPanel).Width-3;

                n:=Width;
              end;
            end;

            ReSizeOneCol(Start);
          end; {If Panel hidden}

        end;

      For n:=Succ(Start) to Pred(Count) do
      Begin

        VisiRec:=List[n];

        try

          If (VisiRec<>Nil) then
            With VisiRec^ do
            If (Not HidePanel) then
            Begin
              With (LabelObj as TSBSPanel) do
                If (UseOfSet) then
                  Left:=NewLeft
                else
                  Left:=NewLeft+BarOfSet;

              With (PanelObj as TSBSPanel) do
              Begin
                Left:=NewLeft-(BarOfSet*Ord(UseOfSet));
                NewLeft:=NewLeft+Width+SpaceGap;
              end;

              ReSizeOneCol(n);

            end; {Width..}

        except;

        end;
      end; {Loop..}

    except

    end; {Except..}
  end; {If not moving last one..}

end; {Proc..}

Procedure TMULCtrl.ReSizeAllCols(Start,BarOfSet  :  Integer);

Begin
  ApplyReSizeAllCols(Start,BarOfSet,BOff);
end;


Procedure TMULCtrl.HideAllCols(SetHide  :  Boolean);

Var
  n  :  Integer;

Begin
  For n:=0 to MUTotCols do
  If (MUListBoxes[n]<>Nil) then
  Begin
    MUListBoxes[n].Visible:=Not SetHide;
  end;

end;


Procedure TMULCtrl.RefreshAllCols;

Var
  n,
  NewLeft,
  TmpStat
        :  Integer;

  TmpRecAddr
        :  LongInt;

Begin
  NewLeft := 0;
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.RefreshAllCols';
  {$ENDIF}

  With VisiList do
  If (Count>0) then
  Begin

    VisiRec:=List[0];

    If (VisiRec<>nil) then
    With VisiRec^ do
    Begin

      NewLeft:=(PanelObj as TSBSPanel).Height;

      ReSizeOneCol(0);

      With MUListBox1 do
      Begin
        { CJS 2012-06-22: ABSEXCH-11527 - Btrieve list font size }
        THeight := Height;
        DefaultRowHeight := abs(Font.Height) + 5;
        TIHeight := DefaultRowHeight;
        If (TIHeight<>0) then
          RowCount:=Trunc((NewLeft-2)/TIHeight)
        else
          RowCount:=0;

        ItemScrn:=Pred(RowCount);
      end;

      { CJS 2012-06-22: ABSEXCH-11527 - Btrieve list font size }
      MUListBoxes[0].DefaultRowHeight := MUListBox1.DefaultRowHeight;
      MUListBoxes[0].RowCount:=MUListBox1.RowCount;

    end;

    For n:=1 to Pred(Count) do
    Begin

      VisiRec:=List[n];

      try

        If (VisiRec<>Nil) then
          With VisiRec^ do
          Begin

            With (PanelObj as TSBSPanel) do
            Begin
              Height:=NewLeft;
            end;

            ReSizeOneCol(n);

            { CJS 2012-06-22: ABSEXCH-11527 - Btrieve list font size }
            MUListBoxes[n].DefaultRowHeight := MUListBox1.DefaultRowHeight;
            MUListBoxes[n].RowCount:=MUListBox1.RowCount;

          end; {Width..}

      except;

      end;
    end; {Loop..}

    { CJS 2012-08-23 - ABSEXCH-13335 - list displays wrong data after font-size change }
    If (ScanFileNum<>0) and (PageKeys^[0]<>0) and {* Check for valid list, + preserv pos otherwise global record gets wiped out if list is maximized *}
       (PageKeys^[MuListBoxes[0].Row] <> 0) then  { If we are off the bottom of the list, no need to do this } 
    Begin

      {$IFDEF EXSQL}
      if UsingSQL then PrepareSQLCall;
      {$ENDIF}
      TmpStat:=Presrv_BTPos(ScanFileNum,KeyPath,F[ScanFileNum],TmpRecAddr,BOff,BOff);

      PageUpDn(0,BOn);

      {$IFDEF EXSQL}
      if UsingSQL then PrepareSQLCall;
      {$ENDIF}
      TmpStat:=Presrv_BTPos(ScanFileNum,KeyPath,F[ScanFileNum],TmpRecAddr,BOn,BOn);

    end;

  end; {If not moving last one..}

end; {Proc..}


Procedure TMULCtrl.ReSizeMoveCol(Start,SBOffSet  :  Integer);

Var
  IncX,
  n,
  NewLeft  :  Integer;

Begin
  IncX := 0;
  With VisiList do
  If (Start<Count) then
  Begin
    VisiRec:=List[Start];

    If (VisiRec<>nil) then
    With VisiRec^ do
    Begin
      IncX:=(PanelObj as TSBSPanel).Left;


      If (Not HidePanel) then
      Begin
        IncX:=IncX+(PanelObj as TSBSPanel).Width+SpaceGap;

        NewLeft:=(PanelObj as TSBSPanel).Left+SBOffSet;

        With (LabelObj as TSBSPanel) do
          Left:=NewLeft;

        ReSizeOneCol(Start);
      end; {If Panel hidden..}
    end;

    For n:=Succ(Start) to Pred(Count) do
    Begin

      VisiRec:=List[n];

      try

        If (VisiRec<>Nil) then
          With VisiRec^ do
          If (Not HidePanel) then
          Begin
            With (LabelObj as TSBSPanel) do
              Left:=IncX+SBOffset;

            With (PanelObj as TSBSPanel) do
            Begin
              Left:=IncX;

              IncX:=IncX+Width+SpaceGap;
            end;

            ReSizeOneCol(n);

          end; {Width..}

      except;

      end;
    end; {Loop..}

  end; {If not moving last one..}

end; {Proc..}




Procedure TMULCtrl.MoveListCol(FromCol,ToCol,SBOffSet  :  Integer);

Var
  OrigPanel  :  TSBSPanel;

  TmpLeft    :  Integer;

  TmpMUL     :  PMULBox;


Begin
  With VisiList do
  Begin
    VisiRec:=List[0];

    With VisiRec^ do
      OrigPanel:=(PanelObj as TSBSPanel);

    TmpLeft:=OrigPanel.Left;


    Move(FromCol,ToCol);

    VisiRec:=List[0];

    With VisiRec^ do
      OrigPanel:=(PanelObj as TSBSPanel);

    OrigPanel.Left:=TmpLeft;



    ResizeMoveCol(0,SBOffSet);

  end;
end;

Procedure TMULCtrl.FinishColMove(SBOffSet  :  Integer;
                                 Resized   :  Boolean);


Begin
  With VisiList do
  Begin

    If (Resized) then
      SetHedPanel(SBOffSet);

    If (MovingLab) then
    Begin
      FinishMove;

      If (MoveLab<>ThisLab) then
      Begin
        MoveListCol(ThisLab,MoveLab,SBOffSet);

        If (ChooseXCol) then {* Refresh it again *}
          SetSelectCol(SelectCol^.CurrentCol);
      end;

    end;
  end;
end;



Procedure TMULCtrl.ReColorCol(NewFont  :  TFont;
                              NewColor :  TColor;
                              UpLabel  :  Boolean);


Var
  n  :  Integer;

Begin
  With VisiList do
  If (Count>=0) then
  Begin

    For n:=0 to Pred(Count) do
    Begin

      VisiRec:=List[n];

      try

        If (VisiRec<>Nil) then
          With VisiRec^ do
          Begin

            If (UpLabel) then
            With (LabelObj as TSBSPanel) do
            Begin
              Color:=NewColor;
              Font:=NewFont;
            end
            else
            With (PanelObj as TSBSPanel) do
            Begin
              Color:=NewColor;
              Font:=NewFont;

              ReSizeOneCol(n);
            end;
          end; {Width..}

      except;

      end;
    end; {Loop..}

  end;

  { CJS 2012-08-08 - ABSEXCH-13263 - Row height not preserved after font size changed }
  if not UpLabel and Assigned(NewFont) and Assigned(MUListBox1) then
  begin
    MUListBox1.Font := NewFont;
    RefreshAllCols;
  end;

end; {Proc..}


Procedure TMULCtrl.ReColorBar(NewFont  :  TFont;
                              NewColor :  TColor);


Var
  n  :  Integer;

Begin
  For n:=0 to MUTotCols do
  With ColAppear^[n] do
  Begin
    HBkColor:=NewColor;
    HTextColor:=NewFont.Color;
  end;

  If (PageKeys^[MUListBox1.Row]=0) then {* Empty line!}
    Update_Select(0,BOff)
  else
    Set_Row(MUListBox1.Row);

  {Update_Select(MUListBox1.Row,BOff);}

end; {Proc..}


Procedure TMULCtrl.ReAssignCols;

Var
  n  :  Integer;


Begin
  For n:=0 to MUTotCols do
  Begin
    InitVarCol(n);
    MUListBoxes[n].Parent:=VisiList.IdPanel(0,BOff).Parent;
    { CJS 2012-08-08 - ABSEXCH-13263 - Set the row height from the source
                                       control. }
    MUListBoxes[n].DefaultRowHeight := MUListBox1.DefaultRowHeight;
  end;
end;



Procedure TMULCtrl.HideCols(HideMode  :  Boolean);

Var
  n  :  Integer;


Begin
  For n:=0 to MUTotCols do
  Begin
    If (HidEMode) then
      MUListBoxes[n].Parent:=nil
    else
      MUListBoxes[n].Parent:=VisiList.IdPanel(0,BOff).Parent;
  end;
end;


Procedure TMULCtrl.Intercept_ListClick(Mode      : SmallInt;
                                       MX,MY     :  LongInt);
Begin


end;

procedure TMULCtrl.SetUseVariant(const Value: Boolean);
begin
  if (Value = True) and (SQLCacheID <> 0) then
    raise Exception.Create('UseVariant and Prefilled Cache are mutually ' +
                           'exclusive, but the application has attempted ' +
                           'to set UseVariant when Prefilled Cache is active.');
  FUseVariant := Value;
end;

procedure TMULCtrl.PrepareSQLCall;
var
  RecAddr: LongInt;
begin
  {$IFDEF EXSQL}
  if (UseVariant) then
    UseVariantForNextCall(F[ScanFileNum])
  else if (SQLCacheID > 0) then
  begin
(*
    if (Now > FSQLCacheExpiryTime) then
    begin
      { Store the current position }
      UseCustomPrefillCache(SQLCacheID);
      Status := GetPos(F[ScanFileNum], ScanFileNum, RecAddr);

      { Rebuild the cache }
      DropCustomPrefillCache(FSQLCacheID);
      CreateCustomPrefillCache(SetDrive + Filenames[ScanFileNum], FSQLWhereClause, FSQLColumns, FSQLCacheID);

      { Restore the position }
      UseCustomPrefillCache(SQLCacheID);
      SetDataRecOfs(ScanFileNum, RecAddr);
      Status:=GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,0);

      { Reset the expiry time }
      FSQLCacheExpiryTime := Now + (SQLCacheTimeOut * 1000);
    end;
*)
    UseCustomPrefillCache(SQLCacheID);
  end;
  {$ENDIF}
end;

procedure TMULCtrl.RefreshCache;
var
  Status: Integer;
  RecAddr: LongInt;
begin
  { Store the current position }
  RecAddr := 0;
  UseCustomPrefillCache(FSQLCacheID);
  Status := GetPos(F[ScanFileNum], ScanFileNum, RecAddr);
  if (Status <> 0) then
    raise Exception.Create('TMULCtrl.RefreshCache: Failed to get record position, error #' + IntToStr(Status));

  { Rebuild the cache }
  DropCustomPrefillCache(FSQLCacheID);
  Status := CreateCustomPrefillCache(SetDrive + Filenames[ScanFileNum], FSQLWhereClause, FSQLColumns, FSQLCacheID);
  if (Status <> 0) then
    raise Exception.Create('TMULCtrl.RefreshCache: Failed to re-create cache, error #' + IntToStr(Status));

  { Restore the position }
  UseCustomPrefillCache(SQLCacheID);
  Status := Find_Rec(B_GetFirst, F[ScanFileNum], ScanFileNum, RecPtr[ScanFileNum]^, KeyPath, ListKey);
  if (Status <> 0) then
    raise Exception.Create('TMULCtrl.RefreshCache: Failed to find the first record, error #' + IntToStr(Status));

  // MH 08/09/2008: Modified to check whetther address is set
  If (RecAddr <> 0) Then
  Begin
    UseCustomPrefillCache(SQLCacheID);
    SetDataRecOfs(ScanFileNum, RecAddr);
    Status := GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,0);
    if (Status <> 0) then
      raise Exception.Create('TMULCtrl.RefreshCache: Failed to reposition record pointer, error #' + IntToStr(Status));
  End; // If (RecAddr <> 0)
end;

function TMULCtrl.GetSortViewEnabled: Boolean;
begin
  {$IFDEF MADEXCEPT}
    // MH 27/03/2013 v7.0.3 ABSEXCH-14144: Added additional logging to identify list classes in MadExcept logs
    If MadExceptListLogging Then
      MadExceptSupport.MadExceptLoggingString := ClassName + '.GetSortViewEnabled';
  {$ENDIF}

  if (FSortView <> nil) then
    Result := FSortView.Enabled or FSortView.IsBuildingFile
  else
    Result := False;
end;

procedure TMULCtrl.SetSortView(const Value: TBaseSortView);
begin
  FSortView := Value;
  { CJS - 2013-08-27 - ABSEXCH-14558 - Daybook SortViews }
  if (FSortView <> nil) then
  begin
    FSortView.OnFilter := PassFilter;
    FSortView.OnSetFilter := SetFilter;
    FSortView.HostPanel := Owner as TWinControl;
  end;
end;

function TMULCtrl.GetSortView: TBaseSortView;
begin
  Result := FSortView;
end;

{ TStringGridEx }
//PR:
procedure TStringGridEx.WMCaptureChanged(var Message: TMessage);
begin
  PostMessage(Handle, WM_LBUTTONUP, 0, 0);
end;

//PR: 07/10/2011 Added SetEndKey method to allow descendants to override (ABSEXCH-11736)
procedure TMULCtrl.SetEndKey(var KeyS : Str255);
begin
   If (KeyRef[Length(KeyRef)]<>NdxWeight) then
     KeyS[Length(KeyS)]:=Succ(KeyS[Length(KeyS)])
   else
     KeyS:=Copy(KeyRef,1,KeyLen);
end;

function TMULCtrl.SelectedRowIsValid: Boolean;
begin
  Result := (PageKeys^[MUListBoxes[0].Row] <> 0);
end;

//-------------------------------------------------------------------------

// MH 26/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
Procedure TMULCtrl.ExportList (ExportIntf : IExportListData; Const CommandID : Integer; Const ProgressHWnd : HWnd);
Var
  KeyS : Str255;
  I    : Integer;

  //-----------------------------------

  Procedure LoadRow (Const RecordAddress : LongInt);
  Var
    lStatus : Integer;
  Begin // LoadRow
    SetDataRecOfs(ScanFileNum, RecordAddress);

    if UsingSQL then
      PrepareSQLCall;

    lStatus := GetDirect(F[ScanFileNum], ScanFileNum, RecPtr[ScanFileNum]^, KeyPath, 0);

    if SortViewEnabled then
      FSortView.SyncRecord;
  End; // LoadRow

  //-----------------------------------

  Procedure ExportColumnHeaders (ExportIntf : IExportListData);
  Var
    ColPanel : TSBSPanel;
    I : Integer;
  Begin // ExportColumnHeaders
    // Extract Column Titles in Display Order
    For I := 0 To VisiList.Count - 1 Do
    Begin
      // Calling IdPanel causes the VisiRec to be populated so we can access ColOrder
      ColPanel := VisiList.IdPanel(I, True);
      If Assigned(ColPanel) Then
        // Check the column isn't hidden, e.g. the Description column on the Sales daybook
        If ColPanel.Visible Then
          {$IFDEF MADEXCEPT}
          Try
          {$ENDIF}
            // Trim the caption as some captions appear to have leading spaces - poor man's column centering??? - e.g. Status on Sales Main Dbk
            ExportIntf.AddColumnTitle (Trim(ColPanel.Caption), ColAppear^[VisiList.VisiRec^.ColOrder].ExportMetadata);
          {$IFDEF MADEXCEPT}
          Except
            On E:Exception Do
            Begin
              MadExceptSupport.MadExceptLoggingString := 'AddColumnData(ColumnData=''' + Trim(OutLine(VisiList.VisiRec.ColOrder)) + ''', MetaData=''' + ColAppear[VisiList.VisiRec^.ColOrder].ExportMetadata + ''')';
              Raise;
            End; // On E:Exception
          End; // Try..Except
          {$ENDIF}
    End; // For I
    ExportIntf.NewRow;
  End; // ExportColumnHeaders

  //-----------------------------------

  Procedure ExportRow (ExportIntf : IExportListData);
  Var
    // MH 15/05/2018 ABSEXCH-20502: Extract the column values in design-time order as some columns calc
    // values for later columns, e.g. Value column on SOR Daybook calculates Cost column
    ColValues : Array of String;
    ColPanel : TSBSPanel;
    I : Integer;
    // MH 16/05/2018 ABSEXCH-20519: Call CheckRowEmph as some lists also calculate row values in there!
    sEmphasis : String;
    RowEmph : Byte;
  Begin // ExportRow
    // MH 15/05/2018 ABSEXCH-20502: Extract the column values in design-time order as some columns calc
    // values for later columns, e.g. Value column on SOR Daybook calculates Cost column
    SetLength(ColValues, VisiList.Count);
    Try
      // MH 16/05/2018 ABSEXCH-20519: Call CheckRowEmph as some lists also calculate row values in there!
      sEmphasis := '';
      RowEmph := CheckRowEmph;
      If (RowEmph > 0) Then
      Begin
        If (fsBold In HighLiteStyle[RowEmph]) Then
          sEmphasis := sEmphasis + emtBold;
        If (fsUnderline In HighLiteStyle[RowEmph]) Then
          sEmphasis := sEmphasis + emtUnderline;
        If (fsItalic In HighLiteStyle[RowEmph]) Then
          sEmphasis := sEmphasis + emtItalic;
      End; // If (RowEmph > 0)

      // Extract the column values in design-time order and store in the array
      For I := 0 To VisiList.Count - 1 Do
        ColValues[I] := Trim(Outline(I));

      // Export the column values in display order
      For I := 0 To VisiList.Count - 1 Do
      Begin
        // Calling IdPanel causes the VisiRec to be populated so we can access ColOrder
        ColPanel := VisiList.IdPanel(I, True);
        If Assigned(ColPanel) Then
          // Check the column isn't hidden, e.g. the Description column on the Sales daybook
          If ColPanel.Visible Then
            {$IFDEF MADEXCEPT}
            Try
            {$ENDIF}
              // MH 15/05/2018 ABSEXCH-20502: Extract the column values in design-time order as some columns calc
              // values for later columns, e.g. Value column on SOR Daybook calculates Cost column
              ExportIntf.AddColumnData(Trim(ColValues[VisiList.VisiRec.ColOrder]), ColAppear[VisiList.VisiRec^.ColOrder].ExportMetadata + sEmphasis);
            {$IFDEF MADEXCEPT}
            Except
              On E:Exception Do
              Begin
                MadExceptSupport.MadExceptLoggingString := 'AddColumnData(ColumnData=''' + Trim(OutLine(VisiList.VisiRec.ColOrder)) + ''', MetaData=''' + ColAppear[VisiList.VisiRec^.ColOrder].ExportMetadata + ''')';
                Raise;
              End; // On E:Exception
            End; // Try..Except
            {$ENDIF}
      End; // For I
      ExportIntf.NewRow;
    Finally
      ColValues := NIL;
    End; // Try..Finally

    SendMessage (ProgressHWnd, WM_ListExportProgress, 0, 0);
  End; // ExportRow

  //-----------------------------------

Begin // ExportList
  // MH 01/03/2018 2018-R2 ABSEXCH-19172: Added flag to disable popup window which hides the List Export progress dialog
  RunningListExport := True;
  Try
    // Extract the column headers
    ExportColumnHeaders (ExportIntf);

    // Extract the data
    If (CommandID = ecIDCurrentRow) Then
    Begin
      // Reload the current row and export it
      If (PageKeys^[MUListBoxes[0].Row] <> 0) Then
      Begin
        LoadRow (PageKeys^[MUListBoxes[0].Row]);
        ExportRow (ExportIntf);
      End; // If (PageKeys^[MUListBoxes[0].Row] <> 0)
    End // If (CommandID = ecIDCurrentRow)
    Else If (CommandID = ecIDCurrentPage) Then
    Begin
      // Run through the stored Record Positions/Position IDs and reload the records
      // so we can export them
      //For I := 0 To ItemScrn Do

      // MH 16/05/2018 ABSEXCH-20520: Changed loop to look at the onscreen grid to determine which rows to
      //                              export as sizing bugs mean that you can get extra rows in the grid
      //                              that aren't shown
//      For I := MUListBoxes[0].TopRow To (MUListBoxes[0].TopRow + MUListBoxes[0].VisibleRowCount - 1) Do
//      Begin
//         Copied from PageUpDn
//        If (PageKeys^[I] <> 0) Then
//        Begin
//          LoadRow (PageKeys^[I]);
//          ExportRow (ExportIntf);
//        End; // If (PageKeys^[I] <> 0)
//      End; // For I

      // MH 17/05/2018 ABSEXCH-20520: Discovered that MUListBoxes[0].VisibleRowCount sometimes lies, it seems to
      //                              tell you how many rows are COMPLETELY visible, so you may have a row shown
      //                              on screen where 2 pixels at the bottom of the row aren't visible, so
      //                              VisibleRowCount doesn't include it, but the user can see the row.
      //                              Through a process of trial and error I have discovered that the data in
      //                              PageKeys is correct, so if we use TopRow to determine which is the first row
      //                              shown we can use PageKeys to identify the rows - the last row data always
      //                              seems to be correct.
      I := MUListBoxes[0].TopRow;
      While (PageKeys^[I] <> 0) Do
      Begin
        LoadRow (PageKeys^[I]);
        ExportRow (ExportIntf);

        I := I + 1;
      End; // While (PageKeys^[I] <> 0)
    End // If (CommandID = ecIDCurrentPage)
    Else If (CommandID = ecIDEntireList) Then
    Begin
      // Run through the file working out what would be in the list - obeys any currently loaded Sort View
      If (StartLess) then
        KeyS:=ListKey
      else
        KeyS:=KeyRef;

      GetMatch(B_GetGEq,B_GetNext,KeyS);
      While LineOk(KeyS) Do
      Begin
        // Export to .xlsx
        ExportRow (ExportIntf);

        // Get next list row
        GetMatch(B_GetNext, B_GetNext, KeyS);
      End; // While LineOk(KeyS)
    End; // If (CommandID = ecIDEntireList)
  Finally
    RunningListExport := False;
  End; // Try..Finally
End; // ExportList

//-------------------------------------------------------------------------


end.

