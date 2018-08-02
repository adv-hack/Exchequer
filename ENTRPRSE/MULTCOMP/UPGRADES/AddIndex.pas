unit AddIndex;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmIdxProgress = class(TForm)
    Label1: TLabel;
    lblIndexNo: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDataDir : string;
    FVerNo : string;
    FErrStr : string;
    FResult : Integer;
    FirstTime : Boolean;
    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_User+1;
    procedure Create62Index;
    function Do62Initialisations(var RErrStr : string) : Integer;
    function UpdateHookSecurity: LongInt;
    procedure CreateCustSuppIndexes;
    procedure Add708DetailIndexes;
    procedure UpdateProgress(IdxNo, IdxTotal : Integer);
  public
    { Public declarations }
    property DataDir : string read FDataDir write FDataDir;
    property IdxResult : Integer read FResult write FResult;
    property VersionNo : string read FVerNo write FVerNo;
    property ErrorString : string read FErrStr write FErrStr;
  end;

var
  frmIdxProgress: TfrmIdxProgress;

  function AddNewIndex(VerNo     :  String;
                       CompDir   :  String;
                   Var RErrStr   :  String)  :  Integer; STDCALL; Export;


implementation

{$R *.dfm}
uses
  VarConst, IdxObj, BtrvU2, GlobVar, SQLUtils, oCompany, Crypto;

function AddNewIndex(VerNo     :  String;
                     CompDir   :  String;
                 Var RErrStr   :  String)  :  Integer;
begin

  with TfrmIdxProgress.Create(Application) do
  Try
    VersionNo := VerNo;
    DataDir := CompDir;
    ShowModal;

    Result := IdxResult;
    if Result <> 0 then
      RErrStr := ErrorString;
  Finally
    Free;
  End;
end;




{ TfrmIdxProgress }

procedure TfrmIdxProgress.Create62Index;
var
  FAddIndex : TAddIndex;
  StartTime : Int64;
begin
  Label1.Refresh;
  Application.ProcessMessages;
  FAddIndex := TAddIndex.Create;
  Try
    //Set file and index details
    FAddIndex.Filename := DataDir + 'TRANS\DETAILS.DAT';
    FAddIndex.FileNumber := 3; //Details
    FAddIndex.IndexNumber := 9;

    //Check if we need to add the index
    if not SQLUtils.UsingSQL and not FAddIndex.IndexExists then
    begin
      //Add index segments

      //Account Code
      with FAddIndex.AddSegment do
      begin
        KeyPosition   := BtKeyPos (@Id.CustCode[1], @Id);   // Skip length byte
        KeyLength  := SizeOf (Id.CustCode) - 1;          // subtract length byte
        KeyFlags      := DupModSeg + ManK;
      end;

      //EC Service
      with FAddIndex.AddSegment do
      begin
        KeyPosition   := BtKeyPos (@Id.ECService, @Id);
        KeyLength     := SizeOf (Id.ECService);
        KeyFlags      := DupModSeg + ManK + ExtType;
        ExtendedType  := BBoolean;
      end;

      //EC Start Date (but subject to change!)
      with FAddIndex.AddSegment do
      begin
        KeyPosition   := BtKeyPos (@Id.ServiceStartDate[1], @Id);    // Skip length byte
        KeyLength     := SizeOf (Id.ServiceStartDate) - 1;           // subtract length byte
        KeyFlags      := DupMod + ManK;
      end;

//      StartTime := GetTickCount;
      //Run
      FResult := FAddIndex.Execute;

//      ShowMessage(intToStr((GetTickCount - StartTime) div 1000));
      //If result <> 0 then set Error String for return
      if FResult > 30000 then
        FErrStr := 'Error opening file: ' + IntToStr(FResult - 30000)
      else
      if FResult <> 0 then
        FErrStr := 'Error creating index: ' + IntToStr(FResult)
      else
        //Update SystemSetup with EC Goods Threshold Amount
        FResult := Do62Initialisations(FErrStr);

    end
    else
    if SQLUtils.UsingSQL then
      //Update SystemSetup with EC Goods Threshold Amount
      FResult := Do62Initialisations(FErrStr);

    if (FResult = 0) then
      FResult := UpdateHookSecurity;

  Finally
    FAddIndex.Free;
  End;
end;

procedure TfrmIdxProgress.WMCustGetRec(var Message: TMessage);
begin
  Try
    Create62Index;
    CreateCustSuppIndexes;
    Add708DetailIndexes; //PR: 07/01/2014 ABSEXCH-14854
  Finally
    //Close form
    PostMessage(Self.Handle, WM_CLOSE, 0, 0);
  End;
end;

procedure TfrmIdxProgress.FormActivate(Sender: TObject);
begin
  if FirstTime then
  begin
    FirstTime := False;
    PostMessage(Self.Handle, WM_USER + 1, 0, 0);
  end;
end;

procedure TfrmIdxProgress.FormCreate(Sender: TObject);
begin
  FirstTime := True;
end;

function TfrmIdxProgress.Do62Initialisations(var RErrStr : string) : Integer;
const
  sUKCountryCode = '044';
  sIRCountryCode = '353';

  dUKThreshold = 70000;
  dIRThreshold = 100000;
