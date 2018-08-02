unit oJobAnal;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     oBtrieve, GlobVar, VarConst, VarCnst3, MiscFunc,
     BtrvU2, ExBTTH1U, GlobList;

type
  TJobAnalysis = class(TBtrieveFunctions, IJobAnalysis, IJobAnalysis2, IJobAnalysis3, IBrowseInfo)
  private
    FJobAnalysisRec : TBatchJobAnalRec;

    FIntfType  : TInterfaceMode;

    FToolkit : TObject;

  protected
    //IJobAnalysis
    function  Get_anCode: WideString; safecall;
    procedure Set_anCode(const Value: WideString); safecall;
    function  Get_anDescription: WideString; safecall;
    procedure Set_anDescription(const Value: WideString); safecall;
    function  Get_anType: TAnalysisType; safecall;
    procedure Set_anType(Value: TAnalysisType); safecall;
    function  Get_anCategory: TAnalysisCategory; safecall;
    procedure Set_anCategory(Value: TAnalysisCategory); safecall;
    function  Get_anWIPGL: Integer; safecall;
    procedure Set_anWIPGL(Value: Integer); safecall;
    function  Get_anPandLGL: Integer; safecall;
    procedure Set_anPandLGL(Value: Integer); safecall;
    function  Get_anLineType: TTransactionLineType; safecall;
    procedure Set_anLineType(Value: TTransactionLineType); safecall;

    function  Get_anTypeString: WideString; safecall;
    function  Get_anCategoryString: WideString; safecall;
    function  Get_anLineTypeString: WideString; safecall;


    function  Get_Index: TJobAnalysisIndex; safecall;
    procedure Set_Index(Value: TJobAnalysisIndex); safecall;
    function  Clone: IJobAnalysis; safecall;
    function BuildCodeIndex(const Code : WideString) : WideString; safecall;
    function BuildDescriptionIndex(const Description : WideString) : WideString; safecall;

    function Update: IJobAnalysis2; safecall;
    function Add: IJobAnalysis2; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;

    function Get_anCISTaxRate: TCISTaxType; safecall;
    procedure Set_anCISTaxRate(Value : TCISTaxType); safecall;
    function Get_anUplift: Double; safecall;
    procedure Set_anUplift(Value: Double); safecall;
    function Get_anUpliftGL: Integer; safecall;
    procedure Set_anUpliftGL(Value: Integer); safecall;




    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    //Local methods
    Function  AuthoriseFunction (Const FuncNo     : Byte;
                                 Const MethodName : String;
                                 Const AccessType : Byte = 0) : Boolean; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    procedure InitObjects;
    procedure CopyDataRecord; override;
    Procedure LoadDetails (Const JADets : TBatchJobAnalRec; Const LockPos : LongInt);
    procedure InitNewRecord;

    function Get_anDeductionBase: TJobDeductionBaseType; safecall;
    procedure Set_anDeductionBase(Value: TJobDeductionBaseType); safecall;
    function Get_anCalcBeforeRetention: WordBool; safecall;
    procedure Set_anCalcBeforeRetention(Value: WordBool); safecall;
    function Get_anDeduction: Double; safecall;
    procedure Set_anDeduction(Value: Double); safecall;
    function Get_anApplyDeduction: TDeductionApplyToType; safecall;
    procedure Set_anApplyDeduction(Value: TDeductionApplyToType); safecall;
    function Get_anRetentionType: TAppsInterimType; safecall;
    procedure Set_anRetentionType(Value: TAppsInterimType); safecall;
    function Get_anRetentionValue: Double; safecall;
    procedure Set_anRetentionValue(Value: Double); safecall;
    function Get_anRetentionExpiryType: TRetentionExpiryType; safecall;
    procedure Set_anRetentionExpiryType(Value: TRetentionExpiryType); safecall;
    function Get_anRetentionExpiryInterval: Integer; safecall;
    procedure Set_anRetentionExpiryInterval(Value: Integer); safecall;
    function Get_anPreserveRetention: WordBool; safecall;
    procedure Set_anPreserveRetention(Value: WordBool); safecall;
    function Get_anCalcDeductionAs: TDeductionType; safecall;
    procedure Set_anCalcDeductionAs(Value: TDeductionType); safecall;
    function Get_anPayrollCode: Widestring; safecall;
    procedure Set_anPayrollCode(const Value: Widestring); safecall;
    function Get_anRevenueType: TRevenueType; safecall;
    procedure Set_anRevenueType(Value: TRevenueType); safecall;

  public
    Constructor Create(Const IType     : TInterfaceMode;
                       Const Toolkit   : TObject;
                       Const BtrIntf   : TCtkTdPostExLocalPtr);
    Destructor Destroy; override;
    Function GetCloneInterface (Const Code : ShortString) : IJobAnalysis;
    procedure CloneDetails(const JobAnDetails : TBatchJobAnalRec);
  end;

  Function CreateTJobAnalysis (Const Toolkit : TObject; Const ClientId : Integer) : TJobAnalysis;


