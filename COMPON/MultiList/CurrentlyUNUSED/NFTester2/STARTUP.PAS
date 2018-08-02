unit startup;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, AdPacket, OoMisc, AdPort, MPComms, APIUtil, VarConst
  ,BTSupU1, CardProc, ComCtrls;

type
  TFrmStartUp = class(TForm)
    Panel1: TPanel;
    lMessage: TLabel;
    Image1: TImage;
    btnTryAgain: TButton;
    btnContinue: TButton;
    lvTills: TListView;
    procedure btnTryAgainClick(Sender: TObject);
    procedure timContinueTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    bKeepChecking, bAllFound : boolean;
  public
    iTillsFound : integer;
    procedure CheckForLastTill(iTillNo : integer);
    procedure CheckForTills;
  end;

{var
  FrmStartUp: TFrmStartUp;}

implementation
uses
  main, Comms;

{$R *.DFM}

procedure TFrmStartUp.CheckForTills;
var
  iTill : integer;
begin
  bKeepChecking := TRUE;
  while bKeepChecking do begin
    Screen.Cursor := crHourglass;

    FrmComms.MPComms.Enabled := TRUE;

    iTillsFound := 0;
    bAllFound := TRUE;

    for iTill := 0 to lvTills.Items.Count - 1 do begin
      lvTills.Items[iTill].Subitems[2] := '';
      lvTills.Items[iTill].Subitems[3] := '';
    end;{for}

    btnContinue.Enabled := FALSE;
    btnTryAgain.Enabled := FALSE;
    if FrmComms.MPComms.Enabled then
      begin
        {sends a message to MPComms object asking for all the till names}
        lMessage.Caption := 'Checking for tills';
        FrmComms.GetTillName(59, TRUE);
      end
    else begin
      if Visible then
        begin
          lMessage.Caption := 'Com Port in Use';
          btnContinue.Enabled := TRUE;
          btnTryAgain.Enabled := TRUE;
          bKeepChecking := FALSE;
          Screen.Cursor := crDefault;
        end
      else begin
        {Com Port in use on startup - display message}
        Screen.Cursor := crDefault;
        if MsgBox('The specified Com Port is already in use by another application.'
        + CHR(13) + CHR(13) + 'Communications to the till will now be disabled.' + CHR(13) + CHR(13) +
        'To re-enable comms, please close the application which is accessing the Com Port.',mtError
        ,[mbCancel, mbRetry], mbRetry, 'Com Port in Use') = mrCancel then bKeepChecking := FALSE;
      end;{if}
    end;{if}
  end;{while}
end;

procedure TFrmStartUp.btnTryAgainClick(Sender: TObject);
begin
  CheckForTills;
end;

procedure TFrmStartUp.CheckForLastTill(iTillNo : integer);
var
  iTill : integer;
  sMessage : string;
begin
  bKeepChecking := FALSE;
  lMessage.Caption := lMessage.Caption + '.';
  Refresh;
  if (iTillNo = Syss.NoTills) then
    begin
      {Last Till}
      Screen.Cursor := crDefault;
      btnTryAgain.Enabled := TRUE;
      btnContinue.Enabled := TRUE;
      if (iTillsFound = Syss.NoTills) then
        {all tills found}
        begin
          if Visible then
            begin
              lMessage.Caption := 'All Tills Found.';
              for iTill := 0 to lvTills.Items.Count - 1 do begin
                if lvTills.Items[iTill].Subitems[3] = 'No' then begin
                  lMessage.Caption := 'Till IDs do not match.';
                  bAllFound := FALSE;
                end;{if}
              end;{for}
            end
          else begin
            sMessage := '';
            for iTill := 0 to lvTills.Items.Count - 1 do begin
              if lvTills.Items[iTill].Subitems[3] = 'No' then sMessage := sMessage + lvTills.Items[iTill].Subitems[0]
              + ' : ' + lvTills.Items[iTill].Subitems[1] + ' / ' + lvTills.Items[iTill].Subitems[2] + CHR(13);
            end;{for}

            if sMessage <> '' then begin
              bAllFound := FALSE;
              if MsgBox('Till IDs do not match' + CHR(13) + CHR(13) + sMessage + CHR(13) +
              'Do you wish to try again ?',mtConfirmation,[mbRetry, mbCancel],mbRetry,'Tills Found') = mrRetry
              then bKeepChecking := TRUE;
            end;{if}
          end;
        end
      else begin
        {tills not all found}
        if Visible then lMessage.Caption := IntToStr(iTillsFound) + ' out of ' + IntToStr(Syss.NoTills) + ' tills were found.'
        else begin
          if MsgBox('Only ' + IntToStr(iTillsFound) + ' out of ' + IntToStr(Syss.NoTills)
          + ' tills were found.' + CHR(13) + 'Do you wish to try again ?',mtConfirmation
          ,[mbRetry, mbCancel],mbRetry,'Tills Found') = mrRetry then bKeepChecking := TRUE;
        end;
        bAllFound := FALSE;
      end;
      SetCommsWorking(bAllFound);
    end
  else begin
  end;{if}
end;

procedure TFrmStartUp.timContinueTimer(Sender: TObject);
begin
  btnContinueClick(Self);
end;

procedure TFrmStartUp.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := bAllFound;
  if not bAllFound then begin
    {Tills not all found}
    if (MsgBox('You will not be able to communicate with all your tills and many features will be disabled.'
    + CHR(13) + CHR(13) + 'Are you sure that you want to continue ?',mtWarning,[mbYes,mbNo],mbNo
    ,'Continue Regardless?') = mrYes) then CanClose := TRUE;
  end;{if}
end;

procedure TFrmStartUp.FormCreate(Sender: TObject);
var
  NewItem : TListItem;
  iTill : integer;
begin
  with Syss do begin
    for iTill := 1 to NoTills do begin
      NewItem := lvTills.Items.Add;
      NewItem.Caption := IntToStr(iTill);
      NewItem.SubItems.Add(Syss.Till[iTill].Name);
      NewItem.SubItems.Add(Syss.Till[iTill].IdCode);
      NewItem.SubItems.Add('');
      NewItem.SubItems.Add('');
    end;{for}
  end;{with}
end;

procedure TFrmStartUp.btnContinueClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmStartUp.FormActivate(Sender: TObject);
begin
  Refresh;
  CheckForTills;
end;

end.
