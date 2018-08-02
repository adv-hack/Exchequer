unit JASCLnkU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, ComCtrls, GlobVar, VarConst, BTSupU1, SalTxl3U, ExtCtrls
  , uMultiList, uDBMultiList, uExDatasets, uBTGlobalDataset, uSettings, Menus;

type
  TShowSubCon = class(TForm)
    Label1: TLabel;
    btnCancel: TButton;
    bdsSubContractors: TBTGlobalDataset;
    mlSubContractors: TDBMultiList;
    btnView: TButton;
    pmSettings: TPopupMenu;
    popFormProperties: TMenuItem;
    N1: TMenuItem;
    miSaveCoordinates: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure bdsSubContractorsGetFieldValue(Sender: TObject;
      PData: Pointer; FieldName: String; var FieldValue: String);
    procedure bdsSubContractorsGetBufferSize(Sender: TObject;
      var TheBufferSize: Integer);
    procedure bdsSubContractorsGetDataRecord(Sender: TObject;
      var TheDataRecord: Pointer);
    procedure bdsSubContractorsGetFileVar(Sender: TObject;
      var TheFileVar: pFileVar);
    procedure btnViewClick(Sender: TObject);
    procedure mlSubContractorsRowDblClick(Sender: TObject;
      RowIndex: Integer);
    procedure FormResize(Sender: TObject);
    procedure popFormPropertiesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pmSettingsPopup(Sender: TObject);
    procedure miSaveCoordinatesClick(Sender: TObject);
  private
    bSavePosition, bRestore, tForceClose  :  Boolean;
    DispEmp    :  TFJobDisplay;
    LastEmpCode:  Str10;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
    procedure Display_Emp(EmpCode : Str10; sMode : byte);
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
  public
    SuppCode : Str10;
    procedure BuildList;
  end;

Function Show_SCEmployee(sCode : Str10; sMode : byte) : LongInt;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU, ETMiscU, ETDateU, BtrvU2, BTKeys1U, JChkUseU, GDPRConst;

{$R *.dfm}

procedure TShowSubCon.FormCreate(Sender: TObject);
begin
  DispEmp:=nil;
  tForceclose:=BOff;
  bRestore := FALSE;
  LastEmpCode:='';
  sMiscDirLocation := SetDrive;  // NF: 23/03/2007 - added to stop error 3s when running under local program files.
  oSettings.LoadForm(Self, bSavePosition);
  oSettings.LoadList(mlSubContractors, Self.Name);
  oSettings.Free;
end;

Procedure TShowSubCon.WMCustGetRec(Var Message  :  TMessage);
Begin
  with Message do
  begin
    Case WParam of
      38 : Begin
        DispEmp:=nil;
        tForceClose:=(mlSubContractors.ItemsCount <= 1);

        If (Not tForceClose) then {* Refresh list *}
          mlSubContractors.Refreshdb;

      end;
    end;{case}
  end;{with}
  Inherited;
end;

{ == Proc to display other users == }
procedure TShowSubCon.BuildList;
Begin
  bdsSubContractors.SearchKey := PartCCKey(JARCode,JASubAry[3])+FullCustCode(SuppCode);
  mlSubContractors.Active := TRUE;

  If (mlSubContractors.ItemsCount>0) then
    LastEmpCode:=JobMiscRec(bdsSubContractors.GetRecord^).EmplRec.EmpCode;
end; {Proc..}

{ ======= Link to Employee display ======== }
procedure TShowSubCon.Display_Emp(EmpCode  :  Str10; sMode    :  Byte);
Var
  KeyS  :  Str255;
Begin
  KeyS:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(EmpCode));

  {$B-}
  If (sMode=1) or (CheckRecExsists(KeyS,JMiscF,JMK)) then
  {$B+}
  Begin
    {$IFDEF JC}
      If (DispEmp=nil) then
        DispEmp:=TFJobDisplay.Create(Self);
      try
        With DispEmp do
        Begin
          If (sMode=1) then
          Begin

          end;{if}
          Display_Employee(sMode,BOn);
        end;{with}
      except
        DispEmp.Free;
      end;{try}
    {$ENDIF}
  end;
end;

procedure TShowSubCon.btnCancelClick(Sender: TObject);
begin
  tForceClose:=BOn;
end;

procedure TShowSubCon.bdsSubContractorsGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with JobMiscRec(PData^).EmplRec do begin
    case FieldName[1] of
      'S' : FieldValue := EmpCode;
      'N' : FieldValue := EmpName;
    end;{case}
  end;{with}