implementation

uses
  ComServ, DllMiscU, DllErrU, BtKeys1U, EtStrU, DllJobU, CustomFieldsIntf;

Function CreateTJobAnalysis (Const Toolkit : TObject; Const ClientId : Integer) : TJobAnalysis;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTJobAnalysis }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by object
  BtrIntf^.Open_System(JMiscF, JMiscF);

  // Create bas TAccount object
  Result := TJobAnalysis.Create(imGeneral, Toolkit, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([JMiscF]);

End; { CreateTJobAnalysis }


Constructor TJobAnalysis.Create(Const IType     : TInterfaceMode;
                                Const Toolkit   : TObject;
                                Const BtrIntf   : TCtkTdPostExLocalPtr);
begin
  Inherited Create (ComServer.TypeLib, IJobAnalysis3, BtrIntf); //PR: 21/01/2011 ABSEXCH-10392

  // Initialise Btrieve Ancestor
  FFileNo := JMiscF;

  FillChar(FJobAnalysisRec, SizeOf(FJobAnalysisRec), #0);

  InitObjects;
  FIntfType := IType;

  FToolkit := Toolkit;
  FObjectID := tkoJobAnalysis;

end;

Destructor TJobAnalysis.Destroy;
begin
  InitObjects;

    If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
end;

procedure TJobAnalysis.InitObjects;
begin
  FToolkit := nil;
end;

function  TJobAnalysis.Get_anCode: WideString;
begin
  Result := FJobAnalysisRec.JAnalCode;
end;

procedure TJobAnalysis.Set_anCode(const Value: WideString);
begin
  FJobAnalysisRec.JAnalCode := Value;
end;

function  TJobAnalysis.Get_anDescription: WideString;
begin
  Result := FJobAnalysisRec.JAnalDesc;
end;

procedure TJobAnalysis.Set_anDescription(const Value: WideString);
begin
  FJobAnalysisRec.JAnalDesc := Value;
end;

function TJobAnalysis.Get_anType: TAnalysisType;
begin
  Case FJobAnalysisRec.JAnalType of
    'R'  :  Result := anTypeRevenue;
    'O'  :  Result := anTypeOverheads;
    'M'  :  Result := anTypeMaterials;
    'L'  :  Result := anTypeLabour;
  Else
    Raise EUnknownValue.Create ('Invalid Job Analysis Type ' + QuotedStr(FJobAnalysisRec.JAnalType));
  End; { Case }
end;

procedure TJobAnalysis.Set_anType(Value: TAnalysisType);
begin
  Case Value of
    anTypeRevenue    :  FJobAnalysisRec.JAnalType := 'R';
    anTypeOverheads  :  FJobAnalysisRec.JAnalType := 'O' ;
    anTypeMaterials  :  FJobAnalysisRec.JAnalType := 'M';
    anTypeLabour     :  FJobAnalysisRec.JAnalType := 'L';
  Else
    Raise EUnknownValue.Create ('Invalid Job Analysis Type ' + IntToStr(Ord(Value)));
  End; { Case }
end;

function TJobAnalysis.Get_anCategory: TAnalysisCategory;
begin
  Case FJobAnalysisRec.JAnalCatry of
     'A'  :  Result := anCatSales;
     'T'  :  Result := anCatTime;
     'D'  :  Result := anCatDisbursement;
     'N'  :  Result := anCatNRDisbursements;
     'I'  :  Result := anCatStockIssues;
     'O'  :  Result := anCatOverheads;
     'R'  :  Result := anCatReceipts;
     'W'  :  Result := anCatWorkInProgress;
     'S'  :  Result := anCatRetentionSL;
     'P'  :  Result := anCatRetentionPL;
     #11  :  Result := anCatSubLabour;
     #12  :  Result := anCatMaterials2;
     #13  :  Result := anCatOverheads2;
     #14  :  Result := anCatSalesDeductions;
     #15  :  Result := anCatSalesApps;
     #16  :  Result := anCatPurchaseApps;
     #17  :  Result := anCatPurchaseDeductions;
  Else
    Raise EUnknownValue.Create ('Invalid Job Analysis Category ' +
                                    QuotedStr(FJobAnalysisRec.JAnalCatry));
  End; { Case }
end;

procedure TJobAnalysis.Set_anCategory(Value: TAnalysisCategory);
begin
  Case Value of
    anCatSales            :  FJobAnalysisRec.JAnalCatry := 'A';
    anCatTime             :  FJobAnalysisRec.JAnalCatry := 'T';
    anCatDisbursement     :  FJobAnalysisRec.JAnalCatry := 'D';
    anCatNRDisbursements  :  FJobAnalysisRec.JAnalCatry := 'N';
    anCatStockIssues      :  FJobAnalysisRec.JAnalCatry := 'I';
    anCatOverheads        :  FJobAnalysisRec.JAnalCatry := 'O';
    anCatReceipts         :  FJobAnalysisRec.JAnalCatry := 'R';
    anCatWorkInProgress   :  FJobAnalysisRec.JAnalCatry := 'W';
    anCatRetentionSL      :  FJobAnalysisRec.JAnalCatry := 'S';
    anCatRetentionPL      :  FJobAnalysisRec.JAnalCatry := 'P';
    anCatSubLabour        :  FJobAnalysisRec.JAnalCatry := #11;
    anCatMaterials2       :  FJobAnalysisRec.JAnalCatry := #12;
    anCatOverheads2       :  FJobAnalysisRec.JAnalCatry := #13;
    anCatSalesDeductions  :  FJobAnalysisRec.JAnalCatry := #14;
    anCatSalesApps        :  FJobAnalysisRec.JAnalCatry := #15;
    anCatPurchaseApps     :  FJobAnalysisRec.JAnalCatry := #16;
    anCatPurchaseDeductions
                          :  FJobAnalysisRec.JAnalCatry := #17;
  Else
    Raise EUnknownValue.Create ('Invalid Job Analysis Category ' +
                                    IntToStr(Ord(Value)));
  End; { Case }
end;

function TJobAnalysis.Get_anWIPGL: Integer;
begin
  Result := FJobAnalysisRec.WIPNomCode;
end;

procedure TJobAnalysis.Set_anWIPGL(Value: Integer);
begin
  FJobAnalysisRec.WIPNomCode := Value;
end;

function TJobAnalysis.Get_anPandLGL: Integer;
begin
  Result := FJobAnalysisRec.PLNomCode;
end;

procedure TJobAnalysis.Set_anPandLGL(Value: Integer);
begin
  FJobAnalysisRec.PLNomCode := Value;
end;

function TJobAnalysis.Get_anLineType: TTransactionLineType;
begin
  Case FJobAnalysisRec.LineType of
    'N'  :  Result := tlTypeNormal;
    'F'  :  Result := tlTypeFreight;
    'M'  :  Result := tlTypeMaterials;
    'L'  :  Result := tlTypeLabour;
    'D'  :  Result := tlTypeDiscount;
    #5   :  Result := tlTypeMaterials1;
    #6   :  Result := tlTypeMaterials2;
    #7   :  Result := tlTypeLabour1;
    #8   :  Result := tlTypeLabour2;
    #9   :  Result := tlTypeRetentions1;
    #10  :  Result := tlTypeRetentions2;
    #11  :  Result := tlTypeDeductions1;
    #12  :  Result := tlTypeDeductions2;
    #13  :  Result := tlTypeDeductions3;
    #14  :  Result := tlTypeCITB;
    #15  :  Result := tlTypeCIS;
    #16  :  Result := tlTypeMisc1;
    #17  :  Result := tlTypeMisc2;
  Else
    Raise EUnknownValue.Create ('Invalid Job Analysis Line Type ' +
                        QuotedStr(FJobAnalysisRec.LineType));
  End; { Case }
end;

procedure TJobAnalysis.Set_anLineType(Value: TTransactionLineType);
begin
  Case Value of
    tlTypeNormal    :  FJobAnalysisRec.LineType := 'N';
    tlTypeFreight   :  FJobAnalysisRec.LineType := 'F';
    tlTypeMaterials :  FJobAnalysisRec.LineType := 'M';
    tlTypeLabour    :  FJobAnalysisRec.LineType := 'L';
    tlTypeDiscount  :  FJobAnalysisRec.LineType := 'D';
    tlTypeMaterials1 :  FJobAnalysisRec.LineType := #5;
    tlTypeMaterials2 :  FJobAnalysisRec.LineType := #6;
    tlTypeLabour1    :  FJobAnalysisRec.LineType := #7;
    tlTypeLabour2    :  FJobAnalysisRec.LineType := #8;
    tlTypeRetentions1:  FJobAnalysisRec.LineType := #9;
    tlTypeRetentions2:  FJobAnalysisRec.LineType := #10;
    tlTypeDeductions1:  FJobAnalysisRec.LineType := #11;
    tlTypeDeductions2:  FJobAnalysisRec.LineType := #12;
    tlTypeDeductions3:  FJobAnalysisRec.LineType := #13;
    tlTypeCITB       :  FJobAnalysisRec.LineType := #14;
    tlTypeCIS        :  FJobAnalysisRec.LineType := #15;
    tlTypeMisc1      :  FJobAnalysisRec.LineType := #16;
    tlTypeMisc2      :  FJobAnalysisRec.LineType := #17;
  Else
    Raise EUnknownValue.Create ('Invalid Job Analysis LineType ' +
                        IntToStr(Ord(Value)));
  End; { Case }
end;


function  TJobAnalysis.Get_Index: TJobAnalysisIndex;
begin
  Result := inherited Get_Index;
end;

procedure TJobAnalysis.Set_Index(Value: TJobAnalysisIndex);
begin
  inherited Set_Index(Value);
end;

function  TJobAnalysis.Clone: IJobAnalysis;
Var
  CloneO : TJobAnalysis;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  CloneO := TJobAnalysis.Create(imClone, FToolkit, FBtrIntf);
  if Assigned(CloneO) then
  begin
    CloneO.CloneDetails(FJobAnalysisRec);
  end;
  Result := CloneO;
end;

function TJobAnalysis.BuildCodeIndex(const Code : WideString) : WideString;
begin
  Result := LJVar(UpperCase(Code), AnalKeyLen);
end;

function TJobAnalysis.BuildDescriptionIndex(const Description : WideString) : WideString;
var
  ZeroPaddedDescription : String;
begin
//Description index is padded with #0 rather then #32 so need to make string compatible

  ZeroPaddedDescription := Description + StringOfChar (#0, 20);
  Result := UpperCase(Copy(ZeroPaddedDescription, 1, 20));

end;

Function  TJobAnalysis.AuthoriseFunction (Const FuncNo : Byte;
                                          Const MethodName : String;
                                          Const AccessType : Byte = 0) : Boolean;
begin
  Case FuncNo Of
    // Step functions
    1..4      : Result := False;  { Not supported as CustF is shared file }

    5..99     : Result := (FIntfType = imGeneral);

    // .Add method
    100       : Result := (FIntfType = imGeneral);
    // .Update method
    101       : Result := (FIntfType = imGeneral);
    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate]);
    // .Cancel method
    103       : Result := (FIntfType = imUpdate);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);
  Else
    Result := False;
  End; { Case FuncNo }

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }

