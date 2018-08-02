{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVSecurity;

interface

uses
  {$IFDEF Linux}
  {$ELSE}
  Windows,
  {$ENDIF}
  Classes, SysUtils, RVClass, RVData, RVDefine;

type
  TRaveBaseSecurity = class(TRaveDataObject)
  public
    function IsValidUser(AUserName: string;
                         APassword: string): boolean; virtual; abstract;
  end; { TRaveBaseSecurity }

  TRaveSimpleSecurity = class(TRaveBaseSecurity)
  protected
    FUserList: TStrings;
    FCaseMatters: boolean;
    procedure SetUserList(Value: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsValidUser(AUserName: string;
                         APassword: string): boolean; override;
  published
    property UserList: TStrings read FUserList write SetUserList;
    property CaseMatters: boolean read FCaseMatters write FCaseMatters default false;
  end; { TRaveSimpleSecurity }

  TRaveLookupSecurity = class(TRaveBaseSecurity)
  protected
    FDataView: TRaveBaseDataView;
    FUserField: TRaveFieldName;
    FPasswordField: TRaveFieldName;
  public
    function IsValidUser(AUserName: string;
                         APassword: string): boolean; override;
  published
    property DataView: TRaveBaseDataView read FDataView write FDataView default nil;
    property UserField: TRaveFieldName read FUserField write FPasswordField;
    property PasswordField: TRaveFieldName read FPasswordField write FPasswordField;
  end; { TRaveLookupSecurity }

  procedure RaveRegister;

implementation

uses
  RPDefine;

procedure RaveRegister;
begin { RaveRegister }
{TransOff}
  RegisterRaveComponents('',[TRaveSimpleSecurity,TRaveLookupSecurity]);
  RegisterRaveDataObject('Simple Security Controller',TRaveSimpleSecurity);
  RegisterRaveDataObject('Data Lookup Security Controller',TRaveLookupSecurity);

{!!! RegisterRaveModuleClasses('RVData',[TRaveSimpleSecurity,TRaveLookupSecurity]); }

{$IFDEF DESIGNER}
  RegisterRaveProperties(TRaveSimpleSecurity,
   {Beginner}     'UserList',
   {Intermediate} 'CaseMatters',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveLookupSecurity,
   {Beginner}     'DataView;UserField;PasswordField',
   {Intermediate} '',
   {Developer}    '',
   {Hidden}       '');

  SetPropDesc(TRaveSimpleSecurity,'UserList',Trans('Defines the list of ' +
   'valid username=password pairs.'));
  SetPropDesc(TRaveSimpleSecurity,'CaseMatters',Trans('Determines whether ' +
   'case matters for the password.'));

  SetPropDesc(TRaveLookupSecurity,'DataView',Trans('Defines the default dataview ' +
   'that will be used for the UserField and PasswordField properties.'));
  SetPropDesc(TRaveLookupSecurity,'UserField',Trans('Defines the data field ' +
   'to compare against the provided user name.'));
  SetPropDesc(TRaveLookupSecurity,'PasswordField',Trans('Defines the data field ' +
   'to compare against the provided password.'));
{$ENDIF}
{TransOn}
end;

(*****************************************************************************}
( class TRaveSimpleSecurity
(*****************************************************************************)

constructor TRaveSimpleSecurity.Create(AOwner: TComponent);
begin
  inherited;
  FUserList := TStringList.Create;
end;

destructor TRaveSimpleSecurity.Destroy;
begin
  FUserList.Free;
  inherited;
end;

procedure TRaveSimpleSecurity.SetUserList(Value: TStrings);
begin
  FUserList.Assign(Value);
end;

function TRaveSimpleSecurity.IsValidUser(AUserName: string; APassword: string): boolean;
begin
  if Length(APassword) = 0 then begin
    Result := False;
  end else if CaseMatters then begin
    Result := CompareStr(UserList.Values[AUserName], APassword) = 0;
  end else begin
    Result := CompareText(UserList.Values[AUserName], APassword) = 0;
  end;
end;

(*****************************************************************************}
( class TRaveLookupSecurity
(*****************************************************************************)

function TRaveLookupSecurity.IsValidUser(AUserName: string; APassword: string): boolean;
begin
  If (Length(APassword) = 0) or (Length(AUserName) = 0) or (Length(UserField) = 0) or
   (Length(PasswordField) = 0) or not Assigned(DataView) then begin
    Result := False;
  end else begin
    Result := CompareStr(PerformLookup(DataView,AUserName,
     DataView.FieldByName(UserField),PasswordField,PasswordField,''),APassword) = 1;
  end; { else }
end;

initialization
  RegisterProc('RVCL',RaveRegister);
end.