unit ESNCHECK;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TfrmESNWarning = class(TForm)
    IconImage: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    btnOK: TButton;
    lblErrNo: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

// Checks the ESN in Company.Dat against that in Enterprise Licence, assumes
// that Company.Dat is open and SyssCompany has been loaded
Function CheckESNIntegrity : LongInt;

{ Display a warning dialog as the ESN's are out of synch }
Procedure DisplayESNError (Const ErrNo : LongInt);

implementation

{$R *.DFM}

Uses GlobVar, VarConst, BtrvU2, BTSupU1, LicRec, LicFuncU, EntLic;

//----------------------------------------------------------

// Called during the MCM Startup, it checks the ESN in Company.Dat against
// that in Enterprise Licence and the ExchqSS.Dat in the Company.Dat directory,
// it assumes that Company.Dat is open and SyssCompany has been loaded
//
// Return Values:
//      0    AOK
//   1000    Unknown Error
//   1001    Error Reading Enterprise Licence (Entrprse.Dat)
//   1002    ESN in Enterprise.Dat not set
//   1003    ESN in Company.Dat not set
//   1004    ESN in Company.Dat and Entrprse.Dat don't match
//   1005    ESN in Entrprse.Dat and ExchQss.Dat don't match
//   2000-   Btrieve Error opening SysF in main directory
//   2999    Error reading System Setup Record containing ESN
Function CheckESNIntegrity : LongInt;
Var
  EntLicR : EntLicenceRecType;
  LStatus : SmallInt;
  SLocked : Boolean;
Begin { CheckESNIntegrity }
  Result := 1000;

  // Load Licence
  If ReadEntLic (EntLicFName, EntLicR) Then Begin
    // Got Licence - Check ESN is set
//ShowMessage('EntLicR.licISN: ' + ESN2ByteToStr (EntLicR.licISN));
    If licESNSet(EntLicR.licISN) Then Begin
      // Check ESN in Company.Dat is set
//ShowMessage('CompOpt.optSystemESN: ' + ESN2ByteToStr (CompOpt.optSystemESN));
      If licESNSet(ESNByteArrayType(SyssCompany^.CompOpt.optSystemESN)) Then Begin
        // Both Set - Compare ESN against SyssCompany
        If licMatchingESN(EntLicR.licISN, ESNByteArrayType(SyssCompany^.CompOpt.optSystemESN)) Then Begin
          // Open SysF and Check ESN
          LStatus:=Open_File(F[SysF],SetDrive+FileNames[SysF],0);
          If (LStatus = 0) Then Begin
            // Load main Setup Record containing the ESN
            SLocked := False;
            If GetMultiSys(False, SLocked, SysR) Then Begin
              // Got SysR - check ESN against licence file
              If licMatchingESN(EntLicR.licISN, ESNByteArrayType(Syss.EXISN)) Then
                Result := 0
              Else
                Result := 1005;
            End { If GetMultiSys }
            Else
              Result := 2999;

            Close_File (F[SysF]);
          End { If (LStatus = 0)  }
          Else
            Result := 2000 + LStatus;
        End { If licMatchingESN... }
        Else
          Result := 1004;
      End { If licESNSet }
      Else
        Result := 1003;
    End { If licESNSet }
    Else
      Result := 1002;
  End { If ReadEntLic }
  Else
    Result := 1001;

  If (Result <> 0) Then
    DisplayESNError (Result);
End; { CheckESNIntegrity }

//----------------------------------------------------------

{ Display a warning dialog as the ESN's are out of synch }
Procedure DisplayESNError (Const ErrNo : LongInt);
Begin { DisplayCompCountWarning }
  With TfrmESNWarning.Create (Application) Do
    Try
      lblErrNo.Caption := IntToStr(ErrNo);

      ShowModal;

    Finally
      Free;
    End;
End; { DisplayCompCountWarning }

//----------------------------------------------------------

procedure TfrmESNWarning.FormCreate(Sender: TObject);
begin
  // Load standard Warning Icon into Image
  IconImage.Picture.Icon.Handle := LoadIcon(0, IDI_EXCLAMATION);
end;

//----------------------------

end.