end;

Function  TJobAnalysis.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  With FBtrIntf^ Do Begin
    // General index including CC, Dept, Notes, Matching, etc... records
    BtrOpCode := BtrOp;
    KeyS := SetKeyString(BtrOp, JARCode + JAACode + SearchKey);

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS := JARCode + JAACode + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS := JARCode + JAACode + #255;
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                     End;

      // Looking for exact match - do it and finish
      B_GetEq      : Loop := False;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    Repeat
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      BtrOpCode := BtrOpCode2;

      {PR 24/06/2008 - If we've passed the Prefix/SubType we want then drop out of loop
       to avoid reading remaining records in file - may improve SQL performance.}
      if (Result = 0) and ((LJobMisc.RecPFix <> JARCode) or (LJobMisc.SubType <> JAACode)) then
        Result := 9;

    Until (Result <> 0) Or (Not Loop) Or ((LJobMisc.RecPFix = JARCode) And (LJobMisc.SubType = JAACode));

    FKeyString := KeyS;


    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LJobMisc.RecPFix = JARCode) And (LJobMisc.SubType = JAACode) Then
      begin
        // Convert to Toolkit structure
        CopyDataRecord;
      end
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (62, Result);
End; { GetDataRecord }

procedure TJobAnalysis.CopyDataRecord;
begin
  CopyExJobAnalysisToTKJobAnalysis (FBtrIntf^.LJobMisc^.JobAnalRec, FJobAnalysisRec);
