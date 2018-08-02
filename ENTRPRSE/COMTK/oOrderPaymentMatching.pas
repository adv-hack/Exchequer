unit oOrderPaymentMatching;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, ExBTTH1U, GlobList, EnterpriseBeta_TLB, ExceptIntf;

type

  TMatchDetails = Class
    Matching : MatchPayType;
  end;

  TOrderPaymentMatchingList = class(TAutoIntfObjectEx, IOrderPaymentMatchingList)
  private
    procedure SetOurRef(const Value: string);
  protected
    FToolkit : TObject;
    FBtrIntf : TCtkTdPostExLocalPtr;
    FList : TStringList;
    FOurRef : string;
    function Get_opmCount: Integer; safecall;
    function Get_opmMatch(Index: Integer): IMatching; safecall;
    procedure LoadList; virtual; abstract;
    procedure ResetList; 
  public
    constructor Create(const OurRef : string;
                       const Toolkit  : TObject;
                       const BtrIntf  : TCtkTdPostExLocalPtr);
    property OurRef : string Read FOurRef Write SetOurRef;

    destructor Destroy; override;
  end;

  TPervasiveOrderPaymentMatchingList = Class(TOrderPaymentMatchingList)
  protected
    procedure LoadList; override;
  end;

  TMSSQLOrderPaymentMatchingList = Class(TOrderPaymentMatchingList)
  protected
    procedure LoadList; override;
  end;

implementation

uses
  ComServ, oMatch, SQLCallerU, DB, SQLUtils, ADOConnect;

{ TOrderPaymentMatchingList }

constructor TOrderPaymentMatchingList.Create(const OurRef: string;
  const Toolkit: TObject; const BtrIntf: TCtkTdPostExLocalPtr);
begin
  Inherited Create (ComServer.TypeLib, IOrderPaymentMatchingList);

  FOurRef := OurRef;
  FBtrIntf := BtrIntf;

  FList := TStringList.Create;
  FList.Sorted := True;
  FList.Duplicates := dupAccept;

  LoadList;
end;

destructor TOrderPaymentMatchingList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TOrderPaymentMatchingList.Get_opmCount: Integer;
begin
  Result := FList.Count;
end;

function TOrderPaymentMatchingList.Get_opmMatch(Index: Integer): IMatching;
begin
  if (Index >= 1) And (Index <= FList.Count) then
    Result := TMatching.CreateAsClone(TMatchDetails(FList.Objects[Index-1]).Matching, FToolkit, FBtrIntf) as IMatching
  else
    Raise ERangeError.Create ('opmMatch Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FList.Count) + ')');
end;

{ TPervasiceOrderPaymentMatchingList }

procedure TPervasiveOrderPaymentMatchingList.LoadList;
var
  Res : Integer;
  KeyS, KeyChk : Str255;
  CurrentIndex : Integer;
  MatchDetails : TMatchDetails;
  RefString : string;
begin
  ResetList;

  with FBtrIntf^ do
  begin
    for CurrentIndex := 0 to 1 do
    begin
      KeyS := MatchTCode + MatchOrderPaymentCode + FOurRef;
      KeyChk := Trim(KeyS);

      Res := LFind_Rec(B_GetGEq, PWrdF, CurrentIndex, KeyS);

      while (Res = 0) and (Trim(KeyS) = KeyChk) do
      begin
        //Add record to list
        MatchDetails := TMatchDetails.Create;
        with MatchDetails do
        begin
          MatchDetails.Matching := LPassword.MatchPayRec;

          if Matching.PayRef = FOurRef then
            RefString := Matching.DocCode
          else
            RefString := Matching.PayRef;

          FList.AddObject(RefString, MatchDetails);
        end; //with MatchDetails

        //Next Record
        Res := LFind_Rec(B_GetNext, PWrdF, CurrentIndex, KeyS);
      end;
    end;
  end;
end;

procedure TOrderPaymentMatchingList.ResetList;
var
  i : Integer;
