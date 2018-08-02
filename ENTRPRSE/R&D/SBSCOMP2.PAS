unit Sbscomp2;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls,ExtCtrls,Grids,Menus,GlobVar,SBSPanel;


Const
  // MH 20/05/2015 v7.0.14: Constants added as I got fed up of passing in unclear boolean values
  bHideButton = True;  
  bShowButton = False;

  bOrganiseButtons = True;
  bDontOrganiseButtons = False;


Type

  TVisiRec  =  Record
                 PanelObj,
                 LabelObj,
                 ThisObj   :  TObject;

                 HidePanel,
                 GotPanel  :  Boolean;

                 TmpFColor,
                 TmpColor  :  TColor;

                 ColOrder  :  Integer;

                 ShareX,
                 LabShareX,
                 MasterShareX,
                 MasterLabShareX,
                 Panel0Width,
                 HelpCId   :  Integer;
               end;

  TVisiList  =  Class(TList)
                  vUseOfSet,
                  MovingLab  :  Boolean;

                  SpaceGap,
                  Thislab,
                  MoveLab,
                  LabelX,
                  LabelY,
                  
                  fBarOfSet  :  Integer;

                  OldCursor  :  TCursor;

                  LabHedPanel:  TSBSPanel;

                  VisiRec    :  ^TVisiRec;

                  Destructor Destroy; override;


                  Procedure SetVisiRec(PObj,
                                       LObj      :   TObject);

                  Procedure AddVisiRec(PObj,
                                       LObj      :   TObject);

                  Procedure DestroyVisi;

                  Procedure ReAssignVR(Start  :  Integer;
                                       PObj,
                                       LObj   :  TObject);

                  Function IdPanel(Start  :  Integer;
                                   GetLab :  Boolean)  :  TSBSPanel;

                  Function IdOrdPanel(Start  :  Integer;
                                      GetLab :  Boolean)  :  TSBSPanel;

                  Procedure SetCoord(ColNo    :  Integer;
                                     Sender   :  TObject);

                  Function FindxColOrder(COrd  :  Integer)  :  Integer;

                  Function FindxHandle(Sender    :  TObject)  :  Integer;

                  Function FindxCoord(Coord     :  TPoint;
                                      FindPanel :  Boolean)  :  Integer;

                  Procedure ReSizeAll(Start  :  Integer);

                  Procedure ReSizeMove(Start :  Integer);


                  Procedure MoveCol(FromCol,ToCol  :  Integer);

                  Procedure PrimeMove(Sender  :  TObject);


                  Procedure MoveLabel(X,Y  :  Integer);

                  Procedure FinishMove;

                  Procedure SetHedPanel(SBOffSet     :  Integer);

                  Procedure SetHidePanel(PanelId  :  Integer;
                                         State,
                                         ReDraw   :  Boolean); overload;
                   Procedure SetHidePanel(PanelId  :  TSBSPanel;
                                         State,
                                         ReDraw   :  Boolean); overload;

                  Procedure AssignFromMaster(SourceV  :  TVisiList);

                  Procedure StoreXPos(Master  :  Boolean);

                  Procedure ReStoreXPos(Master  :  Boolean);

                  function ValidIndex(Index: Integer): Boolean;

                end; {TVisiList..}

{ ---------------------------------------------------------------------}

  TVisiBtns  =  Class(TList)

                  FoundFirstV,
                  SomeHidden :  Boolean;

                  FirstCount,
                  SecondCount:  SmallInt;

                  SpaceGap   :  Integer;

                  PresEnab   :  Boolean;

                  VisiRec    :  ^TVisiRec;

                  Destructor Destroy; override;

                  Procedure AddVisiRec(PObj      :   TObject;
                                       State     :   Boolean); virtual;


                  Procedure PWAddVisiRec(PObj      :   TObject;
                                         State     :   Boolean;
                                         HelpId    :   LongInt);
                                         
                  Procedure DestroyVisi;

                  Function FindxHandle(Sender    :  TObject)  :  Integer;

                  Procedure ReOrderAll(Start  :  Integer);

                  Function IdButton(Start  :  Integer)  :  TButton;

                  Procedure ReSetMenuStat(Var MI      :  TPopUpMenu;
                                       Const  VState,
                                              EState  :  Boolean);

                  Procedure SetMenuFBtn(MI      :  TMenuItem;
                                        BtnId   :  Integer);

                  Procedure HideButtons;

                  Procedure RefreshButtons;

                  Procedure SetHideBtn(PanelId  :  Integer;
                                       State,
                                       ReDraw   :  Boolean);

                  Procedure PWSetHideBtn(PanelId  :  Integer;
                                         State,
                                         ReDraw   :  Boolean;
                                         HelpId   :  LongInt);

                  Procedure SetBtnHelp(PanelId  :  Integer;
                                       HelpId   :  LongInt);

                  Procedure SetEnabBtn(State    :  Boolean);

                  Procedure ReSetButtons;

                end; {TVisiBtns..}

  TLVRec  =  Record
               CompName,
               ParentName  :  String;

               LastText,
               LastDate   :  ShortString;
               LastF9Value:  Double;
               LastByte   :  Byte;
               LastInt    :  Integer;
               LastChk    :  Boolean;
             end;

  { ---------------------------------------------------------------------}

  TLastValue =  Class(TList)

                  VisiRec    :  ^TLVRec;

                  fIncludeAll:  Boolean;
                  fGlobalUpdate:  Boolean;

                  Destructor Destroy; override;

                  Procedure SetLastValue(PObj      :   TComponent;
                                     Var VR        :   TLVRec);

                  Procedure GetLastValue(Var PObj      :   TComponent;
                                             VR        :   TLVRec);

                  Procedure AddVisiRec(PObj      :   TComponent);

                  Procedure DestroyVisi;

                  Function FindVisiRec(Sender    :  TComponent)  :  Integer;

                  Procedure StoreValue(Sender  :  TComponent);

                  Function GetValue(Var Sender  :  TComponent)  :  Boolean;

                  Procedure UpdateAllLastValues(Sender  :  TForm);
                  Procedure UpdateAllLastValuesFull(Sender  :  TForm);

                  Procedure GetAllLastValues(Sender  :  TForm);

                  Procedure GetAllLastValuesFull(Sender  :  TForm);

                  Property IncludeAll :  Boolean read fIncludeALL write fIncludeALL default FALSE;

                  Property GlobalUpdate :  Boolean read fGlobalUpdate write fGlobalUpdate default FALSE;
                end; {Class}


  { -----------------------------------------------------------------------}

  TThreadListRec  =  Record
                      TMember  :  Pointer;
                      TMembDesc:  ShortString;
                      TQId     :  LongInt;
                     end;

  TMonRec  =  Record
                 MLines   :  TStringList;
                 PTotal,
                 PCount,
                 THUpBar,
                 THUpStr,
                 THIdNo,
                 THPPCount,
                 THPPAddr:  LongInt;

                 THAbort,
                 THShowAbort,
                 THCanAbort,
                 THPrintJob,
                 THAbortPrint,
                 {THInPreview,}
                 THNeedPrint
                          :  Boolean;

                 THPriority
                          :  TThreadPriority;

                 THTaskDesc
                          :  Str255;

                 //SS:22/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
                 THShowProgress : Boolean;
              end;


  { ---------------------------------------------------------------------}

  TThreadList =  Class(TList)
                 Private
                   // MH 18/10/2010: Changed to use local copies of VisiRec to prevent any possibility of interference between routines
                   //VisiRec    :  ^TThreadListRec;

                   // Internal thread count used to identify threads on screen - continually increases, never resets
                   ThreadCount:  LongInt;

                   Procedure DestroyVisi;
                 Public
                   Constructor Create;

                   Destructor Destroy; override;{NF: added override 25/05/00}

                   Procedure AddVisiRec(PObj      :   Pointer;
                                        PDesc     :   ShortString);


                   Procedure DeleteQueue(IdNo  :  Integer);

                   Function IdRec(Start  :  Integer)  :  TThreadListRec;

                   Function FindxId(IdNo  :  LongInt)  :  Integer;
                End; { TThreadList }





  Procedure Match_VisiList(Source,Dest  :  TVisiList);


