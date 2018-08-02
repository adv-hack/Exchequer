unit IniU;

interface

Uses
  Classes, Dialogs, Forms, IniFiles, Messages, SysUtils, FileUtil, Windows, CustAbsU;

Type
  TChargeBand = Class(TObject)
  Public
    cbNo     : Byte;
    cbWeight : Double;
    cbCharge : Double;
  End; { TChargeBand }

  TCarrier = Class(TObject)
  Private
    FCalcMethod  : Byte;
    FLineDesc    : String[60];
    FLoaded      : Boolean;
    FName        : String[60];
    FSectionName : String[20];
    FSet         : Boolean;

    FMinWeight   : Double;
    FMinCharge   : Double;
    FUnitRate    : Double;

    FChargeBands : TList;

    Function GetDesc : ShortString;
    Function GetName : ShortString;
    Procedure LoadChargeDets (Const EventData : TAbsEnterpriseSystem);
  Public
    Constructor Create (Const CarrierNo : Byte; IniF : TIniFile);
    Destructor Destroy; OverRide;

    Property caCalcMethod : Byte Read FCalcMethod;
    Property caLineDesc : ShortString Read GetDesc;
    Property caName : ShortString Read GetName;
    Property caSet  : Boolean Read FSet;

    Function  CalcCharge (Const EventData : TAbsEnterpriseSystem; Const TotWeight : Double) : Double;
    {$IFDEF TEST}
    Procedure GetChargeDets (StrList : TStrings);
    {$ENDIF}
  End; { TCarrier }

  IniLineDets = Record
    ilGLCode   : LongInt;
    ilCostC    : String[3];
    ilDept     : String[3];
    ilVATCode  : Char;
    ilLocation : String[3];
    ilTriggerOnAllOrders : boolean;
    ilTriggerOnAllQuotes : boolean;
  End; { IniLineDets }

Var
  Carriers   : Array [1..6] Of TCarrier;
  IniLine    : ^IniLineDets;

Function LoadINI : Boolean;

implementation

Uses ChainU;

Var
  I : Byte;

{ Allocates memory and creates cache of .INI file info }
Function LoadINI : Boolean;
Var
  IniF : TIniFile;
  I    : Byte;
Begin { LoadINI }
  {Result := FileExists (ExtractFilePath(Application.ExeName) + 'COMPOSIT.INI');}
//  Result := FileExists (ExtractFilePath(Application.ExeName) + DLLChain.ModuleName + '.INI');
  Result := FileExists (GetEnterpriseDirectory + DLLChain.ModuleName + '.INI');

  { Check .INI File Exists }
  If Result Then Begin
    {IniF := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'COMPOSIT.INI');}
//    IniF := TIniFile.Create(ExtractFilePath(Application.ExeName) + DLLChain.ModuleName + '.INI');
    IniF := TIniFile.Create(GetEnterpriseDirectory + DLLChain.ModuleName + '.INI');

    Try
      { Get Invoice Line details }
      New (IniLine);
      With IniLine^ Do Begin
        ilGLCode   := IniF.ReadInteger('TransLineDets', 'GLCode', 0);
        ilCostC    := IniF.ReadString('TransLineDets', 'CostCentre', '');
        ilDept     := IniF.ReadString('TransLineDets', 'Department', '');
        ilVATCode  := Copy (IniF.ReadString  ('TransLineDets', 'VATCode', 'S'), 1, 1)[1];
        ilLocation := IniF.ReadString('TransLineDets', 'Location', '');
        ilTriggerOnAllOrders := Trim(UpperCase(IniF.ReadString('Settings', 'Order', 'P'))) = 'A';
        ilTriggerOnAllQuotes := Trim(UpperCase(IniF.ReadString('Settings', 'Quote', 'N'))) = 'Y';
      End; { With }

      { Create Carriers Array }
      For I := Low(Carriers) To High(Carriers) Do Begin
        Carriers[I] := TCarrier.Create(I, IniF);
      End; { For }
    Finally
      IniF.Destroy;
    End;
  End; { If }
End;  { LoadINI }

{ Deallocates any memory/objects assigned/created }
Procedure TidyUp;
Var
  I : Byte;
Begin { LoadINI }
  If Assigned(IniLine) Then Begin
    { Remove Line cache }
    Dispose (IniLine);

    { Free Carrier Objects }
    For I := Low(Carriers) To High(Carriers) Do Begin
      If Assigned(Carriers[I]) Then
        Carriers[I].Destroy;
    End; { For }
  End; { If }
