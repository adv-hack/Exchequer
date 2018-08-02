unit SpellUtil;

{$ALIGN 1}

interface
uses
  Controls, SpellLanguageComboBox, Forms, StdCtrls, Spellers;

type
  TSpell = class
  private
    FTheInvisibleForm : TForm;
    FLSSpellChecker : TSpellChecker;
    FmemToCheck : TMemo;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure CheckString(var sToCheck : string);
    procedure CheckMemo(memToCheck : TCustomMemo);
    procedure CheckEdit(edEdit : TCustomEdit);
    procedure CheckCombo(cmbCombo : TComboBox);
  end;

  procedure SpellCheckControl(TheControl : TWinControl);

implementation
uses
  Dialogs, APIUtil, SysUtils, ComCtrls, TEditVal{, idGlobal};

procedure TSpell.CheckMemo(memToCheck: TCustomMemo);
begin
  FLSSpellChecker.Check(memToCheck);
end;

procedure TSpell.CheckString(var sToCheck: string);
begin
  // use fake memo, cos that's what the spell checking component uses
  FmemToCheck.Clear;
  FmemToCheck.Lines.Add(sToCheck);

  // Run Spell Check
  FLSSpellChecker.Check(FmemToCheck);

  // Copy Result back from memo
  sToCheck := FmemToCheck.Lines[0];
end;

procedure TSpell.CheckEdit(edEdit : TCustomEdit);
begin
  // use fake memo, cos that's what the spell checking component uses
  FmemToCheck.Clear;
  FmemToCheck.Lines.Add(edEdit.Text);

  // Run Spell Check
  FLSSpellChecker.Check(FmemToCheck);

  // Copy Result back from memo
  edEdit.Text := FmemToCheck.Lines[0];
end;

procedure TSpell.CheckCombo(cmbCombo : TComboBox);
begin
  // use fake memo, cos that's what the spell checking component uses
  FmemToCheck.Clear;
  FmemToCheck.Lines.Add(cmbCombo.Text);

  // Run Spell Check
  FLSSpellChecker.Check(FmemToCheck);

  // Copy Result back from memo
  cmbCombo.Text := FmemToCheck.Lines[0];
end;

constructor TSpell.Create;
begin
  // create fake form for the memo to sit on.
  FTheInvisibleForm := TForm.Create(application);

  // create spell checker component, and set default properties
  FLSSpellChecker := TSpellChecker.Create(FTheInvisibleForm);
  FLSSpellChecker.SpellerType := sptISpell;
  FLSSpellChecker.Font.Name := 'Arial';
  FLSSpellChecker.Font.Size := 8;
  FLSSpellChecker.Options := [spoSuggestFromUserDict
  ,{spoIgnoreAllCaps,}spoIgnoreMixedDigits,spoIgnoreRomanNumerals];
  FLSSpellChecker.UserLanguage := ulEnglish;
  FLSSpellChecker.ModalDialog := TRUE;

//  FLSSpellChecker.FinishMessage := 'Spell Checking has been completed.';
//  FLSSpellChecker.ShowFinishMessage := TRUE;
//  FLSSpellChecker.ShowFinishMessage := FALSE;

  // Create fake memo - the spell checking component can only check a memo
  FmemToCheck := TMemo.Create(FTheInvisibleForm);
  FmemToCheck.Width := 2000;
  FmemToCheck.parent := FTheInvisibleForm;
end;

destructor TSpell.Destroy;
var
  bShowMessage : boolean;
begin
  bShowMessage := not FLSSpellChecker.Cancelled;

  // clear up
  Freeandnil(FmemToCheck);
  Freeandnil(FLSSpellChecker);
  FTheInvisibleForm.Release;
  FTheInvisibleForm := nil;

  if bShowMessage then MsgBox('Spell Checking has been completed.'
  ,mtInformation,[mbOK],mbOK,'Spell Checker');

  inherited;
end;

procedure SpellCheckControl(TheControl : TWinControl);
type
  TControlType = (ctNone, ctEdit, ctMemo, ctCombo);
var
  ControlType : TControlType;
  oSpell : TSpell;
begin
  try
    // Find out control type
    ControlType := ctNone;
    if (TheControl Is Text8Pt)
    and (not (TheControl as Text8Pt).ReadOnly)
    then ControlType := ctEdit
    else begin
      if (TheControl Is TEdit)
      and (not (TheControl as TEdit).ReadOnly)
      then ControlType := ctEdit
      else begin
        if (TheControl Is TComboBox)
        and ((TheControl as TComboBox).Style in [csDropDown, csSimple])
        then ControlType := ctCombo
        else begin
          if (TheControl Is TSBSComboBox)
          and ((TheControl as TSBSComboBox).Style in [csDropDown, csSimple])
          and (not (TheControl as TSBSComboBox).ReadOnly)
          then ControlType := ctCombo
          else begin
            if (TheControl Is TMemo)
            and (not (TheControl as TMemo).ReadOnly)
            then ControlType := ctMemo
            else begin
              if (TheControl Is TRichEdit)
              and (not (TheControl as TRichEdit).ReadOnly)
              then ControlType := ctMemo
            end;{if}
          end;{if}
        end;{if}
      end;
    end;{if}

    if ControlType <> ctNone then
    begin
      oSpell := TSpell.Create;

      // call appropriate method, depending on control type
      case ControlType of
        ctEdit : oSpell.CheckEdit(TheControl as TCustomEdit);
        ctMemo : oSpell.CheckMemo(TheControl as TCustomMemo);
        ctCombo : oSpell.CheckCombo(TheControl as TComboBox);
      end;{case}

      oSpell.Free;
    end;
  Except
    On E:Exception do MsgBox('The following error occurred when running the Spell Checker :'
    + #13#13 + E.Message, mtError, [mbOK], mbOK, 'Spell Check Error');
  end;{try}
end;

end.