Var
  LastValueObj  :  TLastValue;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Mask,
  TEditVal,
  BorBtns,
  ETStrU,
  ETDateU,
  PWarnU;


{ ====================== TVisiList Methods ===================== }

Destructor TVisiList.Destroy;

Begin
  DestroyVisi;

  Inherited;
end;


Procedure TVisiList.SetVisiRec(PObj,
                               LObj      :   TObject);

Var
  UniLeft,
  UniWidth    :  Integer;

Begin
  try
    With VisiRec^ do
    Begin
      PanelObj:=PObj;
      ThisObj:=PObj;    {* Default this to Panel initialy *}
      LabelObj:=LObj;

      UniWidth:=(PanelObj as TSBSPanel).Width;
      UniLeft:=(PanelObj as TSBSPanel).Left;

      HelpCId:=(PanelObj as TSBSPanel).HelpContext;


      With LabelObj as TSBSPanel do
      Begin
        Width:=UniWidth-3;
        Left:=UniLeft;
      end;

    end;

  except

  end; {Except..}

end; {Proc..}


Procedure TVisiList.AddVisiRec(PObj,
                               LObj      :   TObject);

Var
  Idx  :  Integer;

Begin
  New(VisiRec);

  try
    With VisiRec^ do
    Begin
      FillChar(VisiRec^,Sizeof(VisiRec^),0);

      SetVisiRec(PObj,LObj);

      ColOrder:=Count;

      With (PanelObj as TSBSPanel) do {* Calculate Gap between Panels *}
      Case Count of
         0  :  SpaceGap:=Left+Width;
         1  :  SpaceGap:=Left-SpaceGap;
      end;

    end;

    Idx:=Add(VisiRec);



  except

    Dispose(VisiRec);

  end; {Except..}

end; {Proc..}


Procedure TVisiList.ReAssignVR(Start  :  Integer;
                               PObj,
                               LObj   :  TObject);


Begin
  // CJS 27/05/2010 -- additional validation
  If ValidIndex(Start) then
  Begin
    VisiRec:=List[Start];

    SetVisiRec(PObj,LObj);
  end;
end;




Procedure TVisiList.DestroyVisi;

Var
  n  :  Integer;


Begin

  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    try
      If (VisiRec<>Nil) then
        Dispose(VisiRec);

    Except
    end; {except..}
  end; {Loop..}
end; {Proc..}

Function TVisiList.IdPanel(Start  :  Integer;
                           GetLab :  Boolean)  :  TSBSPanel;

Begin
  // CJS 27/05/2010 -- additional validation
  Result := nil;
  if ValidIndex(Start) then
  try
    VisiRec:=List[Start];

    If (GetLab) then
      Result:=TSBSPanel(VisiRec^.LabelObj)
    else
      Result:=TSBSPanel(VisiRec^.PanelObj);

  except

    Result:=nil;

  end;
end;


Function TVisiList.IdOrdPanel(Start  :  Integer;
                              GetLab :  Boolean)  :  TSBSPanel;

Begin
  // CJS 27/05/2010 -- additional validation
  Result := nil;
  if ValidIndex(Start) then
  try
    VisiRec:=List[Start];

    Result:=IdPanel(VisiRec^.ColOrder,GetLab);

  except

    Result:=nil;

  end;
end;





Procedure TVisiList.SetCoord(ColNo    :  Integer;
                             Sender   :  TObject);
Var
  L,T,R,B  :  Integer;

