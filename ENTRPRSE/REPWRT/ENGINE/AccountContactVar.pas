unit AccountContactVar;

//PR: 03/02/2014 ABSEXCH-14974
{This unit contains variables, constants and functions for accessing the Account Contacts files from the VRW}

{$IFNDEF RW}
 Only to be used with the RW define
{$ENDIF}

interface
{$ALIGN 1}
uses
  oAccountContactRoleBtrieveFile,
  oAccountContactBtrieveFile,
  oContactRoleBtrieveFile;


  function ContactRoleDescription(RoleId : Integer) : string;
  function GetAccountContact(ContactId : Integer) : Integer;
  procedure DefineAccountContactFiles;

const
  AccountContactF = 29;
  AccountContactRoleF = 30;

var
  //Global records - needed by report engine
  AccContactRole : AccountContactRoleRecType;
  AccContact : AccountContactRecType;



implementation                                                            

uses
  ContactsManager, BtrvU2, GlobVar, BtKeys1U;

var
  oContactsManager : TContactsManager;

//Returns the Description for the Contact Role ID. Uses Phil's ContactsManager object which loads the
//contact role records when it's created
function ContactRoleDescription(RoleId : Integer) : string;
begin
  if not Assigned(oContactsManager) then
    oContactsManager := NewContactsManager;

  Result := oContactsManager.GetRoleDescription(RoleId);
end;

//Set filenames, record pointers and record sizes in the global arrays
procedure DefineAccountContactFiles;
begin
{$IFNDEF REPWRT}
  Filenames[AccountContactF] := 'CUST\ACCOUNTCONTACT.DAT';
  Filenames[AccountContactRoleF] := 'CUST\ACCOUNTCONTACTROLE.DAT';

  RecPtr[AccountContactF] := @AccContact;
  RecPtr[AccountContactRoleF] := @AccContactRole;

  FileRecLen[AccountContactF] := SizeOf(AccContact);
  FileRecLen[AccountContactRoleF] := SizeOf(AccContactRole);

  FileSpecLen[AccountContactF] := SizeOf(AccountContactBtrieveFileDefinitionType);
  FileSpecLen[AccountContactRoleF] := SizeOf(AccountContactRoleBtrieveFileDefinitionType);

{$ENDIF}
end;

//Find the Account Contact for the Contact Id and load it into the global Account Contact Record (AccContact)
function GetAccountContact(ContactId : Integer) : Integer;
var
  KeyS : Str255;
begin
{$IFNDEF REPWRT}
  KeyS := FullNomKey(ContactId);
  Result := Find_Rec(B_GetEq,F[AccountContactF], AccountContactF, RecPtr[AccountContactF]^, 0 , KeyS);
{$ENDIF}
end;


Initialization
  oContactsManager := nil;

Finalization
  if Assigned(oContactsManager) then
    oContactsManager.Free;

end.
