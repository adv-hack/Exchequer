{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPERpt;

interface

procedure RaveRegister;

implementation

uses
  RVClass,
  RVCsRpt,
  RVProj,
  RVTool;

type
  TRaveBandEditor = class(TRaveComponentEditor)
    procedure AddToMenu(AddMenuItem: TAddMenuItemProc); override;
    procedure RunFromMenu(ID: integer); override;
  end; { TRaveBandEditor }

procedure RaveRegister;

begin { RaveRegister }
  RegisterRaveComponentEditor(TRaveBand,TRaveBandEditor);
end;  { RaveRegister }

(*****************************************************************************}
( class TRaveDataBandEditor
(*****************************************************************************)

procedure TRaveBandEditor.AddToMenu(AddMenuItem: TAddMenuItemProc);

begin { AddToMenu }
  AddMenuItem(nil,'Create',1,0);
  AddMenuItem(nil,'Body Header',10,1);
  AddMenuItem(nil,'Group Header',11,1);
  AddMenuItem(nil,'Row Header',12,1);
  AddMenuItem(nil,'Detail Band',13,1);
  AddMenuItem(nil,'Row Footer',14,1);
  AddMenuItem(nil,'Group Footer',15,1);
  AddMenuItem(nil,'Body Footer',16,1);
end;  { AddToMenu }

procedure TRaveBandEditor.RunFromMenu(ID: integer);

var
  Band: TRaveBand;
  DataBand: TRaveIterateBand;

  procedure ProcessBand(Band: TRaveBand;
                        PrintLoc: TBandPrintLoc);

  var
    I1: integer;
    InsertPoint: integer;

  begin { ProcessBand }
    Band.BandStyle.PrintLoc := [PrintLoc];
    InsertPoint := Band.ControllerBand.ChildIndex;
    If not (PrintLoc in [plBodyHeader,plGroupHeader,plRowHeader]) then begin
      Inc(InsertPoint);
    end; { if }
    For I1 := 1 to (Band.ChildIndex - InsertPoint) do begin
      Band.MoveBehind;
    end; { for }
  end;  { ProcessBand }

begin { RunFromMenu }
  If (ID < 10) or (ID > 16) then Exit;

  If Instance is TRaveIterateBand then begin
    DataBand := TRaveIterateBand(Instance);
  end else begin
    DataBand := TRaveBand(Instance).ControllerBand;
    If not Assigned(DataBand) then Exit;
  end; { else }

  If ID = 13 then begin
    Band := TRaveDataBand.Create(Instance.Owner);
  end else begin
    Band := TRaveBand.Create(Instance.Owner);
  end; { else }
  Band.Name := TRaveProjectManager(Band.Project).GetUniqueName({Trans-}'Band',Band.Owner as TRaveComponent,false);
  Band.Parent := DataBand.Parent;
  Band.ControllerBand := DataBand;
  Case ID of
    10: begin
      ProcessBand(Band,plBodyHeader);
    end;
    11: begin
      ProcessBand(Band,plGroupHeader);
    end;
    12: begin
      ProcessBand(Band,plRowHeader);
    end;
    13: begin
      ProcessBand(Band,plDetail);
    end;
    14: begin
      ProcessBand(Band,plRowFooter);
    end;
    15: begin
      ProcessBand(Band,plGroupFooter);
    end;
    16: begin
      ProcessBand(Band,plBodyFooter);
    end;
  end; { case }

end;  { RunFromMenu }

initialization
  RegisterProc('RVCL',RaveRegister);
end.