var
  s : string;
  msgRes, Res : Integer;
  KeyS : Str255;
  FDataPath : string;
  dThresholdAmount : Double;
begin
  FDataPath := FDataDir;
  Res := Open_File(F[SysF], FDataPath + Filenames[SysF], 0);

  if Res = 0 then
  begin
    Try
      KeyS:=SysNames[SysR];

      Res := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, KeyS);

      if Res = 0 then
      begin
        if Syss.USRCntryCode = sUKCountryCode then
          dThresholdAmount := dUKThreshold
        else
        if Syss.USRCntryCode = sIRCountryCode then
          dThresholdAmount := dIRThreshold
        else
          dThresholdAmount := 0;

        KeyS:=SysNames[VATR];

        Res := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, KeyS);

        if (Res = 0) and (not SQLUtils.UsingSQL or (Syss.VATRates.ECSalesThreshold < 0)) then
        begin
          Syss.VATRates.EnableECServices := False;
          Syss.VATRates.ECSalesThreshold := dThresholdAmount;

          Res := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, 0);

          if Res <> 0 then
            RErrStr := 'Database error ' + IntToStr(Res) + ' storing System VAT Record';
        end
        else
          RErrStr := 'Database error ' + IntToStr(Res) + ' reading System VAT Record';
      end
      else
        RErrStr := 'Database error ' + IntToStr(Res) + ' reading System Record';
    Finally
      Close_File(F[SysF]);
    End;

  end
  else
    RErrStr := 'Unable to open file ' + QuotedStr(FDataPath + Filenames[SysF]) + '. Btrieve Error ' + IntToStr(Res);

  Result := Res;

end;

function TfrmIdxProgress.UpdateHookSecurity: LongInt;
var
  Datapath: string;
  Key: Str255;
  Company: TCompanyFile;
begin
  Result := 0;
  if SQLUtils.ValidSystem(FDataDir) then
  begin
    { Locate the COMPANY records against a RecPFix of 'H' (Hook Security). For
      each record, if the hkVersion value is zero, encrypt the hkSecCode field,
      and set the hkVersion to 1. }
    DataPath := FDataDir;

    Company := TCompanyFile.Create;
    Result := Company.OpenFile(DataPath + 'COMPANY.DAT');
    if SQLUtils.UsingSql and (Result <> 0) then
    begin
      Result := Result - 11000;
      FErrStr := SQLUtils.GetSQLErrorInformation(Result);
    end;

    if Result = 0 then
    begin
      Key := 'H';
      Result := Company.GetGreaterThanOrEqual(Key);
      while ((Result = 0) and (Company.RecPFix = 'H')) do
      begin
        if (Company.hkVersion = 0) then
        begin
          Company.hkEncryptedCode := Encode(Company.hkSecCode);
          Company.hkSecCode := '';
          Company.hkVersion := 1;
          Result := Company.Update;
          if (Result <> 0) then
          begin
            FErrStr := 'Database error ' + IntToStr(Result) + ' storing Hook Security record';
            break;
          end;
        end;
        Result := Company.GetNext;
      end;
    end;
    if (Result = 9) then
      Result := 0;
    Company.CloseFile;
  end;
end;

procedure TfrmIdxProgress.CreateCustSuppIndexes;
var
  addIndex : TAddIndex;
  Res : Integer;

  //Add the subtype segment of the index
  procedure AddSubtypeSeg(const oSegment : TIndexObject; Flags : Integer = DupModSeg);
  begin
    with oSegment do
    begin
      KeyPosition := BtKeyPos(@Cust.acSubtype, @Cust);
      KeyLength := SizeOf(Cust.acSubtype);
      KeyFlags := Flags+AltColSeq;
    end;
  end;

begin
  //Only need this for Pervasive
  if SQLUtils.UsingSQL then
    EXIT;

  Res := 0;
  addIndex := TAddIndex.Create;
  addIndex.Filename := DataDir + Filenames[CustF];
  addIndex.IndexNumber := 12;
  addIndex.FileNumber := CustF;

  Try
    //Check that the first of the 4 indexes exists - if it does
    //then this file has already been upgraded so do nothing.
    if not addIndex.IndexExists then
    begin
      addIndex.UseAltColSeq := True;
      AddSubTypeSeg(addIndex.AddSegment, ModSeg);
      with addIndex.AddSegment do
      begin
        KeyPosition := BtKeyPos(@Cust.CustCode, @Cust) + 1;
        KeyLength := SizeOf(Cust.CustCode) - 1;
        KeyFlags := Modfy+AltColSeq;
      end;

      Res := addIndex.Execute;

      if Res = 0 then
      begin
        addIndex.Clear;
        addIndex.IndexNumber := 13;
        addIndex.UseAltColSeq := True;
        AddSubTypeSeg(addIndex.AddSegment);
        with addIndex.AddSegment do
        begin
          KeyPosition := BtKeyPos(@Cust.acLongAcCode, @Cust) + 1;
          KeyLength := SizeOf(Cust.acLongAcCode) - 1;
          KeyFlags := DupMod+AltColSeq;
        end;

        Res := addIndex.Execute;
      end;

      if Res = 0 then
      begin
        addIndex.Clear;
        addIndex.IndexNumber := 14;
        addIndex.UseAltColSeq := True;
        AddSubTypeSeg(addIndex.AddSegment);
        with addIndex.AddSegment do
        begin
          KeyPosition := BtKeyPos(@Cust.Company, @Cust) + 1;
          KeyLength := SizeOf(Cust.Company) - 1;
          KeyFlags := DupMod+AltColSeq;
        end;

        Res := addIndex.Execute;
      end;

      if Res = 0 then
      begin
        addIndex.Clear;
        addIndex.IndexNumber := 15;
        addIndex.UseAltColSeq := True;
        AddSubTypeSeg(addIndex.AddSegment);
        with addIndex.AddSegment do
        begin
          KeyPosition := BtKeyPos(@Cust.CustCode2, @Cust) + 1;
          KeyLength := SizeOf(Cust.CustCode2) - 1;
          KeyFlags := DupMod+AltColSeq;
        end;

        Res := addIndex.Execute;
      end;
    end;
  Finally
    FResult := Res;
    if Res <> 0 then
      FErrStr := Format('Error %d occurred while creating index %d', [Res, addIndex.IndexNumber]);
    addIndex.Free;
  End;

