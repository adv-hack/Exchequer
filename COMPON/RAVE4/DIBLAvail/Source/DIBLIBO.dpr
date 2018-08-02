library DIBLIBO;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  ShareMem,
  DIBLLinkMain in 'DIBLLinkMain.pas',
  LinkIL_IBO in '..\..\LinkIL_IBO.pas',
  ILConfig_Interbase in '..\..\ILConfig_Interbase.pas' {formILConfigInterbase},
  ILRegister in '..\..\ILRegister.pas',
  ILConfig in '..\..\ILConfig.pas',
  LinkIL in '..\..\LinkIL.pas',
  ILConfig_Default in '..\..\ILConfig_Default.pas' {formILConfigDefault};

{$E rvd}

{$R *.RES}

begin
end.