begin
  for i := 0 to FList.Count - 1 do
    FList.Objects[i].Free;
  FList.Clear;
end;

procedure TOrderPaymentMatchingList.SetOurRef(const Value: string);
begin
  //If we're changing transactions then we need to clear and reload the list
  if FOurRef <> Value then
  begin
    FOurRef := Value;
    LoadList;
  end;
end;

{ TMSSQLOrderPaymentMatchingList }


procedure TMSSQLOrderPaymentMatchingList.LoadList;
var
  fldDocRef, fldPayRef : TStringField;
  fldSettledVal, fldOwnCVal, fldRecOwnCVal : TFloatField;
  fldMCurrency, fldRCurrency : TIntegerField;
  sQuery, sConnection, sCompanyCode : AnsiString;
  MatchDetails : TMatchDetails;
  KeyS : String;
  SQLCaller : TSQLCaller;

begin
  ResetList;

  //RB 22/08/2017 2017-R2 ABSEXCH-18933: Fix SQL connection failure issue in Toolkits
  //Use Global Connection
  SQLCaller := TSQLCaller.Create(GlobalAdoConnection);
  sCompanyCode := SQLUtils.GetCompanyCode(SetDrive);

  sQuery := Format('Select DocRef, PayRef, SettledVal, OwnCVal, MCurrency, RCurrency, RecOwnCVal ' +
                   'From [COMPANY].[OrderPaymentsMatching] where DocRef = %s or PayRef = %s',
                   [QuotedStr(FOurRef), QuotedStr(FOurRef)]);

  SQLCaller.Select(sQuery, sCompanyCode);
  If (SQLCaller.ErrorMsg = '') Then
  Begin
    If (sqlCaller.Records.RecordCount > 0) Then
    Begin
      // Disable the link to the UI to improve performance when iterating through the dataset
      sqlCaller.Records.DisableControls;
      Try
        // Prepare fields
        fldDocRef := sqlCaller.Records.FieldByName('DocRef') As TStringField;
        fldPayRef := sqlCaller.Records.FieldByName('PayRef') As TStringField;
        fldSettledVal := sqlCaller.Records.FieldByName('SettledVal') As TFloatField;
        fldOwnCVal := sqlCaller.Records.FieldByName('OwnCVal') As TFloatField;
        fldMCurrency := sqlCaller.Records.FieldByName('MCurrency') As TIntegerField;
        fldRCurrency := sqlCaller.Records.FieldByName('RCurrency') As TIntegerField;
        fldRecOwnCVal := sqlCaller.Records.FieldByName('RecOwnCVal') As TFloatField;

        sqlCaller.Records.First;
        While (Not sqlCaller.Records.EOF)  Do
        Begin
          MatchDetails := TMatchDetails.Create;
          with MatchDetails do
          begin
            FillChar(Matching, SizeOf(Matching), #0);
            Matching.DocCode := fldDocRef.Value;
            Matching.PayRef := fldPayRef.Value;
            Matching.SettledVal := fldSettledVal.Value;
            Matching.OwnCVal := fldOwnCVal.Value;
            Matching.MCurrency := fldMCurrency.Value;
            Matching.RCurrency := fldRCurrency.Value;
            Matching.RecOwnCVal := fldRecOwnCVal.Value;

            if Matching.PayRef = FOurRef then
              KeyS := Matching.DocCode
            else
              KeyS := Matching.PayRef;

            FList.AddObject(KeyS, MatchDetails);
          end;
          sqlCaller.Records.Next;
        End; // While (Not sqlCaller.Records.EOF) And (Status = 0) And KeepRun
      Finally
        sqlCaller.Records.EnableControls;
        sqlCaller.Close;
        SQLCaller.Free;
      End; // Try..Finally
    End; // If (sqlCaller.Records.RecordCount > 0)
  End; // If (SQLCaller.ErrorMsg = '')
end;

end.
