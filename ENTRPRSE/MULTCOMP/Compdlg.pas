unit CompDlg;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, TEditVal, bkgroup, GlobVar;

type
  DetailedCheckRec = Record
    GotExchSys        : Boolean;
    GotEntSys         : Boolean;
    GotIAOSys         : Boolean;
    SysVer            : Double;
    SysVerStr         : Str10;
    //GotJC             : Boolean;
    CurrVerOK         : Boolean;
    CompCountExceeded : Boolean;
    GotCompanyInfo    : Boolean;
  End; { DetailedCheckRec }

  TCompanyDialog = class(TForm)
    OKBtn: TButton;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    SysLbl: Label8;
    Label1: TLabel;
    SBSBackGroup1: TSBSBackGroup;
    CancelBtn: TButton;
    Label2: TLabel;
    StatLbl: Label8;
    Label3: TLabel;
    CompLbl: Label8;
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
    FCompanyCode   : ShortString;
    FCompany       : ShortString;
    FCheckDataType : Boolean;
    FDirectoryError : Boolean;

    CurDirStr : ShortString;
    SysPath   : ShortString;

    Function GetPath : ShortString;
    Procedure SetPath(Value : ShortString);
  public
    { Public declarations }
    Ok         : Boolean;
    SysDetails : DetailedCheckRec;

    Property CheckDataType : Boolean Read FCheckDataType Write FCheckDataType;
    Property CompanyCode : ShortString read FCompanyCode;
    Property CompanyName : ShortString read FCompany;
    Property DirectoryError : Boolean Read FDirectoryError Write FDirectoryError;
    Property Path : ShortString read GetPath write SetPath;

    Procedure DetailedCheck;
    function Execute : Boolean;
  end;

implementation

{$R *.DFM}

Uses VarConst, VarFPosU, BtrvU2, BtSupU1, ETStrU, EtMiscU, CompUtil, BtKeys1U,
     SavePos,         // Object encapsulating the btrieve saveposition/restoreposition functions
     EntLicence,      // Exchequer/IAO Licence Object
     CompSec,         // Company Count Security
     CompWDlg,        // Company Count Warning Dialog
     CompInfo,        // Company.Info file info & routines (SQL)
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     ChkCurrV, SysU3;

Const
  v41   : Double = 4.1;      { v4.1x }
  v42   : Double = 4.2;      { v4.2x }
  v43   : Double = 4.3;      { v4.30-v4.30b }
  v430c : Double = 4.303;    { v4.30c }
  v431  : Double = 4.310;    { v4.31-v4.31.004 }
  v432  : Double = 4.320;    { v4.32-v4.32.002 }
  v500  : Double = 5.00;     { v5.00-v5.01 }
  v550  : Double = 5.50;     { v5.50-v5.51 }
  v552  : Double = 5.52;     { v5.52 }
  v560  : Double = 5.60;     { v5.6x }
  v570  : Double = 5.70;     { v5.70-v5.70.002 }
  v571  : Double = 5.71;     { v5.710v5.71.002 }
  v600  : Double = 6.00;     { v6.00 }
  v601  : Double = 6.01;     { v6.01 }
  v62   : Double = 6.2;      // v6.2, v6.2.1, v6.2.2  - EC Services & SQL Performance Improvements
  v63   : Double = 6.3;      // v6.3                  - major changes to SQL DB Structure
  v65   : Double = 6.5;      // v6.5                  - ColSet.Dat, ParSet.Dat and WinSet.Dat added
  v67   : Double = 6.7;      // v6.7, v6.8            - Audit directory
  v69   : Double = 6.9;      // v6.9                  - Added CustomFields.Dat
  // Note: constant uses 6.91 as the value as 6.10 would be less than 6.9 breaking the checks
  v610  : Double = 6.91;     // v6.10                 - Added QtyBreak.Dat
  // MH 22/06/2012 v7.0 ABSEXCH-12956/ABSEXCH-12957: Added checks for GL Budget History and Currency History
  v70   : Double = 7.0;      // v7.0                  - Added GLBudgetHistory.Pas and CurrencyHistory.Pas
  // MH 21/01/2015 v7.1 ABSEXCH-16058: Added checks for OPVATPay.dat
  // MH 08/04/2015: Rebranded v7.1 to v8.0
  v80   : Double = 8.0;      // v8.0                  - Added OPVatPay.Dat
  // MH 31/01/2018: Updated for 2018-R1
  v110  : Double = 11.0;     // Exchequer 2018-R1     - Added AnonymisationDiary.Dat

  IAOv100 : Double = 1.00;   // IRIS Accounts Office v1.00-

  PervValidCompanyVer : Double = 11.0;
  SQLValidCompanyVer : Double = 11.0;

