unit CompWiz6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls;

type
  TGroupDetails = Class(TObject)
  Private
    FCode : ShortString;
    FDesc : ShortString;
  Public
    Property caCode : ShortString Read FCode;
    Property caDescription : ShortString Read FDesc;

    Constructor Create (Code, Desc : ShortString);
  End; // TGroupDetails

  //------------------------------

  TfrmCompWizStockCats = class(TSetupTemplate)
    Label1: TLabel;
    edtCategory1: TEdit;
    Label2: TLabel;
    edtCategory2: TEdit;
    Label3: TLabel;
    edtCategory3: TEdit;
    Label4: TLabel;
    edtCategory4: TEdit;
    Label5: TLabel;
    edtCategory5: TEdit;
    Label6: TLabel;
    edtCategory6: TEdit;
    Label7: TLabel;
    edtCategory7: TEdit;
    Label8: TLabel;
    edtCategory8: TEdit;
    Label9: TLabel;
    edtCategory9: TEdit;
    Label10: TLabel;
    edtCategory10: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    edtCategoryDesc1: TEdit;
    edtCategoryDesc2: TEdit;
    edtCategoryDesc3: TEdit;
    edtCategoryDesc4: TEdit;
    edtCategoryDesc5: TEdit;
    edtCategoryDesc6: TEdit;
    edtCategoryDesc7: TEdit;
    edtCategoryDesc8: TEdit;
    edtCategoryDesc9: TEdit;
    edtCategoryDesc10: TEdit;
    Label21: TLabel;
    Label22: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FCatList : TList;

    Function GetCount : SmallInt;
    Function GetGroups(Index : SmallInt) : TGroupDetails;

    Procedure ClearCatList;
    Function ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
    Property GroupCount : SmallInt Read GetCount;
    Property Groups [Index : SmallInt] : TGroupDetails Read GetGroups;
  end;


implementation

{$R *.dfm}

Uses Brand;

//=========================================================================

Constructor TGroupDetails.Create (Code, Desc : ShortString);
Begin // Create
  Inherited Create;

  FCode := UpperCase(Trim(Code));
  FDesc := Trim(Desc);
End; // Create

//=========================================================================

procedure TfrmCompWizStockCats.FormCreate(Sender: TObject);
begin
  inherited;

  FCatList := TList.Create;

  If Branding.BrandingFileExists(ebfSetup) Then
  Begin
    With Branding.BrandingFile(ebfSetup) Do
    Begin
      edtCategory1.Text := pbfData.GetString('StockCatCode1');
      edtCategoryDesc1.Text := pbfData.GetString('StockCatDesc1');
      edtCategory2.Text := pbfData.GetString('StockCatCode2');
      edtCategoryDesc2.Text := pbfData.GetString('StockCatDesc2');
      edtCategory3.Text := pbfData.GetString('StockCatCode3');
      edtCategoryDesc3.Text := pbfData.GetString('StockCatDesc3');
      edtCategory4.Text := pbfData.GetString('StockCatCode4');
      edtCategoryDesc4.Text := pbfData.GetString('StockCatDesc4');
      edtCategory5.Text := pbfData.GetString('StockCatCode5');
      edtCategoryDesc5.Text := pbfData.GetString('StockCatDesc5');
      edtCategory6.Text := pbfData.GetString('StockCatCode6');
      edtCategoryDesc6.Text := pbfData.GetString('StockCatDesc6');
      edtCategory7.Text := pbfData.GetString('StockCatCode7');
      edtCategoryDesc7.Text := pbfData.GetString('StockCatDesc7');
      edtCategory8.Text := pbfData.GetString('StockCatCode8');
      edtCategoryDesc8.Text := pbfData.GetString('StockCatDesc8');
      edtCategory9.Text := pbfData.GetString('StockCatCode9');
      edtCategoryDesc9.Text := pbfData.GetString('StockCatDesc9');
      edtCategory10.Text := pbfData.GetString('StockCatCode10');
      edtCategoryDesc10.Text := pbfData.GetString('StockCatDesc10');
    End; // With Branding.BrandingFile(ebfSetup)
  End; // If Branding.BrandingFileExists(ebfSetup)
end;

//------------------------------

procedure TfrmCompWizStockCats.FormDestroy(Sender: TObject);
begin
  inherited;

  ClearCatList;
  FreeAndNIL(FCatList);
end;

//-------------------------------------------------------------------------

Procedure TfrmCompWizStockCats.ClearCatList;
Var
  oCatDets : TGroupDetails;
Begin // ClearCatList
  While (FCatList.Count > 0) Do
  Begin
    oCatDets := TGroupDetails(FCatList[0]);
    oCatDets.Free;
    FCatList.Delete(0);
  End; // While (FCatList.Count > 0)
End; // ClearCatList