(*  With FJobAnalysisRec, FBtrIntf^ do
  begin
    JAnalCode:=LJobMisc^.JobAnalRec.JAnalCode;
    JAnalDesc:=LJobMisc^.JobAnalRec.JAnalName;

    Case LJobMisc^.JobAnalRec.JAType of
      1 : JAnalType:='R';  {Revenue}
      2 : JAnalType:='O';  {Overhead}
      3 : JAnalType:='M';  {Material}
      4 : JAnalType:='L';  {Labour}
    end;

    Case LJobMisc^.JobAnalRec.AnalHed of
      1 : JAnalCatry:='A';  { Sales }
      2 : JAnalCatry:='T';  { Time }
      3 : JAnalCatry:='D';  { Disbursement }
      4 : JAnalCatry:='N';  { Non-Recover Discursement }
      5 : JAnalCatry:='I';  { Stock Issues }
      6 : JAnalCatry:='O';  { Overheads }
      7 : JAnalCatry:='R';  { Receipts }
      8 : JAnalCatry:='W';  { WIP }
      9 : JAnalCatry:='S';  { Retention SL }
     10 : JAnalCatry:='P';  { Retention PL }
    end;

    WIPNomCode:=LJobMisc^.JobAnalRec.WIPNom[BOff];
    PLNomCode:=LJobMisc^.JobAnalRec.WIPNom[BOn];

    Case LJobMisc^.JobAnalRec.JLinkLT of
      0  :  LineType:='N';  { Normal }
      1  :  LineType:='F';  { Freight }
      2  :  LineType:='M';  { Materials }
      3  :  LineType:='L';  { Labour }
      4  :  LineType:='D';  { Discount }
    end;
  end; *)