Begin
  // CJS 27/05/2010 -- additional validation
  If ValidIndex(ColNo) and (Sender is TStringGrid) then
  Begin
    VisiRec:=List[ColNo];

    If (VisiRec<>nil) then
    With VisiRec^ do
    Begin
      With (PanelObj as TSBSPanel) do
      Begin
        L:=Left+2;
        T:=Top+2;
        R:=Width-4;
        B:=Height-4;

      end;

      With (Sender as TStringGrid) do
      Begin
        Left:=L;
        Top:=T;
        Width:=R;
        Height:=B;
        Font:=(PanelObj as TSBSPanel).Font;
        Color:=(PanelObj as TSBSPanel).Color;
        ColWidths[0]:=Width-2;
        Visible:=Not HidePanel;
        Enabled:=Not HidePanel;
        HelpContext:=HelpCId;
      end;
    end; {With..}
  end; {If within bounds..}
end;


Function TVisiList.FindxColOrder(COrd  :  Integer)  :  Integer;

Var
  FoundOk  :  Boolean;
  Loop     :  Integer;

Begin
  // CJS 27/05/2010 -- additional validation
  Result := -1;
  if ValidIndex(COrd) then
  begin
    Loop:=COrd;

    VisiRec:=List[Loop];

    FoundOk:=(VisiRec^.ColOrder=COrd);

    If (Not FoundOk) then
      Loop:=0;

    While (Loop<=Pred(Count)) and (Not FoundOk) do
    Begin
      VisiRec:=List[Loop];

      FoundOk:=(VisiRec^.ColOrder=COrd);

      If (Not FoundOk) then
        Inc(Loop);

    end; {While..}

    If (FoundOk) then
      Result:=Loop
    else
      Result:=-1;
  end;
end; {Func..}


Function TVisiList.FindxHandle(Sender    :  TObject)  :  Integer;

Var
  LabFound,
  FoundOk  :  Boolean;
  n        :  Integer;


Begin
  n:=0;

  FoundOk:=False;

  While (n<=Pred(Count)) and (Not FoundOk) do
  Begin
    VisiRec:=List[n];

    try

      If (VisiRec<>Nil) then
        With VisiRec^ do
        Begin

          LabFound:=((Sender as TSBSPanel).Handle=(LabelObj as TSBSPanel).Handle);
          GotPanel:=((Sender as TSBSPanel).Handle=(PanelObj as TSBSPanel).Handle);

          FoundOk:=(GotPanel or LabFound);

          If (GotPanel) then
            ThisObj:=PanelObj
          else
            ThisObj:=LabelObj;

        end;

    except

    end; {Except..}

    If (Not FoundOk) then
      Inc(n);
  end; {While..}

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;
end; {Func..}


Function TVisiList.FindxCoord(Coord     :  TPoint;
                              FindPanel :  Boolean)  :  Integer;

Var
  LabFound,
  FoundOk  :  Boolean;
  n        :  Integer;

  ThisX,
  ThisXR   :  Integer;



Begin
  n:=0;

  FoundOk:=False;

  While (n<=Pred(Count)) and (Not FoundOk) do
  Begin
    VisiRec:=List[n];

    try

      If (VisiRec<>Nil) then
        With VisiRec^ do
        If (Not HidePanel) then
        Begin
          ThisX:=(LabelObj as TSBSPanel).Left;
          ThisXR:=(LabelObj as TSBSPanel).Width+ThisX;

          LabFound:=((Coord.X>=ThisX) and (Coord.X<=ThisXR));

          ThisX:=(PanelObj as TSBSPanel).Left;
          ThisXR:=(PanelObj as TSBSPanel).Width+ThisX;

          GotPanel:=((Coord.X>=ThisX) and (Coord.X<=ThisXR));

          FoundOk:=(GotPanel or LabFound);

          If (GotPanel) then
            ThisObj:=PanelObj
          else
            ThisObj:=LabelObj;

        end;

    except

    end; {Except..}

    If (Not FoundOk) then
      Inc(n);
  end; {While..}

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;
end; {Func..}


Procedure TVisiList.ReSizeAll(Start  :  Integer);

Var
  n,
  NewLeft  :  Integer;

Begin
  NewLeft := 0;
  // CJS 27/05/2010 -- additional validation
  If ValidIndex(Start) then
  Begin
    VisiRec:=List[Start];

    try

      If (VisiRec<>nil) then
        With VisiRec^ do
        Begin
          NewLeft:=(ThisObj as TSBSPanel).Left;

          If (Not HidePanel) then
          Begin
            NewLeft:=NewLeft+(ThisObj as TSBSPanel).Width+SpaceGap;

            If (Not GotPanel) then
            Begin
              With (PanelObj as TSBSPanel) do
                Width:=(ThisObj as TSBSPanel).Width;{+2; Removed, as causing panel of col 0
                                                         to be shown skinny. This was caused,
                                                         as got panel not being set by hide col routines}
            end
            else
            Begin
              With (LabelObj as TSBSPanel) do
                Width:=(ThisObj as TSBSPanel).Width;
            end;
          end;
        end;

      For n:=Succ(Start) to Pred(Count) do
      Begin

        VisiRec:=List[n];

        try

          If (VisiRec<>Nil) then
            With VisiRec^ do
            If (Not HidePanel) then
            Begin
              With (LabelObj as TSBSPanel) do
                Left:=NewLeft+fBarOfSet;

              With (PanelObj as TSBSPanel) do
              Begin
                Left:=NewLeft-(fBarOfSet*Ord(vUseOfSet));
                NewLeft:=NewLeft+Width+SpaceGap;
              end;
            end; {Width..}

        except;

        end;
      end; {Loop..}

    except

    end; {Except..}
  end; {If not moving last one..}

end; {Proc..}


Procedure TVisiList.ReSizeMove(Start  :  Integer);

Var
  IncX,
  n,
  NewLeft  :  Integer;