end;


//PR: 07/01/2014 ABSEXCH-14854 New indexes on Details table.
procedure TfrmIdxProgress.Add708DetailIndexes;
var
  addIndex : TAddIndex709;
  Res : Integer;

begin
  //Only need this for Pervasive
  if SQLUtils.UsingSQL then
    EXIT;

  Res := 0;

  //PR: 13/03/2014 ABSEXCH-ABSEXCH-15102 Change to use one-off object to replace indexes added in 708.
  addIndex := TAddIndex709.Create;
  addIndex.Filename := DataDir + Filenames[IDetailF];
  addIndex.IndexNumber := 10;
  addIndex.FileNumber := IDetailF;

  Try
    //Check that the first of the 3 indexes exists - if it does
    //then this file has already been upgraded so do nothing.
    if not addIndex.IndexExists then
    begin
      // Index 10 - CustCode+DocPRef (IdCustCodeK)
      addIndex.UseAltColSeq := True;
      with addIndex.AddSegment do
      begin
        KeyPosition := BtKeyPos (@Id.CustCode[1], @Id);
        KeyLength   := SizeOf (Id.CustCode) - 1;
        KeyFlags    := DupModSeg + ManK;
      end;

      with addIndex.AddSegment do
      begin
        KeyPosition := BtKeyPos (@Id.DocPRef[1], @Id);
        KeyLength   := SizeOf (Id.DocPRef) - 1;
        KeyFlags    := DupMod + Mank;
      end;

      UpdateProgress(1, 3);
      Res := addIndex.Execute;

      if Res = 0 then
      begin
        addIndex.Clear;

        // Index 11 - DocPRef (IdDocPRefK)
        addIndex.UseAltColSeq := True;
        addIndex.IndexNumber := addIndex.IndexNumber + 1;
        with addIndex.AddSegment do
        begin
          KeyPosition := BtKeyPos (@Id.DocPRef[1], @Id);
          KeyLength   := SizeOf (Id.DocPRef) - 1;
          KeyFlags    := DupMod + Mank;
        end;
      end;

      UpdateProgress(2, 3);
      Res := addIndex.Execute;

      if Res = 0 then
      begin
        addIndex.Clear;

        // Index 12 - Year+Period+DocPRef (IdYrPrK)
        addIndex.UseAltColSeq := True;
        addIndex.IndexNumber := addIndex.IndexNumber + 1;
        with addIndex.AddSegment do
        begin
          KeyPosition  := BtKeyPos (@Id.PYr, @Id);
          KeyLength    := SizeOf (Id.PYr);
          KeyFlags     := DupModSeg + ExtType + Mank;
          ExtendedType := BInteger;
        end;
        with addIndex.AddSegment do
        begin
          KeyPosition  := BtKeyPos (@Id.PPr, @Id);
          KeyLength    := SizeOf (Id.PPr);
          KeyFlags     := DupModSeg + ExtType + Mank;
          ExtendedType := BInteger;
        end;
        with addIndex.AddSegment do
        begin
          KeyPosition := BtKeyPos (@Id.DocPRef[1], @Id);
          KeyLength   := SizeOf (Id.DocPRef) - 1;
          KeyFlags    := DupMod + Mank;
        end;
      end;

      UpdateProgress(3, 3);
      Res := addIndex.Execute;
    end;
  Finally
    FResult := Res;
    if Res <> 0 then
      FErrStr := Format('Error %d occurred while creating index %d', [Res, addIndex.IndexNumber]);
    addIndex.Free;
  End;

end;

procedure TfrmIdxProgress.UpdateProgress(IdxNo, IdxTotal: Integer);
begin
  lblIndexNo.Caption := Format('Adding Index %d of %d', [IdxNo, IdxTotal]);
  lblIndexNo.Refresh;
  Application.ProcessMessages;
end;

end.
