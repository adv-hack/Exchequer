unit uWRSpecESN;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompButton, IWCompLabel, IWCompEdit,
  Classes, Controls, IWControl, IWCompText, IWLayoutMgr,
  IWTemplateProcessorHTML;

type
  TfrmSpecESN = class(TIWAppForm)
    txtESN: TIWText;
    edESN: TIWEdit;
    lblESN: TIWLabel;
    lblNewESN: TIWLabel;
    bnSaveChanges: TIWButton;
    bnCancel: TIWButton;
    TemplateProcessor: TIWTemplateProcessorHTML;
    procedure bnCancelClick(Sender: TObject);
    procedure bnSaveChangesClick(Sender: TObject);
  private
    procedure EmailHQ(const ssESN : ShortString);
    procedure SetDummyESN;
    procedure UpdateESN;
  public
    DummyESN: boolean;
    procedure InitControls;
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRSite, uWRData, SysUtils;

//*** Event Handlers ***********************************************************

procedure TfrmSpecESN.bnCancelClick(Sender: TObject);
begin
  {Return to the site page;}

  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmSpecESN.bnSaveChangesClick(Sender: TObject);
begin
  {This page is used for one of two purposes; Specifiying a new ESN for permanent
   use by a customer, or for specifying a temporary 'Dummy' ESN for use by internal
   staff; Branch to the appropriate code;}

  if not UserSession.isValidESN(Trim(edESN.Text)) then
    WebApplication.ShowMessage('The ESN you have entered is invalid. Please enter a valid ESN.')
  else if DummyESN then
    SetDummyESN
  else
    UpdateESN;
end;

procedure TfrmSpecESN.SetDummyESN;
begin
  {Initialise the dummy session variables, set the new ESN within the UserSession
   and display the relevant internal pages;}

  with UserSession, WRData.qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select * from usergroups where groupid = 1 and parentid = 0 ');
    Open;

    if not eof then DealerName:= FieldByName('GroupDesc').AsString;
    CustName:= 'Dummy';
    ESN:= GetESN(Trim(edESN.Text));

    DealerID:= 1;
    CustID:= 0;
    ESNID:= 0;

     // AB
    bUsingDummyESN := TRUE;

    ShowPages;
  end;
end;

procedure TfrmSpecESN.UpdateESN;
var
  ValidESN: boolean;

  function isPartialESN(const ESN : ShortString) : boolean;
  const
    ESN_SEGMENTS = 6;
  var
    PosHyphen, Idx : SmallInt;
    aSegments : array[1..ESN_SEGMENTS] of ShortString;
    ssESN : ShortString;
  begin
    ssESN := ESN;
    if (length(trim(ssESN)) > 0 ) then
    begin
      // This loop extracts all segments of the ESN.
      for Idx := 1 to ESN_SEGMENTS do
      begin
        PosHyphen := Pos('-',ssESN);
        if (PosHyphen > 0) and (Length(ssESN) > 0) then
        begin
          aSegments[Idx] := Copy(ssESN,1,PosHyphen-1);
          Delete(ssESN,1,PosHyphen);
        end
        else
        begin
          aSegments[Idx] := ssESN; // This is for the last ESN segment.
        end;
      end; // for Idx := 1 to ESN_SEGMENTS do

      // Partial ESNs are defined as EITHER segment 1 OR 4 are non-zero.
      // ALL the other segments, 2, 3, 5 and 6 are all ZERO.
      if (((aSegments[1] <> '000') or (aSegments[4] <> '000')) and
         ((aSegments[2] = '000') and (aSegments[3] = '000') and
          (aSegments[5] = '000') and (aSegments[6] = '000'))) then
        Result := TRUE
      else
        Result := FALSE;

    end // if (length(trim(ssESN)) > 0 ) then
    else
      Result := TRUE;
  end; // function isPartialESN(const ESN : ShortString) : boolean; - local function

begin
  {Only proceed for valid ESNs; Update the unspecified esn with the provided esn
   and set unspecified to false; Notify the appropriate internal user that the
   ESN has been specified; Show the user the first page they have permissions
   for, and notify them that the ESN update was successful;}

  ValidESN:= (Length(Trim(edESN.Text)) = 21) or (Length(Trim(edESN.Text)) = 27);

  if (Trim(edESN.Text) = '') or (not(ValidESN)) or (isPartialESN(trim(edESN.Text))) then
  begin
    WebApplication.ShowMessage('Please specify a valid ESN.');
    Exit;
  end;

  with WRData, qyPrimary, UserSession do
  begin
    Close;
    Sql.Clear;
    Sql.Add('update esns set esn = :pesn, unspecified = 0 ');
    Sql.Add('where esnid = :pesnid ');
    ParamByName('pesn').AsString:= GetESN(Trim(edESN.Text));
    ParamByName('pesnid').AsInteger:= ESNID;
    ExecSql;

    ESN:= GetESN(Trim(edESN.Text));
    EmailHQ(ESN);
  end;

  UserSession.ShowPages;
  WebApplication.ShowMessage('The ESN has been updated succesfully.');

  Release;
end;

procedure TfrmSpecESN.InitControls;
begin
  if DummyESN then
  begin
    lblNewESN.Caption:= 'Dummy ESN';
    txtESN.Lines.Add('Please enter the dummy ESN.');
    bnSaveChanges.Caption:= 'Confirm';
  end
  else
  begin
    lblNewESN.Caption:= 'New ESN';
    txtESN.Lines.Add('Please enter the new ESN.');
    bnSaveChanges.Caption:= 'Save Changes';
  end;
end;

//*** Form Methods *************************************************************

procedure TfrmSpecESN.EmailHQ(const ssESN : ShortString);
begin
  // AB - 3 
  {Notify the appropriate internal user that the ESN has been specified;}
  if UserSession.ESNSpecifiedRecipient.Active then
    UserSession.EmailESN(ssESN);
end;

//******************************************************************************

end.