Begin
  IncX := 0;
  NewLeft := 0;
  // CJS 27/05/2010 -- additional validation
  If ValidIndex(Start) then
  Begin
    VisiRec:=List[Start];

    If (VisiRec<>nil) then
    With VisiRec^ do
    Begin
      IncX:=(PanelObj as TSBSPanel).Left;


      If (Not HidePanel) then
      Begin
        IncX:=IncX+(PanelObj as TSBSPanel).Width+SpaceGap;

        With (LabelObj as TSBSPanel) do
          Left:=(PanelObj as TSBSPanel).Left;
      end;
    end;

    For n:=Succ(Start) to Pred(Count) do
    Begin

      VisiRec:=List[n];

      try

        If (VisiRec<>Nil) then
          With VisiRec^ do
          If (Not HidePanel) then
          Begin
            With (LabelObj as TSBSPanel) do
              Left:=IncX;

            With (PanelObj as TSBSPanel) do
            Begin
              Left:=IncX;

              IncX:=IncX+Width+SpaceGap;
            end;


          end; {Width..}

      except;

      end;
    end; {Loop..}

  end; {If not moving last one..}

end; {Proc..}


Procedure TVisiList.MoveCol(FromCol,ToCol  :  Integer);

Var
  OrigPanel  :  TSBSPanel;

  TmpLeft    :  Integer;

Begin
  VisiRec:=List[0];

  With VisiRec^ do
    OrigPanel:=(PanelObj as TSBSPanel);

  TmpLeft:=OrigPanel.Left;

  Move(FromCol,ToCol);

  VisiRec:=List[0];

  With VisiRec^ do
    OrigPanel:=(PanelObj as TSBSPanel);

  OrigPanel.Left:=TmpLeft;

  ResizeMove(0);

end;

Procedure TVisiList.FinishMove;

Begin
  If (MovingLab) then
  Begin
    // CJS 27/05/2010 -- additional validation
    if ValidIndex(MoveLab) then
    begin
      VisiRec:=List[MoveLab];
      if VisiRec <> nil then
      With VisiRec^ do
        With (LabelObj as TSBSPanel) do
        Begin
          Color:=TmpColor;
          Font.Color:=TmpFColor;

          // MH 18/06/2012 v7.0 ABSEXCH-12952: Customised drag behaviour on btrieve list column headers
          If (Purpose = puBtrListColumnHeaderDragging) Then
            Purpose := puBtrListColumnHeader;
        end;
    end;
    Screen.Cursor:=OldCursor;
    MovingLab:=False;

  end;
end;


Procedure TVisiList.SetHedPanel(SBOffSet     :  Integer);

Var
  n  :  Integer;

Begin
  n:=Pred(Count);

  Repeat
    VisiRec:=List[n];

     With VisiRec^ do
       If (Not HidePanel) then
         With (PanelObj as TSBSPanel) do
            LabHedPanel.Width:=Left+SBOffSet+Width;

        Dec(n);

      Until (n<0) or (Not VisiRec^.HidePanel);

end; {Proc..}


Procedure TVisiList.PrimeMove(Sender  :  TObject);

Begin
  ThisLab:=FindxHandle(Sender);

  MovingLab:=(ThisLab>=0);

  IF (MovingLab) then
  Begin
    VisiRec:=List[ThisLab];
    // CJS 27/05/2010 -- additional validation
    if VisiRec <> nil then
    begin
      With VisiRec^,(LabelObj as TSBSPanel) do
      Begin
        TmpColor:=Color;
        TmpFColor:=Font.Color;
        Color:=clHighlight;
        Font.Color:=ClWhite;
        LabelX:=Left;
        LabelY:=Top;

        // MH 18/06/2012 v7.0 ABSEXCH-12952: Customised drag behaviour on btrieve list column headers
        If (Purpose = puBtrListColumnHeader) Then
          Purpose := puBtrListColumnHeaderDragging;
      end;

      MoveLab:=ThisLab;

      OldCursor:=Screen.Cursor;
      Screen.Cursor:=crDrag;
    end;
  end;
end;


Procedure TVisiList.MoveLabel(X,Y  :  Integer);

Var
  CurrLab  :  Integer;

Begin
  If (MovingLab) then
  Begin
    CurrLab:=FindxCoord(Point(LabelX+X,LabelY+Y),FALSE);

    If (CurrLab<>MoveLab) and (CurrLab>=0) then
    Begin
      VisiRec:=List[MoveLab];
      // CJS 27/05/2010 -- additional validation
      if VisiRec <> nil then
        With VisiRec^ do
          With (LabelObj as TSBSPanel) do
          Begin
            Color := TmpColor;
            Font.Color := TmpFColor;

            // MH 18/06/2012 v7.0 ABSEXCH-12952: Customised drag behaviour on btrieve list column headers
            If (Purpose = puBtrListColumnHeaderDragging) Then
              Purpose := puBtrListColumnHeader;
          end;

      MoveLab:=CurrLab;

      VisiRec:=List[MoveLab];
      if VisiRec <> nil then
        With VisiRec^ do
          With (LabelObj as TSBSPanel) do
          Begin
            TmpColor := Color;
            TmpFColor := Font.Color;
            Color := clHighlight;
            Font.Color := ClWhite;

            // MH 18/06/2012 v7.0 ABSEXCH-12952: Customised drag behaviour on btrieve list column headers
            If (Purpose = puBtrListColumnHeader) Then
              Purpose := puBtrListColumnHeaderDragging;
          end;
    end;
  end;
end;


Procedure TVisiList.SetHidePanel(PanelId  :  Integer;
                                 State,
                                 ReDraw   :  Boolean);


Begin
  // CJS 27/05/2010 -- additional validation
  if ValidIndex(PanelId) then
  begin
    VisiRec:=List[PanelId];
    if (VisiRec <> nil) then
    With VisiRec^ do
    Begin
      (PanelObj as TSBSPanel).Visible:=Not State;
      (LabelObj as TSBSPanel).Visible:=Not State;
      HidePanel:=State;
    end;

    If (ReDraw) then
      ReSizeAll(0);
  end;
end;

