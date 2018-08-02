unit CopyDatF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, BorBtns;

type
  TCopyDataWiz1 = class(TSetupTemplate)
    CompList: TListBox;
    rad_Blank: TBorRadio;
    rad_Copy: TBorRadio;
    procedure rad_CopyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Function GetCompCode : ShortString;
    Function GetCompName : ShortString;
    Function GetCompPath : ShortString;
    Function GetWantCopy : Boolean;
    Function ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
    Property CompanyCode : ShortString read GetCompCode;
    Property CompanyName : ShortString read GetCompName;
    Property CompanyPath : ShortString read GetCompPath;
    Property WantCopy : Boolean Read GetWantCopy;

    procedure LoadCompanies(Const CurrentCompanyPath : ShortString);
  end;

implementation

{$R *.DFM}

Uses GlobVar, VarConst, VarFPosU, BtrvU2, EntRegU;

Type
  TListObj = Class(TObject)
    Company : CompRec;
  End; { TListObj }

procedure TCopyDataWiz1.LoadCompanies(Const CurrentCompanyPath : ShortString);
Const
  FNum = CompF;
  KeyPath : Integer = CompCodeK;
Var
  CompObj : TListObj;
  KeyS    : Str255;
begin
  { Load Companies into list }
  Status:=Find_Rec(B_GetFirst,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  While StatusOk Do Begin
    With Company^, CompDet Do
      // MH 06/02/2008: Added check on the path to allow the current company to be removed from the list under SQL
      If (RecPFix = cmCompDet) And (Trim(UpperCase(CompPath)) <> CurrentCompanyPath) Then
      Begin
        {CompList.Items.Add (CompCode + #9 + CompName);}

        CompObj := TListObj.Create;
        CompObj.Company := Company^;
        CompList.Items.AddObject(Trim(CompCode) + #9 + CompName, CompObj);
      End; { If }

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  End; { While }
  If (CompList.Items.Count > 0) Then
    CompList.ItemIndex := 0
  Else
    { no companies }
    DllStatus := 1;

  rad_CopyClick(Self);
end;

Function TCopyDataWiz1.GetWantCopy : Boolean;
Begin
  Result := (Rad_Copy.Checked) And (CompList.ItemIndex >= 0);
End;

procedure TCopyDataWiz1.rad_CopyClick(Sender: TObject);
begin
  inherited;

  CompList.Enabled := Rad_Copy.Checked;

  If Rad_Copy.Checked Then
    NextBtn.Caption := '&Next >>'
  Else
    NextBtn.Caption := '&Finish';
end;

{ Returns True if all entry fields are ok }
Function TCopyDataWiz1.ValidOk(VCode : Char) : Boolean;
Begin
  If (VCode = 'N') Then Begin
    If rad_Copy.Checked Then
      Result := (CompList.ItemIndex >= 0)
    Else Begin
      Result := (MessageDlg ('You have selected NOT to copy data into the ' +
                             'new company from another existing company.' +
                             #10#13#10#13 +
                             'Is this correct?', mtConfirmation, [mbYes, mbNo], 19) = mrYes);
    End; { Else }
  End { If }
  Else
    Result := True;
End;

procedure TCopyDataWiz1.FormDestroy(Sender: TObject);
Var
  CompObj : TListObj;
begin
  inherited;

  { Free objects in list }
  While (CompList.Items.Count > 0) Do Begin
    CompObj := TListObj(CompList.Items.Objects[0]);

    CompList.Items.Delete(0);

    CompObj.Free;
  End; { While }
end;


{ Returns path of selected company }
Function TCopyDataWiz1.GetCompPath : ShortString;
Var
  CompObj : TListObj;
Begin
  Result := '';

  If (CompList.ItemIndex > -1) Then Begin
    CompObj := TListObj(CompList.Items.Objects[CompList.ItemIndex]);
    Result := Trim(CompObj.Company.CompDet.CompPath);
  End; { If }
End;

{ Returns code of selected company }
Function TCopyDataWiz1.GetCompCode : ShortString;
Var
  CompObj : TListObj;
Begin
  Result := '';

  If (CompList.ItemIndex > -1) Then Begin
    CompObj := TListObj(CompList.Items.Objects[CompList.ItemIndex]);
    Result := Trim(CompObj.Company.CompDet.CompCode);
  End; { If }
End;

{ Returns name of selected company }
Function TCopyDataWiz1.GetCompName : ShortString;
Var
  CompObj : TListObj;
Begin
  Result := '';

  If (CompList.ItemIndex > -1) Then Begin
    CompObj := TListObj(CompList.Items.Objects[CompList.ItemIndex]);
    Result := Trim(CompObj.Company.CompDet.CompName);
  End; { If }
End;

end.
