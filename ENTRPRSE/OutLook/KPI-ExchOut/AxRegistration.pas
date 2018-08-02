{ The contents of this file are subject to the Mozilla Public License  }
{ Version 1.1 (the "License"); you may not use this file except in     }
{ compliance with the License. You may obtain a copy of the License at }
{ http://www.mozilla.org/MPL/                                          }
{                                                                      }
{ Software distributed under the License is distributed on an "AS IS"  }
{ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See  }
{ the License for the specific language governing rights and           }
{ limitations under the License.                                       }
{                                                                      }
{ The Original Code is AxRegistration.pas.                             }
{                                                                      }
{ The Initial Developer of the Original Code is Ashley Godfrey, all    }
{ Portions created by these individuals are Copyright (C) of Ashley    }
{ Godfrey.                                                             }
{                                                                      }
{**********************************************************************}
{                                                                      }
{ This unit contains code to help detect whether or not specific COM   }
{ classes have been registered on the current machine, and code to     }
{ automate registration of type libraries at run time.                 }
{                                                                      }
{ Unit owner: Ashley Godfrey.                                          }
{ Last modified: April 23, 2004.                                       }
{ Updates available from http://www.evocorp.com                        }
{                                                                      }
{**********************************************************************}

{**********************************************************************}
{ TO USE THIS UNIT ON AN NT-based OPERATING SYSTEM, YOU MUST HAVE      }
{ ADMINISTRATOR ACCESS. WITHOUT THIS ACCESS, CALLS TO ACCESS THE       }
{ SYSTEM REGISTRY MAY WELL FAIL.                                       }
{**********************************************************************}

unit AxRegistration;
interface
uses
  SysUtils, Windows, ActiveX;

type
  TClassIdArray = array of TCLSID;
  TTypeLibItem = record
    TypeLibID: TGUID;    // Identifies the type library
    MajorVersion: Byte;  // Identifies the type library major version number
    MinorVersion: Byte;  // Identifies the type library minor version number
  end;
  TTypeLibArray = array of TTypeLibItem;

  TTypeLibRegFailType = (etlfLoad, etlfRegistration);
  ETypeLibRegistration = class(Exception)
  private
    FFailCode: HRESULT;
    FFailType: TTypeLibRegFailType;
  public
    constructor Create(const Message: string;
      FailCode: HRESULT; FailType: TTypeLibRegFailType);
    property FailCode: HRESULT read FFailCode;
    property FailType: TTypeLibRegFailType read FFailType;
  end;

// ComClassesRegistered takes a list of COM class ID's (ClassList) and
// determines whether the classes specified in this list are registered.
// If this function fails, it means that not all classes listed in ClassList
// are registered, and UnregisteredClassList contains those classes that
// have not been registered.
function ComClassesRegistered(const ClassList: array of TCLSID;
  var UnregisteredClassList: TClassIdArray): Boolean;

// TypeLibrariesRegistered takes a list of type library ID's (TypeLibList)
// and determines whether or not the type libraries specified in this list
// are registered. TypeLibrariesRegistered works in the same way as
// ComClassesRegistered, defined above. LanguageCode identifies the
// national language code of the class to be checked, and
// FailOnLanguageCodeMismatch specifies whether or not to consider a
// type library with a language mismatch (i.e., where the type library
// exists but the language differs) as a non-registered type library.
function TypeLibrariesRegistered(const TypeLibList: TTypeLibArray;
  var UnregisteredTypeLibs: TTypeLibArray; const LanguageCode: LCID = 0;
  const FailOnLanguageCodeMismatch: Boolean = False): Boolean;

// RegisterTypeLibrary provides a simple mechanism for registering type
// libraries on the fly, including *.TLB files (bonus!). This method
// throws an ETypeLibRegistration exception on failure to register the
// associated type library.
procedure RegisterTypeLibrary(const ALibraryFileName: WideString);

implementation
uses
  Registry;

resourcestring
  sTypeLibLoadFailed = 'An error occurred loading information from the type ' +
                       'library file %s';
  sTypeLibRegFailed = 'An error occurred updating registry information for ' +
                      'the type library file %s. This file might be corrupt, ' +
                      'or you might have insufficient privileges to access ' +
                      'the system registry.';

function ComClassesRegistered(const ClassList: array of TGUID;
  var UnregisteredClassList: TClassIdArray): Boolean;
var i: Integer;
    Registry: TRegistry;
begin
  // Check whether all the classes defined in "ClassList" are registered.
  // We could do this by creating and destroying the associated classes,
  // however this is not only resource intensive, it is also a potential
  // security threat as we don't know what we're actually creating. Instead
  // of this, we'll check to see whether or not the associated class ID's
  // are actually listed in the system registry.

  SetLength(UnregisteredClassList, 0);

  Registry := TRegistry.Create;
  with Registry do
  try
    // CLSID's are listed in the HKEY_CLASSES_ROOT registry key, under the
    // CLSID key. We'll check whether or not an associated type library has
    // been listed against this class, as you won't be able to create the
    // class otherwise.
    RootKey := HKEY_CLASSES_ROOT;
    for i := Low(ClassList) to High(ClassList) do
      if not OpenKeyReadOnly('\CLSID\' + GUIDToString(ClassList[i]) + '\TypeLib') then
      begin
        SetLength(UnregisteredClassList, Length(UnregisteredClassList) + 1);
        UnregisteredClassList[Length(UnregisteredClassList) - 1] := ClassList[i];
      end;

    // If UnregisteredClassList is still empty, then all of the classes
    // identified in the incoming class ID list were registered.
    Result := Length(UnregisteredClassList) = 0;
  finally
    Registry.Free;
  end;
end;

function TypeLibrariesRegistered(const TypeLibList: TTypeLibArray;
  var UnregisteredTypeLibs: TTypeLibArray; const LanguageCode: LCID = 0;
  const FailOnLanguageCodeMismatch: Boolean = False): Boolean;
var i: Integer;
    pTypeLib: ITypeLib;
    LoadResult: HRESULT;
begin
  pointer(pTypeLib) := nil;    // Clear our type library interface.
  SetLength(UnregisteredTypeLibs, 0);

  for i := Low(TypeLibList) to High(TypeLibList) do
  try
    LoadResult := LoadRegTypeLib(TypeLibList[i].TypeLibID,
      TypeLibList[i].MajorVersion, TypeLibList[i].MinorVersion,
      LanguageCode, pTypeLib);

    // TYPE_E_UNKNOWNLCID identifies that a library matching the
    // "LanguageCode" parameter of this function could not be loaded,
    // however an associated type library was found.
    if LoadResult <> S_OK then
      if (LoadResult <> TYPE_E_UNKNOWNLCID) or FailOnLanguageCodeMismatch then
      begin
        SetLength(UnregisteredTypeLibs, Length(UnregisteredTypeLibs) + 1);
        UnregisteredTypeLibs[Length(UnregisteredTypeLibs) - 1] := TypeLibList[i];
      end;
  finally
    pTypeLib := nil;  // Dereference interface.
  end;
  Result := Length(UnregisteredTypeLibs) = 0;
end;

procedure RegisterTypeLibrary(const ALibraryFileName: WideString);
var pTypeLib: ITypeLib;
    FailCode: HRESULT;
begin
  try
    FailCode := LoadTypeLib(pWideChar(ALibraryFileName), pTypeLib);
    if FailCode <> S_OK then
      raise ETypeLibRegistration.Create(Format(
        sTypeLibLoadFailed, [ALibraryFileName]), FailCode, etlfLoad);
    FailCode := RegisterTypeLib(pTypeLib, pWideChar(ALibraryFileName), nil);
    if FailCode <> S_OK then
      raise ETypeLibRegistration.Create(Format(
        sTypeLibRegFailed, [ALibraryFileName]), FailCode, etlfRegistration);
  except
    pTypeLib := nil;
    raise;  // Reraise the exception
  end;
end;

{ ETypeLibRegistration }

constructor ETypeLibRegistration.Create(const Message: string;
  FailCode: HRESULT; FailType: TTypeLibRegFailType);
begin
  FFailCode := FailCode;
  FFailType := FailType;
  inherited Create(Message);
end;

end.