//RJ 08/02/2016 2016-R1 ABSEXCH-14990: Hiding Panel depend upon the Panel object , Overloaded Method instead of Default Index
Procedure TVisiList.SetHidePanel(PanelId  :  TSBSPanel;
                                 State,
                                 ReDraw   :  Boolean);
var
  n: Integer;
Begin
  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];
    if (VisiRec <> nil) then
    With VisiRec^ do
    Begin
      if (PanelObj as TSBSPanel)= PanelId  then
      begin
        (PanelObj as TSBSPanel).Visible:=Not State;
        (LabelObj as TSBSPanel).Visible:=Not State;
        HidePanel:=State;
        break;
      end;
    end;
  end;
  If (ReDraw) then
    ReSizeAll(0);
end;

{* Used with FindRecU to sync all the different tabs with any rezise/col order change between the tabs *}
Procedure TVisiList.AssignFromMaster(SourceV  :  TVisiList);

Var
  IncX,
  n,
  NewLeft  :  Integer;
  SourceVR :  ^TVisiRec;

Begin
  If (Count>=0) and (Assigned(SourceV)) then
  Begin
    vUseOfSet:=SourceV.vUseOfSet;
    MovingLab:=SourceV.MovingLab;

    SpaceGap:=SourceV.SpaceGap;
    Thislab:=SourceV.Thislab;
    MoveLab:=SourceV.MoveLab;
    LabelX:=SourceV.LabelX;
    LabelY:=SourceV.LabelY;
    fBarOfSet:=SourceV.fBarOfSet;


    For n:=0 to Pred(Count) do
    Begin

      VisiRec:=List[n];

      If (n<SourceV.Count) then
      Begin
        SourceVR:=SourceV.List[n];

        try

          If (VisiRec<>Nil) and (SourceVR<>nil) then
          With VisiRec^ do
          Begin
            PanelObj:=SourceVR^.PanelObj;

            LabelObj:=SourceVR^.LabelObj;

            ThisObj:=SourceVR^.ThisObj;

            HidePanel:=SourceVR^.HidePanel;

            GotPanel:=SourceVR^.GotPanel;

            TmpFColor:=SourceVR^.TmpFColor;
            TmpColor:=SourceVR^.TmpColor;
            ColOrder:=SourceVR^.ColOrder;

          end; {Width..}

        except;

        end; {Try..}
      end
      else
        Break;
    end; {Loop..}

  end; {If not moving last one..}

end; {Proc..}


{* Used with CustR3U to sync all the different tabs with any rezise/col order change between the tabs *}
Procedure TVisiList.StoreXPos(Master  :  Boolean);

Var
  LocalX,
  n        :  Integer;

Begin
  If (Count>=0) then
  Begin

    For n:=0 to Pred(Count) do
    Begin

      VisiRec:=List[n];


      If (VisiRec<>Nil) then
      With VisiRec^ do
      Begin

        If (Assigned(PanelObj)) and (Not HidePanel) then
          LocalX:=TPanel(PanelObj).Left
        else
          LocalX:=0;

        If (Master) then
          MasterShareX:=LocalX
        else
          ShareX:=LocalX;

        If (n=0) and (Master) then
          Panel0Width:=TPanel(PanelObj).Width;

        If (Assigned(LabelObj)) and (Not HidePanel) then
          LocalX:=TPanel(LabelObj).Left
        else
          LocalX:=0;

        If (Master) then
          MasterLabShareX:=LocalX
        else
          LabShareX:=LocalX;

      end; {With..}

    end; {Loop..}

  end; {If not moving last one..}

end; {Proc..}


Procedure TVisiList.ReStoreXPos(Master  :  Boolean);

Var
  LocalX,
  n        :  Integer;

Begin
  If (Count>=0) then
  Begin

    For n:=0 to Pred(Count) do
    Begin

      VisiRec:=List[n];


      If (VisiRec<>Nil) then
      With VisiRec^ do
      Begin

        If (Master) then
          LocalX:=MasterShareX
        else
          LocalX:=ShareX;

        If (Assigned(PanelObj)) and (Not HidePanel) and (LocalX<>0) then
        Begin
          TPanel(PanelObj).Left:=LocalX;

          If (n=0) and (Master) then
            TPanel(PanelObj).Width:=Panel0Width;

        end;

        If (Master) then
          LocalX:=MasterLabShareX
        else
          LocalX:=LabShareX;

        If (Assigned(LabelObj)) and (Not HidePanel) and (LocalX<>0) then
          TPanel(LabelObj).Left:=LocalX;

      end; {Width..}
    end; {Loop..}

  end; {If not moving last one..}

end; {Proc..}

// CJS 27/05/2010 -- additional validation
function TVisiList.ValidIndex(Index: Integer): Boolean;
{
  Checks that the specified Index falls within the current range of entries in
  the list.
}
begin
  Result := (Index > -1) and (Index < Count);
end;



{ =============================================================== }



{ ====================== TVisiBtns Methods ===================== }

Destructor TVisiBtns.Destroy;

Begin
  DestroyVisi;

  Inherited;
end;


Procedure TVisiBtns.AddVisiRec(PObj      :   TObject;
                               State     :   Boolean);

Var
  Idx  :  Integer;