//-------------------------------------------------------------------------

Function TfrmCompWizStockCats.GetCount : SmallInt;
Begin // GetCount
  Result := FCatList.Count;
End; // GetCount

//------------------------------

Function TfrmCompWizStockCats.GetGroups(Index : SmallInt) : TGroupDetails;
Begin // GetGroups
  If (Index >= 0) And (Index < FCatList.Count) Then
  Begin
    Result := TGroupDetails(FCatList[Index]);
  End // If (Index >= 0) And (Index < FCatList.Count)
  Else
    Raise Exception.Create ('TfrmCompWizStockCats.GetGroups: Invalid Group Index (' + IntToStr(Index) + ')');
End; // GetGroups

//-------------------------------------------------------------------------

function TfrmCompWizStockCats.ValidOk(VCode: Char): Boolean;
Var
  Cats, Descs : TStringList;

  Procedure ValidateCatFields (Const Cats, Descs : TStringList; CatField, DescField : TEdit);
  Var
    NewCat, NewDesc : ShortString;
  Begin // ValidateCatFields
    NewCat  := UpperCase(Trim(CatField.Text));
    NewDesc := Trim(DescField.Text);

    // Code - If set must be unique, can be blank
    If (NewCat <> '') Then
    Begin
      If (Cats.IndexOf(NewCat) = -1) Then
        Cats.Add(NewCat)
      Else
      Begin
        If CatField.CanFocus Then CatField.SetFocus;
        Raise Exception.Create (QuotedStr(NewCat) + ' has already been used as a Group Code');
      End; // Else

      // Description - must be set and must be unique
      If (NewDesc <> '') Then
      Begin
        If (Descs.IndexOf(NewDesc) = -1) Then
        Begin
          Descs.Add(NewDesc);

          // AOK - Add into public Groups list
          FCatList.Add(TGroupDetails.Create(NewCat, NewDesc));
        End // If (Descs.IndexOf(NewDesc) = -1)
        Else
        Begin
          If DescField.CanFocus Then DescField.SetFocus;
          Raise Exception.Create (QuotedStr(NewDesc) + ' has already been used as a Group Description');
        End; // Else
      End // If (NewDesc <> '')
      Else
      Begin
        If DescField.CanFocus Then DescField.SetFocus;
        Raise Exception.Create ('The Group Description cannot be left blank if the Group Code has been set');
      End; // Else
    End // If (NewCat <> '')
    Else
    Begin
      // No code - check description is blank
      If (NewDesc <> '') Then
      Begin
        If CatField.CanFocus Then CatField.SetFocus;
        Raise Exception.Create ('No Group Code has been defined for the Group Description ' + QuotedStr(NewDesc) +
                                ' either delete the Description or specify a valid Group Code');
      End; // If (NewDesc <> '')
    End; // Else
  End; // ValidateCatFields

begin
  If (VCode = 'N') Then
  Begin
    Result := False;

    // Remove any Groups from previous passes through this section
    ClearCatList;

    // Validate Stock Codes
    Cats := TStringList.Create;
    Descs := TStringList.Create;
    Try
      Try
        // Validate the fields and build up the Cats/Descs lists of valid Groups, validation
        // errors are raised as exceptions
        ValidateCatFields (Cats, Descs, edtCategory1,  edtCategoryDesc1);
        ValidateCatFields (Cats, Descs, edtCategory2,  edtCategoryDesc2);
        ValidateCatFields (Cats, Descs, edtCategory3,  edtCategoryDesc3);
        ValidateCatFields (Cats, Descs, edtCategory4,  edtCategoryDesc4);
        ValidateCatFields (Cats, Descs, edtCategory5,  edtCategoryDesc5);
        ValidateCatFields (Cats, Descs, edtCategory6,  edtCategoryDesc6);
        ValidateCatFields (Cats, Descs, edtCategory7,  edtCategoryDesc7);
        ValidateCatFields (Cats, Descs, edtCategory8,  edtCategoryDesc8);
        ValidateCatFields (Cats, Descs, edtCategory9,  edtCategoryDesc9);
        ValidateCatFields (Cats, Descs, edtCategory10, edtCategoryDesc10);

        // Must have at least 1 Group defined
        Result := (FCatList.Count > 0);

        If (Not Result) Then
        Begin
          If edtCategory1.CanFocus Then edtCategory1.SetFocus;
          Raise Exception.Create('At least one Stock Group must be defined');
        End; // If (Not Result)
      Except
        On E:Exception Do
          MessageDlg (E.Message, mtError, [mbOK], 0);
      End; // Try..Except
    Finally
      FreeAndNIL(Cats);
      FreeAndNIL(Descs);
    End; // Try..Finally
  End { If }
  Else
    Result := True;
end;

//-------------------------------------------------------------------------

end.
