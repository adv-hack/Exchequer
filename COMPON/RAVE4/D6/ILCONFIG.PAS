unit ILConfig;

interface

uses
  {$IFDEF Linux}
  QForms, QControls, QGraphics,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms,
  {$ENDIF}
  SysUtils, Classes;

type
  TILConfig = class(TForm)
  private
  public
    class function Edit(var VDatasource, VOptions, VUsername, VPassword: string): boolean; overload; virtual;
    class function Edit(const ALinkType: string; var VDatasource, VOptions, VUsername, VPassword: string): boolean; overload;
  end;

  TILConfigClass = class of TILConfig;

implementation

uses
  ILRegister;

class function TILConfig.Edit(var VDatasource, VOptions, VUsername, VPassword: string): boolean;
begin
  Result := false;
end;

class function TILConfig.Edit(const ALinkType: string; var VDatasource, VOptions
 , VUsername, VPassword: string): boolean;
begin
  result := GILLinks.ByName(ALinkType).ConfigClass.Edit(VDatasource, VOptions, VUsername
   , VPassword);
end;

end.