Begin
  New(VisiRec);

  try
    With VisiRec^ do
    Begin
      FillChar(VisiRec^,Sizeof(VisiRec^),0);

      {$B-}
      If (Count=0) and (TWinControl(PObj).Parent is TScrollBox) then
      {$B+}{Reset scrollbox to top position so offset is always zero}
        With TScrollBox(TWinControl(PObj).Parent) do
          If (VertScrollBar.Position<>0) then
            VertScrollBar.Position:=0;


      PanelObj:=PObj;
      ThisObj:=PObj;    {* Default this to Panel initialy *}

      {Find the first two previously displayed buttons to work out the gap between them}

      If (Not FoundFirstV) or (Count=0) then
      Begin
        FoundFirstV:=TButton(PanelObj).Visible;

        If (FoundFirstV) then
        Begin
          FirstCount:=Count;
          SecondCount:=Succ(FirstCount);

        end
        else
        Begin
          FirstCount:=-1;
          SecondCount:=-1;
        end;
      end
      else
        If (Count=SecondCount) and ((TButton(PanelObj).Top<=1) or (Not TButton(PanelObj).Visible)) then
          SecondCount:=SecondCount+1;


      With (PanelObj as TButton) do {* Calculate Gap between Panels *}
      If (Count=FirstCount) then
        SpaceGap:=Top+Height
      else
        If (Count=(SecondCount)) then
          SpaceGap:=Top-SpaceGap
        else
          If (Count>SecondCount) and (Not FoundFirstV) then {Catch all, if none were displayed, then use a default}
            SpaceGap:=3;

      
    end;

    Idx:=Add(VisiRec);


    SetHideBtn(Pred(Count),State,BOff);

    If (Not SomeHidden) then
      SomeHidden:=VisiRec^.HidePanel;

  except

    Dispose(VisiRec);

  end; {Except..}

end; {Proc..}


Procedure TVisiBtns.PWAddVisiRec(PObj      :   TObject;
                                 State     :   Boolean;
                                 HelpId    :   LongInt);


Begin
  If (Not State) then
    State:=Not ChkAllowed_In(HelpId);

  AddVisiRec(PObj,State);
end;


Procedure TVisiBtns.DestroyVisi;

Var
  n  :  Integer;


Begin

  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    try
      If (VisiRec<>Nil) then
        Dispose(VisiRec);

    Except
    end; {except..}
  end; {Loop..}
end; {Proc..}


Function TVisiBtns.FindxHandle(Sender    :  TObject)  :  Integer;

Var
  FoundOk  :  Boolean;
  n        :  Integer;


Begin
  n:=0;

  FoundOk:=False;

  While (n<=Pred(Count)) and (Not FoundOk) do
  Begin
    VisiRec:=List[n];

    try

      If (VisiRec<>Nil) then
        With VisiRec^ do
        Begin

          GotPanel:=((Sender as TButton).Handle=(PanelObj as TButton).Handle);

          FoundOk:=GotPanel;

          If (GotPanel) then
            ThisObj:=PanelObj
          else
            ThisObj:=LabelObj;

        end;

    except

    end; {Except..}

    If (Not FoundOk) then
      Inc(n);
  end; {While..}

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;
end; {Func..}

Function TVisiBtns.IdButton(Start  :  Integer)  :  TButton;

Begin

  If (Start<Count) then
  Begin
    VisiRec:=List[Start];

    try

      Result:=TButton(VisiRec^.PanelObj);

    except

      Result:=nil;

    end;
  end
  else
    Result:=nil;

end;


Procedure TVisiBtns.SetMenuFBtn(MI      :  TMenuItem;
                                BtnId   :  Integer);
Var
  ThisBtn  :  TButton;

Begin
  ThisBtn:=IdButton(BtnId);

  If (ThisBtn<>nil) then
  Begin
    MI.Visible:=(ThisBtn.Visible and (MI.Visible));
    MI.Enabled:=(ThisBtn.Enabled and (MI.Enabled));
    MI.HelpContext:=ThisBtn.HelpContext;
  end;

end;


Procedure TVisiBtns.ReSetMenuStat(Var MI      :  TPopUpMenu;
                               Const  VState,
                                      EState  :  Boolean);

Var
  n :  Byte;


Begin
  With MI do
  For n:= 0 to Pred(Count) do
  Begin
    Items[n].Visible:=VState;
    
    Items[n].Enabled:=EState;
  end;

end;




Procedure TVisiBtns.ReOrderAll(Start  :  Integer);

Var
  n,
  NewLeftx  :  Integer;

Begin
  NewLeftx := 0;
  If (Start<Pred(Count)) then
  Begin
    VisiRec:=List[Start];

    try

      If (VisiRec<>nil) then
        With VisiRec^ do
        Begin
          NewLeftx:=(ThisObj as TButton).Top;

          If (Not HidePanel) then
            NewLeftx:=NewLeftx+(ThisObj as TButton).Height+SpaceGap;
        end;

      For n:=Succ(Start) to Pred(Count) do
      Begin

        VisiRec:=List[n];

        try

          If (VisiRec<>Nil) then
            With VisiRec^ do
            If (Not HidePanel) then
            Begin
              With (PanelObj as TButton) do
              Begin
                Top:=NewLeftx;
                NewLeftx:=NewLeftx+Height+SpaceGap;
              end;
            end; {Width..}

        except;

        end;
      end; {Loop..}

    except

    end; {Except..}
  end; {If not moving last one..}

end; {Proc..}


Procedure TVisiBtns.HideButtons;

Begin

  If (SomeHidden) then
    ReOrderAll(0);
end;

Procedure TVisiBtns.RefreshButtons;

Var
  n  :  Integer;

Begin

  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    SetHideBtn(n,VisiRec^.HidePanel,BOff);

  end;

  HideButtons;
end;


Procedure TVisiBtns.ReSetButtons;

Var
  n  :  Integer;

Begin

  For n:=0 to Pred(Count) do
  Begin

    SetHideBtn(n,BOff,BOff);

  end;

  HideButtons;
end;

Procedure TVisiBtns.SetHideBtn(PanelId  :  Integer;
                               State,
                               ReDraw   :  Boolean);


Begin

  VisiRec:=List[PanelId];

  With VisiRec^ do
  Begin
    (PanelObj as TButton).Visible:=Not State;

    If (Not PresEnab) then
      (PanelObj as TButton).Enabled:=Not State;

    HidePanel:=State;
  end;

  If (ReDraw) then
    ReOrderAll(0);

end;


Procedure TVisiBtns.PWSetHideBtn(PanelId  :  Integer;
                                 State,
                                 ReDraw   :  Boolean;
                                 HelpId   :  LongInt);