end;

procedure TShowSubCon.bdsSubContractorsGetBufferSize(Sender: TObject;
  var TheBufferSize: Integer);
begin
  TheBufferSize := FileRecLen[JMiscF];
end;

procedure TShowSubCon.bdsSubContractorsGetDataRecord(Sender: TObject;
  var TheDataRecord: Pointer);
begin
  TheDataRecord := RecPtr[JMiscF];
end;

procedure TShowSubCon.bdsSubContractorsGetFileVar(Sender: TObject;
  var TheFileVar: pFileVar);
begin
  TheFileVar := @F[JMiscF];
end;

procedure TShowSubCon.btnViewClick(Sender: TObject);
begin
  With JobMiscRec(bdsSubContractors.GetRecord^).EmplRec do
  Begin
    Display_Emp(EmpCode,2);
  end;
end;

procedure TShowSubCon.mlSubContractorsRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnViewClick(nil);
end;

procedure TShowSubCon.FormResize(Sender: TObject);
begin
{  mlSubContractors.Height := Height - 110;
  mlSubContractors.Width := Width - 25;
  btnView.Top := Height - 55;
  btnCancel.Top := btnView.Top;
  btnView.Left := Width - 185;
  btnCancel.Left := Width - 97;}
  // NF: 23/03/2007 changed to fix resize issues with scroll bars
  mlSubContractors.Height := ClientHeight - 83;
  mlSubContractors.Width := ClientWidth - 17;
  btnView.Top := ClientHeight - 28;
  btnCancel.Top := btnView.Top;
  btnView.Left := ClientWidth - 178;
  btnCancel.Left := ClientWidth - 90;
end;

procedure TShowSubCon.WMGetMinMaxInfo(var message: TWMGetMinMaxInfo);
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 250;
    ptMinTrackSize.Y := 250;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TShowSubCon.popFormPropertiesClick(Sender: TObject);
begin
  case oSettings.Edit(mlSubContractors, Self.Name, nil) of
    mrRestoreDefaults : begin
      oSettings.RestoreListDefaults(mlSubContractors, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
  oSettings.Free;
end;

procedure TShowSubCon.FormDestroy(Sender: TObject);
begin
  if not bRestore then begin
    oSettings.SaveList(mlSubContractors, Self.Name);
    oSettings.SaveForm(Self, bSavePosition);
    oSettings.Free;
  end;{if}
end;

procedure TShowSubCon.pmSettingsPopup(Sender: TObject);
begin
  miSaveCoordinates.Checked := bSavePosition;
end;

procedure TShowSubCon.miSaveCoordinatesClick(Sender: TObject);
begin
  bSavePosition := not bSavePosition;
  miSaveCoordinates.Checked := bSavePosition;
end;


{Function Show_SCEmployee(sCode : Str10; iMode : byte) : LongInt;
Begin
  With TShowSubCon.Create(Application.MainForm) do
  Try
    Caption:='Sub contractor List for '+dbFormatName(Cust.CustCode, Cust.Company);
    SuppCode:=Scode;
    BuildList;
    Result := mlSubContractors.ItemsCount;

    // Show employee record if only one
    If (Result > 1) then  Show
    else Display_Emp(JobMiscRec(bdsSubContractors.GetRecord^).EmplRec.EmpCode, iMode);

    While (Not tForceClose) do
    Begin
      Application.ProcessMessages;
      SleepEx(100,BOn);
    end;{while
  Finally
    Free;
  end;{try
end;}

Function Show_SCEmployee(Scode  :  Str10;
                         sMode  :  Byte)  :  LongInt;
var
  lTraderDesc : string;
Begin
  With TShowSubCon.Create(Application.MainForm) do
  Try

    With Cust do
    begin
      //SSK 21/02/2018 2018 R1 ABSEXCH-19778: GetCompanyDescription call implemented
      if GDPROn and (acAnonymisationStatus = asAnonymised) then
        lTraderDesc := capAnonymised
      else
        lTraderDesc := Company;

        Caption:='Sub contractor List for ' + dbFormatName(CustCode,lTraderDesc);
    end;

    SuppCode:=Scode;
    BuildList;

    {Result:=iCounter;}
    Result := mlSubContractors.ItemsCount;


    If (Result>1) then
      Show
    else
    Begin
      Display_Emp(LastEmpCode,sMode);
    end; {While..}

    While (Not tForceClose) do
    Begin
      Application.ProcessMessages;
      SleepEx(100,BOn);
    end;
  Finally
    Free;

  end;

end;


end.
