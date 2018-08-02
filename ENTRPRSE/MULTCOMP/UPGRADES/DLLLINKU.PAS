unit DLLLinkU;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ShareMem;

  Procedure SetCompanyDir(SD  :  String); STDCALL;

  Function ControlUpgrade(VerNo     :  String;
                          CompDir   :  String;
                      Var RErrStr   :  String;
                          ForceRun  :  Boolean)  :  Integer; STDCALL;

  function AddNewIndex(VerNo     :  String;
                       CompDir   :  String;
                   Var RErrStr   :  String)  :  Integer; STDCALL;

  function ConvertQuantityBreaks(Var RErrStr   :  String)  :  Integer; STDCALL;

  function AddJobAppsCustomFields(Var RErrStr   :  String)  :  Integer; STDCALL;

  function RunSepaUpgrade(var ErrStr : string) : Integer; STDCALL;

  function ExpirePlugIn(VerNo     :  String;
                        CompDir   :  String;
                        PlugIn    :  string;
                    Var RErrStr   :  String)  :  Integer; STDCALL;

  function UpdateBankReconcile(var ErrStr : string) : Integer; STDCALL;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Const
  UpgradeDLL  =  'GEUPGRDE.DLL';


  Function ControlUpgrade(VerNo     :  String;
                          CompDir   :  String;
                      Var RErrStr   :  String;
                          ForceRun  :  Boolean)  :  Integer; STDCALL;
                       EXTERNAL UpgradeDLL Name 'ControlUpgrade';


  Procedure SetCompanyDir(SD  :  String); STDCALL;
                          EXTERNAL UpgradeDLL Name 'SetCompanyDir';

  function AddNewIndex(VerNo     :  String;
                       CompDir   :  String;
                   Var RErrStr   :  String)  :  Integer; STDCALL;
                       EXTERNAL UpgradeDLL Name 'AddNewIndex';

  function ConvertQuantityBreaks(Var RErrStr   :  String)  :  Integer; STDCALL;
                       EXTERNAL UpgradeDLL Name 'ConvertQuantityBreaks';

  function AddJobAppsCustomFields(Var RErrStr   :  String)  :  Integer; STDCALL;
                       EXTERNAL UpgradeDLL Name 'AddJobAppsCustomFields';

  function RunSepaUpgrade(var ErrStr : string) : Integer; STDCALL;
                       EXTERNAL UpgradeDLL Name 'RunSepaUpgrade';

  function ExpirePlugIn(VerNo     :  String;
                        CompDir   :  String;
                        PlugIn    :  string;
                    Var RErrStr   :  String)  :  Integer; STDCALL;
                    EXTERNAL UpgradeDLL Name 'ExpirePlugIn';


  function UpdateBankReconcile(var ErrStr : string) : Integer; STDCALL;
                       EXTERNAL UpgradeDLL Name 'UpdateBankReconcile';

end.