Begin

  If (Not State) then
    State:=Not ChkAllowed_In(HelpId);

  SetHideBtn(PanelId,State,ReDraw);
end;


Procedure TVisiBtns.SetBtnHelp(PanelId  :  Integer;
                               HelpId   :  LongInt);

Var
  TBtn  :  TButton;

Begin
  TBtn:=IDButton(PanelId);

  If (Assigned(TBtn) and (HelpID>=0)) then
    TBtn.HelpContext:=HelpId;
end;



Procedure TVisiBtns.SetEnabBtn(State    :  Boolean);

Var
  n  :  Integer;

Begin

  For n:=0 to Pred(Count) do
    If (IdButton(n).Visible) then
      IdButton(n).Enabled:=State;
end;


{ =============================================================== }


{ ====================== TLastValue Methods ===================== }

Destructor TLastValue.Destroy;

Begin
  DestroyVisi;

  Inherited;
end;

Procedure TLastValue.SetLastValue(PObj      :   TComponent;
                              Var VR        :   TLVRec);

Begin
  With VR do
  Begin
    If (PObj is TEditPeriod) then
    With (PObj as TEditPeriod) do
    Begin
      LastInt:=EYear;
      LastByte:=EPeriod;
    end
    else
      If (PObj is TEditDate) then
      With (PObj as TEditDate) do
      Begin
        LastText:=Text;
        LastDate:=DateValue;
      end
      else
        If (PObj is TMaskEdit) then
        With (PObj as TMaskEdit) do
        Begin
          LastText:=Text;
        end
        else
          If (PObj is TCurrencyEdit) then
          With (PObj as TCurrencyEdit) do
          Begin
            LastF9Value:=Value;
          end
          else
            If (PObj is TSBSComboBox) then
            With (PObj as TSBSComboBox) do
            Begin
              LastInt:=ItemIndex;
              LastText:=Text;
            end
            else
              If (PObj is TBorRadio) then
              With (PObj as TBorRadio) do
              Begin
                LastChk:=Checked;
              end
              else
                If (PObj is TBorCheck) then
                With (PObj as TBorCheck) do
                Begin
                  LastChk:=Checked;
                end
                else
                  If (PObj is TSBSUpDown) then
                  With (PObj as TSBSUpDown) do
                  Begin
                    LastInt:=Position;
                  end
                  else
                    { HM 14/10/97: Added for Report Writer support }
                    If (PObj is TMemo) then
                      With (PObj as TMemo) do Begin
                        LastText := Text;
                      End; { With }




  end; {With..}
end;


Procedure TLastValue.GetLastValue(Var PObj      :   TComponent;
                                      VR        :   TLVRec);
Var
  LastPr,
  LastYr  :  Byte;

Begin
  With VR do
  Begin
    If (PObj is TEditPeriod) then
    With (PObj as TEditPeriod) do
    Begin
      LastPr:=LastByte;
      LastYr:=Byte(LastInt);

      {Modified v4.31.005 as all report inputs now show periods and resetting the last value was failing}

      {Modified v4.32.001 as When F9 used with Show periods as months, caused an error}

      If (GlobalUpdate) then
        InitPeriod(LastPr,LastYr,True,True)
      else
      Begin
        Text:=Strip('A',[DateSeparator],SOutPeriod(LastByte,LastInt));
        EPeriod:=LastByte;
        EYear:=LastInt;
      end;

      Modified:=BOn;
    end
    else
      If (PObj is TEditDate) then
      With (PObj as TEditDate) do
      Begin
        Text:=LastText;
        DateValue:=LastDate;
        Modified:=BOn;
      end
      else
        If (PObj is TMaskEdit) then
        With (PObj as TMaskEdit) do
        Begin
          Text:=LastText;
          Modified:=BOn;
        end
        else
          If (PObj is TCurrencyEdit) then
          With (PObj as TCurrencyEdit) do
          Begin
            Value:=LastF9Value;
            Modified:=BOn;
          end
          else
            If (PObj is TSBSComboBox) then
            With (PObj as TSBSComboBox) do
            Begin
              ItemIndex:=LastInt;
              Text:=LastText;
              Modified:=BOn;
            end
            else
              If (PObj is TBorRadio) then
              With (PObj as TBorRadio) do
              Begin
                Checked:=LastChk;
                Modified:=BOn;
              end
              else
                If (PObj is TBorCheck) then
                With (PObj as TBorCheck) do
                Begin
                  Checked:=LastChk;
                  Modified:=BOn;
                end
                else
                  If (PObj is TSBSUpDown) then
                  With (PObj as TSBSUpDown) do
                  Begin
                    Position:=LastInt;
                  end
                  else
                    { HM 14/10/97: Added for Report Writer support }
                    If (PObj is TMemo) then
                      With (PObj as TMemo) do Begin
                        Text:=LastText;
                        Modified:=BOn;
                      End; { With }


  end; {With..}
end;


Procedure TLastValue.AddVisiRec(PObj      :   TComponent);

Var
  Idx  :  Integer;

Begin
  New(VisiRec);

  try
    With VisiRec^ do
    Begin
      FillChar(VisiRec^,Sizeof(VisiRec^),0);

      CompName:=PObj.Name;

      If (Assigned(PObj.Owner)) then
        ParentName:=PObj.Owner.Name;

      SetLastValue(PObj,VisiRec^);
    end;

    Idx:=Add(VisiRec);


  except

    Dispose(VisiRec);

  end; {Except..}

end; {Proc..}


Procedure TLastValue.DestroyVisi;

Var
  n  :  Integer;


Begin

  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    try
      If (VisiRec<>Nil) then
        Dispose(VisiRec);

    Except
    end; {except..}
  end; {Loop..}
end; {Proc..}



Function TLastValue.FindVisiRec(Sender    :  TComponent)  :  Integer;

Var
  FoundOk  :  Boolean;
  n        :  Integer;


