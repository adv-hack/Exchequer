program RaveCC;

{$APPTYPE CONSOLE}

uses
  RVLEDef, RVLEUtil, RVLEMod, RVLDComp, Classes;

var
  Compiler: TRaveDelphiCompiler;
  Module: TRCPUModule;
  Success: boolean;

begin
  Compiler := TRaveDelphiCompiler.Create;
  Module := TRCPUModule.Create;
  Success := true;
  IncludeErrPos := true;
  try
    try
      Compiler.CompileFile(ParamStr(1),Module);
    except
      on E: ERaveCompiler do begin
        Writeln('Error: ',E.Message);
        Success := false;
      end;
    end; { tryx }
  finally
    If Success then begin
      Writeln('Compile successful.');
      Module.SaveToFile(ParamStr(1));
    end; { if }
    Module.Free;
    Compiler.Free;
  end; { tryf }
end.