//=========================================================================

Function TCompanyDialog.GetPath : ShortString;
Begin
  Result := SysPath;
End;

Procedure TCompanyDialog.SetPath(Value : ShortString);
Var
  Pos  : SmallInt;
  OK   : Boolean;
Begin
  Pos := Length(Value);
  OK := True;

  Repeat
    If (Not OK) Then Begin
      Repeat
        Dec (Pos);
      Until (Pos = 0) Or (Value[Pos] In ['\', ':']);
    End; { If }

    OK := True;

    If (Pos > 0) Then Begin
      Try
        DirectoryListBox1.Directory := Copy(Value, 1, Pos);

      Except
        On Exception Do OK := False;
      End;
    End; { If }
  Until OK;
End;

procedure TCompanyDialog.FormCreate(Sender: TObject);
begin
  { Save Current Directory }
  CurDirStr := GetCurrentDir;
  Ok := False;
  FCheckDataType := False;
  FDirectoryError := False;
end;

procedure TCompanyDialog.FormDestroy(Sender: TObject);
begin
  { Restore Current Directory }
  SetCurrentDir(CurDirStr);
end;

{ Checks for a valid system in the specified path }
Procedure TCompanyDialog.DetailedCheck;
Var
  FSpec   : FileSpec;
  SLocked : Boolean;
  Key2F   : Str255;
  CompCount : LongInt;
  lCompanyRec : CompanyDetRec;

  //------------------------------

  Procedure CalcSQLSysVer;
  Var
    S : ShortString;
  Begin // CalcSQLSysVer
    With SysDetails Do
    Begin
      With TStringList.Create Do
      Begin
        Try
          LoadFromFile (SysPath + 'Company.Sys');
          If (Count = 1) Then
          Begin
            S := UpperCase(Trim(Strings[0]));
            If (S = 'EXCHEQUER COMPANY DATASET') Then
            Begin
              SysVer    := v600;
              SysVerStr := '6.00';
            End // If (S = 'EXCHEQUER COMPANY DATASET')
            Else If (S = 'EXCHEQUER COMPANY DATASET V6.01') Then
            Begin
              SysVer    := v601;
              SysVerStr := '6.01';
            End // If (S = 'EXCHEQUER COMPANY DATASET V6.01')
            Else If (S = 'EXCHEQUER COMPANY DATASET V6.2') Then
            Begin
              // v6.2, v6.2.1, v6.2.2  - EC Services & SQL Performance Improvements
              SysVer    := v62;
              SysVerStr := '6.2';
            End // If (S = 'EXCHEQUER COMPANY DATASET V6.2')
            Else If (S = 'EXCHEQUER COMPANY DATASET V6.3') Then
            Begin
              // v6.3 - major changes to SQL DB Structure
              SysVer    := v63;
              SysVerStr := '6.3';
            End // If (S = 'EXCHEQUER COMPANY DATASET V6.3')
            Else If (S = 'EXCHEQUER COMPANY DATASET V6.5') Then
            Begin
              // v6.5 - ColSet.Dat, ParSet.Dat and WinSet.Dat added
              SysVer    := v65;
              SysVerStr := '6.5';
            End // If (S = 'EXCHEQUER COMPANY DATASET V6.5')
            Else If (S = 'EXCHEQUER COMPANY DATASET V6.7') And DirectoryExists (SysPath + 'Audit') Then
            Begin
              // v6.7 - Audit directory added
              SysVer    := v67;
              SysVerStr := '6.7';
            End // If (S = 'EXCHEQUER COMPANY DATASET V6.7')
            Else If (S = 'EXCHEQUER COMPANY DATASET V6.9') Then
            Begin
              // v6.9 - CustomFields.Dat added
              SysVer    := v69;
              SysVerStr := '6.9';
            End // If (S = 'EXCHEQUER COMPANY DATASET V6.9')
            Else If (S = 'EXCHEQUER COMPANY DATASET V6.10') Then
            Begin
              // v6.10 - QtyBreak.Dat added
              SysVer    := v610;
              SysVerStr := '6.10';
            End // If (S = 'EXCHEQUER COMPANY DATASET V6.10')
            // MH 22/06/2012 v7.0 ABSEXCH-12956/ABSEXCH-12957: Added checks for GL Budget History and Currency History
            Else If (S = 'EXCHEQUER COMPANY DATASET V7.0') Then
            Begin
              // v7.0 - CurrencyHistory.Dat and GLBudgetHistory.Dat added
              SysVer    := v70;
              SysVerStr := '7.0';
            End // If (S = 'EXCHEQUER COMPANY DATASET V7.0')
            Else If (S = 'EXCHEQUER COMPANY DATASET V7.1') Or (S = 'EXCHEQUER COMPANY DATASET V8.0') Then
            Begin
              // MH 21/01/2015 v7.1 ABSEXCH-16058: Added checks for OPVATPay.dat
              // MH 08/04/2015: Rebranded v7.1 to v8.0
              SysVer    := v80;
              SysVerStr := '2015 R1';
            End // If (S = 'EXCHEQUER COMPANY DATASET V7.1') Or (S = 'EXCHEQUER COMPANY DATASET V8.0')
            Else If (S = 'EXCHEQUER COMPANY DATASET V11.0') Then
            Begin
              // MH 31/01/2018: Updated for 2018-R1
              SysVer    := v110;
              SysVerStr := '2018 R1';
            End // If (S = 'EXCHEQUER COMPANY DATASET V11.0')
            Else
            Begin
              SysVer    := v600;
              SysVerStr := '6.00';
            End; // Else
          End // If (Items.Count = 1)
          Else
          Begin
            SysVer    := v600;
            SysVerStr := '6.xx';
          End; // Else
        Finally
          Free;
        End; // Try..Finally
      End; // With TStringList.Create
    End; // With SysDetails
  End; // CalcSQLSysVer

  //------------------------------

Begin
  Self.Cursor := crHourglass;

  With SysDetails Do Begin
    Try
      GotExchSys := False;
      GotEntSys := False;
      GotIAOSys := False;
      SysVer := 0.0;
      SysVerStr := '';
      //GotJC := False;
      FCompanyCode := '';
      FCompany := '';
      CurrVerOK := False;
      CompCountExceeded := False;
      GotCompanyInfo := False;

      If (Not EnterpriseLicence.IsSQL) Then
      Begin
        { Check its not the root and that the data exists }
        If (Length(Trim(SysPath)) > 4) And
           FileExists (SysPath + 'EXCHQSS.DAT') And
           FileExists (SysPath + NumNam) And
           FileExists (SysPath + Path1 + CustName) And
           FileExists (SysPath + Path3 + MiscNam) And
           FileExists (SysPath + Path3 + PassNam) And
           FileExists (SysPath + Path4 + StockNam) And
           FileExists (SysPath + Path2 + DetailName) And
           FileExists (SysPath + Path2 + DocName) And
           FileExists (SysPath + Path2 + HistName) And
           FileExists (SysPath + Path2 + NomNam) Then
        Begin

  //         GotJC := FileExists (SysPath + Path6 + JobCtrlNam) And
  //                  FileExists (SysPath + Path6 + JobDetNam) And
  //                  FileExists (SysPath + Path6 + JobRecNam) And
  //                  FileExists (SysPath + Path6 + JobMiscNam);

           { Open Document.Dat to find out the version }
           Status:=Open_File(F[InvF],SysPath + FileNames[InvF],0);

           GotExchSys := StatusOk;

           If GotExchSys Then Begin
             { Opened successfully - get stats }
             Status := GetFileSpec(F[InvF], InvF, FSpec);
             GotExchSys := StatusOk;

             If GotExchSys Then
             Begin
               Case FSpec.RecLen Of
                 584  : Begin { v2.2x }
                          SysVer    := 2.2;
                          SysVerStr := '2.2x';
                        End;
                 663  : Begin { v3.0x }
                          SysVer    := 3.0;
                          SysVerStr := '3.0x';
                        End;
                 805  : Begin { v4.xx }
                         If FileExists (SysPath + Path4 + MLocName) Then Begin
                           { v4.1x or v4.2x }
                           SysVer    := v41;
                           SysVerStr := '4.1x';

                           { Check for ModRR and GCurR System Setup records }
                           Status:=Open_File(F[SysF],SysPath + FileNames[SysF],0);

                           If StatusOk Then Begin
                             SLocked := False;

                             Key2F:=SysNames[ModRR];
                             If (Find_Rec(B_GetEq+B_KeyOnly,F[SysF],SysF,RecPtr[SysF]^,0,Key2F) = 0) Then Begin
                               SysVer    := v42;
                               SysVerStr := '4.2x';
                             End; { If }

                             Key2F:=SysNames[GCuR];
                             If (Find_Rec(B_GetEq+B_KeyOnly,F[SysF],SysF,RecPtr[SysF]^,0,Key2F) = 0) Then Begin
                               SysVer    := v43;
                               SysVerStr := '4.30b';
                             End; { If }

                             Status := Close_File(F[SysF]);
                           End; { If }

                           If (SysVer = v43) Then Begin
                             { Check for v4.30c - additional security rec in PwrdF }
                             Status:=Open_File(F[PwrdF],SysPath + FileNames[PwrdF],0);

                             If StatusOk Then Begin
                               Key2F := BuildVSecKey;
                               If (Find_Rec(B_GetEq+B_KeyOnly,F[PwrdF],PwrdF,RecPtr[PwrdF]^,0,Key2F) = 0) Then Begin
                                 { V4,30c+ }
                                 SysVer    := v430c;
                                 SysVerStr := '4.30c';
                               End; { If }

                               Status := Close_File(F[PwrdF]);
                             End { If }
                           End; { If }
                         End { If }
                         Else Begin
                           { v4.0x }
                           SysVer    := 4.0;
                           SysVerStr := '4.0x';
                         End; { Else }

                          GotEntSys := FileExists (SysPath + 'FORMS\PAPRSIZE.DAT');
                        End;
                 1143 : Begin { v4.31 - v5.00 }
                          SysVer    := v431;
                          SysVerStr := '4.31';

                          // Check for IAO.DAT to indicate IAO v1.00
                          If (Not FileExists(SysPath + 'IAO.DAT')) Then
                          Begin
                            // Exchequer for Windows
                            GotEntSys := FileExists (SysPath + 'FORMS\PAPRSIZE.DAT');

                            If Not FileExists(SysPath + 'TRANS\NOMVIEW.DAT') Then
                            Begin
                              // Pre-v5.71

                              { Check for additional v4.32 passwords to determine if v4.31 or v4.32 }
                              Status:=Open_File(F[PWrdF],SysPath + FileNames[PWrdF],0);
                              If StatusOk Then
                              Begin
                                // v5.70 - Check for 'Sales - Generate Sales Return'
                                Key2F := 'L' + #0 + '019' + '505';
                                If (Find_Rec(B_GetEq+B_KeyOnly,F[PwrdF],PwrdF,RecPtr[PwrdF]^,0,Key2F) = 0) Then Begin
                                  // Got v5.50 passwords
                                  SysVer    := v570;
                                  SysVerStr := '5.70';
                                End { If (Find_Rec... }
                                Else Begin
                                  // v5.60 - Check for 'Job Costing - Purchase Applications - Access Daybook'
                                  Key2F := 'L' + #0 + '166' + '434';
                                  If (Find_Rec(B_GetEq+B_KeyOnly,F[PwrdF],PwrdF,RecPtr[PwrdF]^,0,Key2F) = 0) Then Begin
                                    // Got v5.50 passwords
                                    SysVer    := v560;
                                    SysVerStr := '5.6x';
                                  End { If (Find_Rec... }
                                  Else Begin
                                    // v5.52 - Check for 'Stock - Bin - Allow Incomplete Allocation'
                                    Key2F := 'L' + #0 + '039' + '430';
                                    If (Find_Rec(B_GetEq+B_KeyOnly,F[PwrdF],PwrdF,RecPtr[PwrdF]^,0,Key2F) = 0) Then Begin
                                      // Got v5.50 passwords
                                      SysVer    := v552;
                                      SysVerStr := '5.52';
                                    End { If (Find_Rec... }
                                    Else Begin
                                      // v5.50 - Check for 'CIS/RCT - Access Ledger'
                                      Key2F := 'L' + #0 + '160' + '246';
                                      If (Find_Rec(B_GetEq+B_KeyOnly,F[PwrdF],PwrdF,RecPtr[PwrdF]^,0,Key2F) = 0) Then Begin
                                        // Got v5.50 passwords
                                        SysVer    := v550;
                                        SysVerStr := '5.50';
                                      End { If (Find_Rec... }
                                      Else Begin
                                        { v5.00 - Check for 'Sales Orders - Allow Generation of Works Orders' }
                                        Key2F := 'L' + #0 + '035' + '354';
                                        If (Find_Rec(B_GetEq+B_KeyOnly,F[PwrdF],PwrdF,RecPtr[PwrdF]^,0,Key2F) = 0) Then Begin
                                          { Got v5.00 passwords }
                                          SysVer    := v500;
                                          SysVerStr := '5.00';
                                        End { If (Find_Rec... }
                                        Else Begin
                                          { v4.32 - Check for 'Sales Orders - TeleSales Create Quotation' }
                                          Key2F := 'L' + #0 + '035' + '348';
                                          If (Find_Rec(B_GetEq+B_KeyOnly,F[PwrdF],PwrdF,RecPtr[PwrdF]^,0,Key2F) = 0) Then Begin
                                            { Got v4.32 passwords }
                                            SysVer    := v432;
                                            SysVerStr := '4.32';
                                          End; { If (Find_Rec... }
                                        End; { Else }
                                      End; { Else }
                                    End; { Else }
                                  End; { Else }
                                End; { Else }
                              End; { If StatusOk }
                            End // If Not FileExists(SysPath + 'TRANS\NOMVIEW.DAT')
                            Else
                            Begin
                              // v5.71-
                              SysVer    := v571;
                              SysVerStr := '5.71';
                            End; // Else
                          End // If (Not FileExists(SysPath + 'IAO.DAT'))
                          Else
                          Begin
                            // IRIS Accounts Office
                            GotIAOSys := True;
                            SysVer := IAOv100;
                            SysVerStr := '1.xx';
                          End; // Else
                        End;
                 1964 : Begin
                          // Check for IAO.DAT to indicate IAO v1.00
                          If (Not FileExists(SysPath + 'IAO.DAT')) Then
                          Begin
                            GotEntSys := True;  // v6.00 is only available for Windows - DOS support dropped

                            // MH 31/01/2018: Updated for 2018-R1
                            If FileExists(SysPath + 'Misc\AnonymisationDiary.Dat') Then
                            Begin
                              // v11.0
                              SysVer    := v110;
                              SysVerStr := '2018 R1';
                            End // If FileExists(SysPath + 'Misc\AnonymisationDiary.Dat')
                            // MH 21/01/2015 v7.1 ABSEXCH-16058: Added checks for OPVATPay.dat
                            // MH 08/04/2015: Rebranded v7.1 to v8.0
                            // MH 28/07/2015 Exch 2015 R1: Updated after v7.0.14 merge to check for v7.0.14 files
                            Else If FileExists(SysPath + 'Misc\SystemSetup.Dat') And FileExists(SysPath + 'Misc\VAT100.Dat') And FileExists(SysPath + 'Trans\OPVATPay.Dat') Then
                            Begin
                              // v8.0
                              SysVer    := v80;
                              SysVerStr := '2015 R1';
                            End // If FileExists(SysPath + 'Trans\OPVATPay.Dat')
                            // MH 22/06/2012 v7.0 ABSEXCH-12956/ABSEXCH-12957: Added checks for GL Budget History and Currency History
                            Else If FileExists(SysPath + 'CurrencyHistory.Dat') And FileExists(SysPath + 'Trans\GLBudgetHistory.Dat') Then
                            Begin
                              // v7.0
                              SysVer    := v70;
                              SysVerStr := '7.0';
                            End // If FileExists(SysPath + 'CurrencyHistory.Dat') And FileExists(SysPath + 'Trans\GLBudgetHistory.Dat')
                            Else If FileExists(SysPath + 'Misc\QtyBreak.Dat') Then
                            Begin
                              // v6.10
                              SysVer    := v610;
                              SysVerStr := '6.10';
                            End // If FileExists(SysPath + 'Misc\QtyBreak.Dat')
                            Else If FileExists(SysPath + 'Misc\CustomFields.Dat') Then
                            Begin
                              // v6.9
                              SysVer    := v69;
                              SysVerStr := '6.9';
                            End // If DirectoryExists(SysPath + 'Audit')
                            Else If DirectoryExists(SysPath + 'Audit') Then
                            Begin
                              // v6.7
                              SysVer    := v67;
                              SysVerStr := '6.7';
                            End // If DirectoryExists(SysPath + 'Audit')
                            Else If FileExists(SysPath + 'Misc\ColSet.Dat') And FileExists(SysPath + 'Misc\ParSet.Dat') And FileExists(SysPath + 'Misc\WinSet.Dat') Then
                            Begin
                              // v6.5
                              SysVer    := v65;
                              SysVerStr := '6.5';
                            End // If FileExists(SysPath + 'Misc\ColSet.Dat') And FileExists(SysPath + 'Misc\ParSet.Dat') And FileExists(SysPath + 'Misc\WinSet.Dat')
                            Else If FileExists(SysPath + 'Misc\SortView.Dat') And FileExists(SysPath + 'Misc\MultiBuy.Dat') Then
                            Begin
                              SysVer    := v601;
                              SysVerStr := '6.01';
                            End // If FileExists(SysPath + 'Misc\SortView.Dat') And FileExists(SysPath + 'Misc\MultiBuy.Dat')
                            Else
                            Begin
                              SysVer    := v600;
                              SysVerStr := '6.00';
                            End; // Else

                            If FileExists(SysPath + CompanyInfoName) Then
                            Begin
                              GotCompanyInfo := ReadCompInfo (SysPath, lCompanyRec);
                              If GotCompanyInfo Then
                              Begin
                                FCompanyCode := Trim(lCompanyRec.CompCode);
                                FCompany     := Trim(lCompanyRec.CompName);
                              End; // If GotCompanyInfo
                            End; // If FileExists(SysPath + CompanyInfoName)
                          End // If (Not FileExists(SysPath + 'IAO.DAT'))
                          Else
                          Begin
                            // IRIS Accounts Office
                            GotIAOSys := True;
                            SysVer := IAOv100;
                            SysVerStr := '1.xx';
                          End; // Else
                        End; // 1964
               End; { Case }
             End; // If GotExchSys

             Status:=Close_File(F[InvF]);

             If GotExchSys Or GotIAOSys Then Begin
               { Get Company Name from System File }
               Status:=Open_File(F[SysF],SysPath + FileNames[SysF],0);

               If StatusOk Then Begin
                 { Get Company Name }
                 If (Not EnterpriseLicence.IsSQL) Then
                 Begin
                   // Pervasive.SQL
                   SLocked := False;
                   If GetMultiSys(False, SLocked, SysR) Then
                     FCompany := DoubleAmpers (Syss.UserName);
                 End; // If (Not EnterpriseLicence.IsSQL)

                 If EnterpriseLicence.IsLITE And FCheckDataType Then
                 Begin
                   // IAO - For blank companies check the company count licence
                   SLocked := False;
                   If GetMultiSys(False, SLocked, ModRR) Then
                   Begin
                     If (SyssMod.ModuleRel.CompanyDataType = 0) Then
                     Begin
                       // Exchequer - Check Company Count before allowing user to proceed
                       CompCount := GetActualCompanyCount;
                       If (CompCount >= GetLicencedCompanyCount) Then
                       Begin
                         CompCountExceeded := True;
                         If Self.Visible Then DisplayCompCountWarning (CompCount, GetLicencedCompanyCount, False);
                       End; // If (CompCount >= GetLicencedCompanyCount)
                     End; // If (SyssMod.ModuleRel.CompanyDataType = 0)
                   End; // If GetMultiSys(False, SLocked, ModR)
                 End; // If EnterpriseLicence.IsLITE

                 Status := Close_File(F[SysF]);
               End; { If }

               { Check Currency Version }
               CurrVerOK := CheckCurrencyVer (SysPath);
             End; { If }
           End; { If }
        End; { If }
      End // If (Not EnterpriseLicence.IsSQL)
      Else
      Begin
        // SQL - Can't do any data access to checkout the system as the dataset isn't active/attached
        If SQLUtils.ValidCompany(SysPath) Then
        Begin
          If FileExists(SysPath + CompanyInfoName) Then
          Begin
            GotExchSys := True;
            GotEntSys := True;  // v6.00 is only available for Windows - DOS support dropped

            CalcSQLSysVer;
            //SysVer    := v600;
            //SysVerStr := '6.xx';

            GotCompanyInfo := ReadCompInfo (SysPath, lCompanyRec);
            If GotCompanyInfo Then
            Begin
              FCompanyCode := Trim(lCompanyRec.CompCode);
              FCompany     := Trim(lCompanyRec.CompName);
            End; // If GotCompanyInfo

            // Check Currency Version
            CurrVerOK := CheckCurrencyVer (SysPath);
          End // If FileExists(SysPath + CompanyInfoName)
          Else
          Begin
            If DirectoryError And FileExists (SysPath + 'Company.Sys') Then
            Begin
              GotExchSys := True;
              GotEntSys := True;  // v6.00 is only available for Windows - DOS support dropped

              CalcSQLSysVer;
              //SysVer    := v600;
              //SysVerStr := '6.xx';

              CurrVerOK := CheckCurrencyVer (SysPath);
            End; // If DirectoryError And FileExists (SysPath + 'Company.Sys')
          End; // Else
        End; // If SQLUtils.ValidCompany(SysPath)
      End; // Else
    Except
      GotExchSys := False;
      GotEntSys := False;
      SysVer := 0.0;
      //GotJC := False;
    End; { Try }
  End; { With }

  Self.Cursor := crDefault;
End;

procedure TCompanyDialog.DirectoryListBox1Change(Sender: TObject);
Const
  FNum    = CompF;
  KeyPath : Integer = CompPathK;
Var
  iStatus         : SmallInt;
  sKey            : Str255;
  StatStr, SysStr : ShortString;
  ValidSys        : Boolean;
  ValidPath       : Boolean;
begin
  SysStr := 'No System Found In Directory';
  StatStr := '';
  FCompany := '';
  ValidSys := False;

  SysPath := PathToShort(DirectoryListBox1.Directory) + '\';

{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    ValidPath := FileExists(SysPath + 'COMPANY.INFO') Or (DirectoryError And FileExists(SysPath + 'COMPANY.SYS'))
  else
    ValidPath := FileExists(SysPath + PathSys);
  if ValidPath then
{$ELSE}
  If FileExists (SysPath + PathSys) Then
{$ENDIF}
  Begin
    { Check for a valid system in path }
    DetailedCheck;

    If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]) Then
    Begin
      // IRIS Accounts Office
      If SysDetails.GotIAOSys Then
      Begin
        // IRIS Accounts Office
        SysStr := 'IRIS Accounts Office v' + SysDetails.SysVerStr;
        If SysDetails.CurrVerOK Then
        Begin
          StatStr := 'Valid Company';
          ValidSys := True;
        End { If }
        Else Begin
          { Invalid Currency Version }
          StatStr := 'Incorrect Currency Edition';
        End; { Else }
      End // If GotIAOSys
      Else
      Begin
        If (SysDetails.SysVer >= v80) Then
          SysStr := 'Exchequer ' + SysDetails.SysVerStr
        Else
          SysStr := 'Exchequer v' + SysDetails.SysVerStr;
        StatStr := 'Cannot be used in IRIS Accounts Office';
      End; // Else
    End // If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct])
    Else
    Begin
      // Exchequer for DOS/Windows
      With SysDetails Do
      Begin
        If GotIAOSys Then
        Begin
          // Exchequer System + IAO Dataset = Not Good!
          SysStr := 'IRIS Accounts Office v' + SysDetails.SysVerStr;
          StatStr := 'Cannot be used in Exchequer';
        End // If GotIAOSys
        Else
        Begin
          // Exchequer / Enterprise System
          If GotEntSys Then Begin
            { Exchequer Enterprise }
            If (SysVer >= v80) Then
              SysStr := 'Exchequer ' + SysVerStr
            Else
              SysStr := 'Exchequer v' + SysVerStr;

            { Check its the latest version }
            //If (SysVer >= v500) Then Begin
            //If (SysVer >= ValidCompanyVer) Then Begin

            // MH 15/02/2010 (v6.3): Extended to allow Pervsaive and SQL Editions to have separate
            //                       versions as the SQL Improvement Plan is completely redoing the
            //                       SQL Database whilst Pervasive Edition is not changing
            If (EnterpriseLicence.IsSQL And (SysVer >= SQLValidCompanyVer)) Or
               ((Not EnterpriseLicence.IsSQL) And (SysVer >= PervValidCompanyVer)) Then
            Begin
              If CurrVerOK Then Begin
                If (Not EnterpriseLicence.IsSQL) Or (EnterpriseLicence.IsSQL And GotCompanyInfo) Then
                Begin
                  StatStr := 'Valid Company';
                  ValidSys := True;
                End // If (Not EnterpriseLicence.IsSQL) Or (EnterpriseLicence.IsSQL And GotCompanyInfo)
                Else
                Begin
                  StatStr := 'Company.Info Missing';
                  ValidSys := DirectoryError;//False;
                End; // Else
              End { If }
              Else Begin
                { Invalid Currency Version }
                StatStr := 'Invalid Currency Version';
              End; { Else }
            End { If }
            Else
              { Old Enterprise version }
              StatStr := 'Requires Conversion Before Use';
          End { If }
          Else
            If GotExchSys Then Begin
              { DOS Exchequer }
              SysStr := 'Exchequer DOS v' + SysVerStr;
              StatStr := 'Requires Conversion Before Use';
            End; { If }
        End; // Else
      End; // With SysDetails
    End; // Else

    If ValidSys Then
    Begin
      // HM 21/04/04: Added Save Position as it was screwing the DBMultiList on
      // the company list window, causing it to only show one row
      With TBtrieveSavePosition.Create Do
      Begin
        Try
          // Save the current position in the file for the current key
          SaveFilePosition (CompF, GetPosKey);
          SaveDataBlock (Company, SizeOf(Company^));

          //------------------------------

          { validate company - check it doesn't already exist in the database }
          sKey := FullCompPathKey(cmCompDet, Path);
          iStatus := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, sKey);
          If (iStatus = 0) Then
          Begin
            { Company already exists }
            StatStr := 'Already Registered';
            ValidSys := False;
          End; // If (iStatus = 0)

          //------------------------------

          // Restore position in file
          RestoreSavedPosition (True);
          RestoreDataBlock (Company);
        Finally
          Free;
        End; // Try..Finally
      End; // With TBtrieveSavePosition.Create
    End; // If ValidSys
  End; // If FileExists (SysPath + PathSys)

  SysLbl.Caption := SysStr;
  StatLbl.Caption := StatStr;
  CompLbl.Caption := FCompany;

  OkBtn.Enabled := ValidSys And (Not SysDetails.CompCountExceeded);
end;

function TCompanyDialog.Execute : Boolean;
begin
  Try
    DirectoryListBox1Change(Self);

    ShowModal;

    Result := Ok;
  Except
    Result := False;
  end; { Try }
end;

procedure TCompanyDialog.OKBtnClick(Sender: TObject);
begin
  Ok := True;
  Close;
end;

procedure TCompanyDialog.CancelBtnClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

end.