Begin
  n:=0;

  FoundOk:=False;

  While (n<=Pred(Count)) and (Not FoundOk) do
  Begin
    VisiRec:=List[n];

    try

      If (VisiRec<>Nil) then
        With VisiRec^ do
        Begin

          FoundOk:=(Sender.Name=CompName);

          If (FoundOk) and (Assigned(Sender.Owner)) then
            FoundOk:=(ParentName=Sender.Owner.Name);

        end;

    except

    end; {Except..}

    If (Not FoundOk) then
      Inc(n);
  end; {While..}

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;
end; {Func..}



Procedure TLastValue.StoreValue(Sender  :  TComponent);

Var
  FoundInt  :  Integer;


Begin
  FoundInt:=FindVisiRec(Sender);

  If (FoundInt=-1) then
    AddVisiRec(Sender)
  else
  Begin
    VisiRec:=List[FoundInt];

    SetLastValue(Sender,VisiRec^);
  end;

end;

Function TLastValue.GetValue(Var Sender  :  TComponent)  :  Boolean;

Var
  FoundInt  :  Integer;


Begin
  FoundInt:=FindVisiRec(Sender);

  If (FoundInt>=0) then
  Begin
    VisiRec:=List[FoundInt];

    GetLastValue(Sender,VisiRec^);
  end;

  Result:=(FoundInt>=0);
end;


Procedure TLastValue.UpdateAllLastValues(Sender  :  TForm);

Var
  n  :  Integer;

Begin
  With Sender do
  Begin
    For n:=0 to Pred(ComponentCount) do
      If (Components[n].Tag=1) or (IncludeAll) then
        StoreValue(Components[n]);

  end;
end;


Procedure TLastValue.UpdateAllLastValuesFull(Sender  :  TForm);


Begin
  IncludeALL:=BOn;
  UpdateAllLastValues(Sender);
  IncludeALL:=BOff;
end;



Procedure TLastValue.GetAllLastValues(Sender  :  TForm);

Var
  n          :  Integer;
  ThisComp   :  TComponent;

Begin
  GlobalUpdate:=BOn;

  With Sender do
  Begin
    For n:=0 to Pred(ComponentCount) do
      If (Components[n].Tag=1) or (IncludeAll) then
      Begin
        ThisComp:=Components[n];
        GetValue(ThisComp);
      end;

  end;

  GlobalUpdate:=BOff;
end;


Procedure TLastValue.GetAllLastValuesFull(Sender  :  TForm);


Begin
  IncludeALL:=BOn;
  GetAllLastValues(Sender);
  IncludeALL:=BOff;
end;

{ -------------------------------------------------------------- }


{ ====================== TThreadList Methods ===================== }


Constructor TThreadList.Create;

Begin
  Inherited Create;

  ThreadCount:=0;

end;

Destructor TThreadList.Destroy;

Begin
  DestroyVisi;

  Inherited;
end;


Procedure TThreadList.AddVisiRec(PObj      :   Pointer;
                                 PDesc     :   ShortString);

Var
  VisiRec : ^TThreadListRec;
  Idx     : Integer;
Begin
  New(VisiRec);

  Inc(ThreadCount);

  try
    With VisiRec^ do
    Begin
      FillChar(VisiRec^,Sizeof(VisiRec^),0);
      TMember:=PObj;
      TMembDesc:=PDesc+' (T'+Form_Int(ThreadCount,0)+')';
      TQId:=ThreadCount;
    end;

    Idx:=Add(VisiRec);
  except
    Dispose(VisiRec);
  end; {Except..}
end; {Proc..}


Procedure TThreadList.DestroyVisi;
Var
  VisiRec : ^TThreadListRec;
  n       : Integer;
Begin
  For n:=0 to Pred(Count) do
  Begin
    VisiRec:=List[n];

    try
      If (VisiRec<>Nil) then
        Dispose(VisiRec);

    Except
    end; {except..}
  end; {Loop..}
end; {Proc..}

Procedure TThreadList.DeleteQueue(IdNo  :  Integer);
Var
  VisiRec : ^TThreadListRec;
Begin
  If (IdNo<=Pred(Count)) and (IdNo>=0) then
  Begin

    VisiRec:=List[IdNo];

    try
      If (VisiRec<>Nil) then
        Dispose(VisiRec);
    except
      List[IdNo]:=nil;
    end;

    try
      Delete(IdNo);
    except
      List[IdNo]:=nil;
    end;
  end;
end;


Function TThreadList.IdRec(Start  :  Integer)  :  TThreadListRec;
Var
  VisiRec : ^TThreadListRec;
Begin
  VisiRec:=List[Start];
  try
    Result:=VisiRec^;
  except

  end;
end;


Function TThreadList.FindxId(IdNo  :  LongInt)  :  Integer;

Var
  VisiRec : ^TThreadListRec;
  FoundOk : Boolean;
  n       : Integer;
Begin
  n:=0;

  FoundOk:=False;

  While (n<=Pred(Count)) and (Not FoundOk) do
  Begin
    VisiRec:=List[n];

    try

      If (VisiRec<>Nil) then
        With VisiRec^ do
        Begin

          FoundOk:=(IdNo=TQId);

        end;

    except

    end; {Except..}

    If (Not FoundOk) then
      Inc(n);
  end; {While..}

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;
end; {Func..}




{ -------------------------------------------------------------- }


{ ===== Proc to Set one Visi List from another ===== }

Procedure Match_VisiList(Source,Dest  :  TVisiList);

Var
  n  :  Byte;

Begin
  Source.VisiRec:=Source.List[0];

  For n:=0 to Pred(Dest.Count) do
  Begin
    Dest.VisiRec:=Dest.List[n];

    TSBSPanel(Dest.VisiRec^.PanelObj).Height:=TSBSPanel(Source.VisiRec^.PanelObj).Height;
  end; {Loop..}

end; {Proc..}

Initialization

  LastValueObj:=TLastValue.Create;

Finalization

  LastValueObj.Free;

end.