end;

Function TJobAnalysis.GetCloneInterface (Const Code : ShortString) : IJobAnalysis;
Var
  SaveInfo : TBtrieveFileSavePos;
  lanCode  : ShortString;
  Res      : LongInt;
Begin { GetCloneInterface }
  Result := NIL;

  // Reformat as valid account code
  lanCode := BuildCodeIndex(Code);

  // Check not blank
  If (Trim(lanCode) <> '') Then Begin
    // Save Current Position and index
    SaveExLocalPosRec (SaveInfo, @FJobAnalysisRec, SizeOf(FJobAnalysisRec));

    // Find record for AcCode
    Set_Index(anIdxCode);
    Res := GetDataRecord (B_GetEq, lanCode);
    If (Res = 0) Then Begin
      // Got Record - generate and return a Clone interface
      Result := Clone;
    End; { If (Res = 0) }

    // Restore Original Index and position
    RestoreExLocalPosRec (SaveInfo, @FJobAnalysisRec, SizeOf(FJobAnalysisRec));
  End; { If (Trim(ljtCode) <> '') }
End; { GetCloneInterface }

procedure TJobAnalysis.CloneDetails(const JobAnDetails : TBatchJobAnalRec);
begin
  FJobAnalysisRec := JobAnDetails;
end;