End;  { LoadINI }

{---------------------------------------------------------------------------}


Constructor TCarrier.Create (Const CarrierNo : Byte; IniF : TIniFile);
Var
  CMethod : LongInt;
Begin { Create }
  Inherited Create;

  FCalcMethod := 0;
  FLoaded := False;
  FMinWeight := 0.0;
  FMinCharge := 0.0;
  FUnitRate := 0.0;
  FChargeBands := Nil;

  { Generate SectionName }
  FSectionName := 'Carrier' + IntToStr(CarrierNo);

  { Get Carrier Name from .INI File }
  FName := Trim(IniF.ReadString(FSectionName, 'Name', ''));
  FSet := (FName <> '');

  If FSet Then Begin
    { Get and Validate the Calculation Method }
    CMethod := IniF.ReadInteger(FSectionName, 'CalcMethod', 0);
    If (CMethod >= 1) And (CMethod <= 2) Then Begin
      { AOK - copy into property }
      FCalcMethod := CMethod
    End { If }
    Else Begin
      { Invalid method }
      FSet := False;
      MessageDlg (FSectionName + ' ''' + FName + ''' has an invalid calculation ' +
                  'method: ' + IntToStr(CMethod), mtError, [mbOk], 0);
    End; { Else }
  End; { If }
End;  { Create }


Destructor TCarrier.Destroy;
Var
  LookupO : TChargeBand;
Begin { Destroy }
  If Assigned(FChargeBands) Then Begin
    While (FChargeBands.Count > 0) Do Begin
      { Get local copy of object }
      LookupO := FChargeBands.Items[0];

      { Delete from list }
      FChargeBands.Delete (0);

      { Destroy Object }
      LookupO.Destroy;
    End; { While }
  End; { If }

  Inherited Destroy;
End;  { Destroy }


Function TCarrier.GetName : ShortString;
Begin { GetName}
  Result := FName;
End;  { GetName }


Function TCarrier.GetDesc : ShortString;
Begin { GetName}
  Result := FLineDesc;
End;  { GetName }


Procedure TCarrier.LoadChargeDets (Const EventData : TAbsEnterpriseSystem);
Var
  IniF             : TIniFile;
  BandW, BandC     : Double;
  BandObj, LookupO : TChargeBand;
  I, J             : Byte;

  Function ReadDouble (Const ItemName : ShortString; Const Decs : Byte) : Double;
  Var
    DblStr : ShortString;
  Begin { ReadDouble }
    Result := 0.0;

    DblStr := Trim(IniF.ReadString (FSectionName, ItemName, '0.0'));

    If (DblStr <> '') Then Begin
      { Convert to double }
      Result := EventData.entRound(StrToFloat(DblStr), Decs);
    End;  { If }
  End;  { ReadDouble }

Begin { LoadChargeDets }
  If FSet And (Not FLoaded) Then Begin
    {IniF := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'COMPOSIT.INI');}
//    IniF := TIniFile.Create(ExtractFilePath(Application.ExeName) + DLLChain.ModuleName + '.INI');
    IniF := TIniFile.Create(GetEnterpriseDirectory + DLLChain.ModuleName + '.INI');

    Try
      FLineDesc := IniF.ReadString (FSectionName, 'LineDesc', '');

      Case FCalcMethod Of
        1 : Begin { Min Weight + Unit increment }
              FMinWeight := ReadDouble ('MinWeight', 3);
              FMinCharge := ReadDouble ('MinCharge', 2);
              FUnitRate  := ReadDouble ('UnitRate', 4);

              FLoaded := (FMinWeight >= 0.0) And (FMinCharge >= 0.0) And (FUnitRate >= 0.0);
            End;

        2 : Begin { Weight Ranges }
              FChargeBands := TList.Create;

              For I := 1 To 100 Do Begin
                BandW := ReadDouble ('WeightBand' + IntToStr(I), 3);
                BandC := ReadDouble ('BandCost' + IntToStr(I), 2);

                If (BandW > 0.0) Or (BandC > 0.0) Then Begin
                  { Create list object }
                  BandObj := TChargeBand.Create;
                  With BandObj Do Begin
                    cbNo     := I;
                    cbWeight := BandW;
                    cbCharge := BandC;
                  End; { With }

                  { Add into list of Bands }
                  If (FChargeBands.Count = 0) Then Begin
                    { List is empty - add }
                    FChargeBands.Add (BandObj);
                  End { If }
                  Else Begin
                    { Find Correct position - check end first }
                    For J := 0 To Pred(FChargeBands.Count) Do Begin
                      LookupO := FChargeBands.Items[J];

                      If (LookupO.cbWeight >= BandObj.cbWeight) Then Begin
                        { Insert Before }
                        FChargeBands.Insert (J, BandObj);
                        Break;
                      End { If }
                      Else
                        If (J = Pred(FChargeBands.Count)) Then Begin
                          { End Of List - add to end }
                          FChargeBands.Add (BandObj);
                        End; { If }
                    End; { For }
                  End; { Else }
                End; { If }
              End; { For }

              FLoaded := (FChargeBands.Count > 0);
            End;
      End; { Case }
    Finally
      IniF.Destroy;
    End;
  End; { If }
End;  { LoadChargeDets }

{$IFDEF TEST}
Procedure TCarrier.GetChargeDets (StrList : TStrings);
Var
  LookupO : TChargeBand;
  I       : Byte;
Begin { GetChargeDets }
  With StrList Do Begin
    Add ('Line Desc:' + #9 + FLineDesc);

    Case caCalcMethod Of
      1 : Begin { Min Weight + Unit increment }
            Add ('Min Weight:' + #9 + Format('%30.15f', [FMinWeight]));
            Add ('Min Charge:' + #9 + Format('%30.15f', [FMinCharge]));
            Add ('Unit Rate:' + #9 + Format('%30.15f', [FUnitRate]));
          End;
      2 : Begin { Weight Ranges }
            If Assigned(FChargeBands) Then Begin
              If (FChargeBands.Count > 0) Then Begin
                Add (Format('Bands: %3d', [FChargeBands.Count]));
                For I := 0 To Pred(FChargeBands.Count) Do Begin
                  LookupO := FChargeBands.Items[I];

                  With LookupO Do
                    Add (Format('%3d: %30.15f %30.15f', [cbNo, cbWeight, cbCharge]));
                End; { For }
              End; { If }
            End; { If }
          End;
    End; { Case }
  End; { With }
End;  { GetChargeDets }
{$ENDIF}


Function TCarrier.CalcCharge (Const EventData : TAbsEnterpriseSystem; Const TotWeight : Double) : Double;
Var
  LookupO : TChargeBand;
  I       : Byte;
Begin { CalcCharge }
  Result := -1;

  If FSet Then Begin
    If (Not FLoaded) Then
      LoadChargeDets(EventData);

    If FLoaded Then Begin
      Case FCalcMethod Of
        1 : Begin { Min Weight + Unit increment }
              { Always need basic charge }
              Result := FMinCharge;

              If (TotWeight > FMinWeight) Then Begin
                { Calculation additional unit weights charge }
                Result := Result + EventData.entRound((TotWeight - FMinWeight) * FUnitRate, 2);
              End; { If }
            End;

        2 : Begin { Weight Ranges }
              Result := 0.0;

              If (FChargeBands.Count > 0) Then Begin
                For I := 0 To Pred(FChargeBands.Count) Do Begin
                  LookupO := FChargeBands.Items[I];

                  If (LookupO.cbWeight > TotWeight) Then Begin
                    { Use Previous Band }
                    If (I > 0) Then Begin
                      LookupO := FChargeBands.Items[I - 1];
                      Result := LookupO.cbCharge;
                    End; { If }
                    Break;
                  End { If }
                  Else
                    If (I = Pred(FChargeBands.Count)) Then Begin
                      { Last band - always use }
                      Result := LookupO.cbCharge;
                    End; { IF }
                End; { For }
              End; { If }
            End;
      End; { Case }
    End { If }
    Else Begin
      { Cannot load charge details }
      MessageDlg (FSectionName + ' ''' + FName + ''' Charge Details cannot be loaded',
                  mtError, [mbOk], 0);
    End; { Else }
  End; { If }
End;  { CalcCharge }


Initialization
  { Initialise Line cache object to Nil }
  IniLine := Nil;

  { Initialise Carrier handles to Nil }
  For I := Low(Carriers) To High(Carriers) Do Begin
    Carriers[I] := Nil;
  End; { For }
Finalization
  { De-allocate any assigned memory/classes }
  TidyUp;
end.