function TJobAnalysis.Get_anTypeString: WideString;
begin
  Case FJobAnalysisRec.JAnalType of
    'R'  :  Result := 'Revenue';
    'O'  :  Result := 'Overheads';
    'M'  :  Result := 'Materials';
    'L'  :  Result := 'Labour';
  Else
    Raise EUnknownValue.Create ('Invalid Job Analysis Type ' + QuotedStr(FJobAnalysisRec.JAnalType));
  End; { Case }
end;

function TJobAnalysis.Get_anCategoryString: WideString;
begin
  Try
    Result := SyssJob^.JobSetUp.SummDesc[Succ(Ord(Get_anCategory))];
  Except
     Raise EUnknownValue.Create ('Invalid Job Analysis Category ' +
                                    QuotedStr(FJobAnalysisRec.JAnalCatry));
  End;

end;

function TJobAnalysis.Get_anLineTypeString: WideString;
begin
  // HM 28/02/01: Modified to reference system setup
  // PR 24/3/05: Modified for Apps & Vals lines
  Case FJobAnalysisRec.LineType of
    'N'  :  Result := 'Normal';
    //PR: 27/10/2011 v6.9 handle new custom fields
    'F'  :  Result := CustomFields[cfLineTypes, 1].cfCaption;  //'Freight';
    'M'  :  Result := CustomFields[cfLineTypes, 2].cfCaption;  //'Materials';
    'L'  :  Result := CustomFields[cfLineTypes, 3].cfCaption;  //'Labour';
    'D'  :  Result := CustomFields[cfLineTypes, 4].cfCaption; //'Discount';
{    'F'  :  Result := SyssVAT^.VATRates.UDFCaption[9];  //'Freight';
    'M'  :  Result := SyssVAT^.VATRates.UDFCaption[8];  //'Materials';
    'L'  :  Result := SyssVAT^.VATRates.UDFCaption[7];  //'Labour';
    'D'  :  Result := SyssVAT^.VATRates.UDFCaption[10]; //'Discount';}
    #5   :  Result := 'Materials 1';
    #6   :  Result := 'Materials 2';
    #7   :  Result := 'Labour 1';
    #8   :  Result := 'Labour 2';
    #9   :  Result := 'Retentions 1';
    #10  :  Result := 'Retentions 2';
    #11  :  Result := 'Deductions 1';
    #12  :  Result := 'Deductions 2';
    #13  :  Result := 'Deductions 3';
    #14  :  Result := 'CITB';
    #15  :  Result := 'CIS';
    #16  :  Result := 'Misc 1';
    #17  :  Result := 'Misc 2';
  Else
    Raise EUnknownValue.Create ('Invalid Job Analysis LineType ' +
                        QuotedStr(FJobAnalysisRec.LineType));
  End; { Case }
end;

function TJobAnalysis.Update: IJobAnalysis2;
Var
  UpdateO : TJobAnalysis;
  FuncRes  : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TJobAnalysis.Create(imUpdate, FToolkit, FBtrIntf);

    // Pass current job Record and Locking Details into sub-object
    UpdateO.LoadDetails(FJobAnalysisRec, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;

function TJobAnalysis.Add: IJobAnalysis2;
Var
  AddO : TJobAnalysis;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TJobAnalysis.Create(imAdd, FToolkit, FBtrIntf);
  AddO.InitNewRecord;

  Result := AddO;
end;

function TJobAnalysis.Save: Integer;
Var
  SaveInfo  : TBtrieveSavePosType;
  SaveInfo2 : TBtrieveFileSavePos;
  BtrOp     : SmallInt;
begin
  AuthoriseFunction(102, 'Save');

  // Save current file positions in main files
  SaveInfo := SaveSystemFilePos ([]);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Result := PositionOnLock;
    BtrOp := B_Update;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Result := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Result = 0) Then Begin
    // Add/Update
    SaveExLocalPos(SaveInfo2);
    Result := Ex_StoreJobAnalysis (@FJobAnalysisRec, SizeOf(FJobAnalysisRec), FIndex, BtrOp);
    RestoreExLocalPos(SaveInfo2);

    //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
    if Result = 0 then
      FIntfType := imClone;
  End; { If (Res = 0) }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (168, Result);

  // Restore original file positions
  RestoreSystemFilePos (SaveInfo);
end;

procedure TJobAnalysis.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

Procedure TJobAnalysis.LoadDetails (Const JADets : TBatchJobAnalRec; Const LockPos : LongInt);
begin
  FJobAnalysisRec := JADets;

  LockCount := 1;
  LockPosition := LockPos;
end;

procedure TJobAnalysis.InitNewRecord;
begin
  FillChar(FJobAnalysisRec, SizeOf(FJobAnalysisRec), 0);
  FJobAnalysisRec.LineType := 'N';
end;

function TJobAnalysis.Get_anCISTaxRate: TCISTaxType;
begin
  Case FJobAnalysisRec.CISTaxRate of
    #0   : Result := cisttNA;
    'C'  : Result := cisttConstruction;
    'T'  : Result := cisttTechnical;
  end;
end;

procedure TJobAnalysis.Set_anCISTaxRate(Value: TCISTaxType);
begin
  Case Value of
    cisttNA           : FJobAnalysisRec.CISTaxRate := #0;
    cisttConstruction : FJobAnalysisRec.CISTaxRate := 'C';
    cisttTechnical    : FJobAnalysisRec.CISTaxRate := 'T';
  end;
end;

function TJobAnalysis.Get_anUplift: Double;
begin
  Result := FJobAnalysisRec.UpliftP;
end;

procedure TJobAnalysis.Set_anUplift(Value: Double);
begin
  FJobAnalysisRec.UpliftP := Value;
end;

function TJobAnalysis.Get_anUpliftGL: Integer;
begin
  Result := FJobAnalysisRec.UpliftGL;
end;

procedure TJobAnalysis.Set_anUpliftGL(Value: Integer);
begin
  FJobAnalysisRec.UpliftGL := Value;
end;

function TJobAnalysis.Get_anPayrollCode: WideString;
begin
  Result := FJobAnalysisRec.jaPayCode;
end;

procedure TJobAnalysis.Set_anPayrollCode(const Value: WideString);
begin
  FJobAnalysisRec.jaPayCode := Value;
end;

function TJobAnalysis.Get_anRevenueType: TRevenueType;
begin
  Result := FJobAnalysisRec.RevenueType;
end;

procedure TJobAnalysis.Set_anRevenueType(Value: TRevenueType);
begin
  FJobAnalysisRec.RevenueType := Value;
end;


function TJobAnalysis.Get_anDeductionBase: TJobDeductionBaseType;
begin
  Case FJobAnalysisRec.jaDetType of
    0  :  Result := dbtPercentage;
    1  :  Result := dbtValue;
  end;
end;

procedure TJobAnalysis.Set_anDeductionBase(Value: TJobDeductionBaseType);
begin
  Case Value of
    dbtPercentage : FJobAnalysisRec.jaDetType := 0;
    dbtValue      : FJobAnalysisRec.jaDetType := 1;
    else
      raise ERangeError.Create('Value out of range (' + IntToStr(Value) + ')');
  end;
end;

function TJobAnalysis.Get_anCalcBeforeRetention: WordBool;
begin
  Result :=  FJobAnalysisRec.jaCalcB4Ret;
end;

procedure TJobAnalysis.Set_anCalcBeforeRetention(Value: WordBool);
begin
  FJobAnalysisRec.jaCalcB4Ret := Value;
end;

function TJobAnalysis.Get_anDeduction: Double;
begin
  Result := FJobAnalysisRec.jaDeduct;
end;

procedure TJobAnalysis.Set_anDeduction(Value: Double);
begin
  FJobAnalysisRec.jaDeduct := Value;
end;

function TJobAnalysis.Get_anApplyDeduction: TDeductionApplyToType;
begin
  Case FJobAnalysisRec.jaDeductApply of
    0 : Result := datAll;
    1 : Result := datMaterials;
    2 : Result := datLabour;
    3 : Result := datMaterialsAndLabour;
    4 : Result := datOverheads;
  end;
end;

procedure TJobAnalysis.Set_anApplyDeduction(Value: TDeductionApplyToType);
begin
  Case Value of
    datAll                : FJobAnalysisRec.jaDeductApply := 0;
    datMaterials          : FJobAnalysisRec.jaDeductApply := 1;
    datLabour             : FJobAnalysisRec.jaDeductApply := 2;
    datMaterialsAndLabour : FJobAnalysisRec.jaDeductApply := 3;
    datOverheads          : FJobAnalysisRec.jaDeductApply := 4;
    else
      raise ERangeError.Create('Value out of range (' + IntToStr(Value) + ')');
  end;
end;

function TJobAnalysis.Get_anRetentionType: TAppsInterimType;
begin
  Case FJobAnalysisRec.jaRetType of
    0  :  Result := aifStandAlone;
    1  :  Result := aifInterim;
    2  :  Result := aifPractical;
    3  :  Result := aifFinal;
  end;
end;

procedure TJobAnalysis.Set_anRetentionType(Value: TAppsInterimType);
begin
  if Value in [aifStandAlone..aifFinal] then
    FJobAnalysisRec.jaRetType := Ord(Value)
  else
    raise ERangeError.Create('Value out of range (' + IntToStr(Value) + ')');
end;

function TJobAnalysis.Get_anRetentionValue: Double;
begin
  Result := FJobAnalysisRec.jaRetValue;
end;

procedure TJobAnalysis.Set_anRetentionValue(Value: Double);
begin
  FJobAnalysisRec.jaRetValue := Value;
end;

function TJobAnalysis.Get_anRetentionExpiryType: TRetentionExpiryType;
begin
  Result := TRetentionExpiryType(FJobAnalysisRec.jaRetExpiry);
end;

procedure TJobAnalysis.Set_anRetentionExpiryType(Value: TRetentionExpiryType);
begin
  if Value in [reMonths..reOnFinal] then
    FJobAnalysisRec.jaRetExpiry := Value
  else
    raise ERangeError.Create('Value out of range (' + IntToStr(Value) + ')');
end;

function TJobAnalysis.Get_anRetentionExpiryInterval: Integer;
begin
  Result := FJobAnalysisRec.jaRetExpInterval;
end;

procedure TJobAnalysis.Set_anRetentionExpiryInterval(Value: Integer);
begin
  FJobAnalysisRec.jaRetExpInterval := Value;
end;

function TJobAnalysis.Get_anPreserveRetention: WordBool;
begin
  Result := FJobAnalysisRec.jaPreserveRet;
end;

procedure TJobAnalysis.Set_anPreserveRetention(Value: WordBool);
begin
  FJobAnalysisRec.jaPreserveRet := Value;
end;

function TJobAnalysis.Get_anCalcDeductionAs: TDeductionType;
begin
  Result := TDeductionType(FJobAnalysisRec.jaDeductCalc);
end;

procedure TJobAnalysis.Set_anCalcDeductionAs(Value: TDeductionType);
begin
  if Value in [detNormal..detContra] then
    FJobAnalysisRec.jaDeductCalc := Value
  else
    raise ERangeError.Create('Value out of range (' + IntToStr(Value) + ')');
end;

//IBrowseInfo
function TJobAnalysis.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;





end.
