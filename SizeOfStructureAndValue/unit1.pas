unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, simpleipc, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CmdClear: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    Shape1: TShape;
    SimpleIPCClient1: TSimpleIPCClient;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure CmdClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    procedure OnIdle(Sender: TObject; var Done: boolean);
  public
    procedure _tprintf(s:String);
    procedure SendMessage_(s:String);
  end;

var
  Form1: TForm1;
  NoNeedServer:boolean;
  ServerOnline:boolean;
  EventsList: TStringList;

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1._tprintf(s:String);
begin
  if (Upcase(s)='CLEAR') or (Upcase(s)='CLEAN') then
  begin
    Memo1.Clear;
    exit;
  end;
  Memo1.Append(s);
  if Memo1.Lines.Count > 34 then Memo1.Lines.Delete(0);
end;

procedure TForm1.SendMessage_(s:String);
var
  IPCClient: TSimpleIPCClient;
  CandidateIDs: array[0..3] of string;// Or array of string for older FPC versions
  SrvID: string;
begin

  _tprintf(s);

  // List of IDs you expect or want to test for
  //CandidateIDs := ['ServerOne', 'ServerTwo', 'AppInstance_123', 'MyServerID'];
  CandidateIDs[0]:='MessageLogConsole20';
  CandidateIDs[1]:='MessageLogConsole50';
  CandidateIDs[2]:='MessageLogConsole100';
  CandidateIDs[3]:='MessageLogConsole200';

  IPCClient := TSimpleIPCClient.Create(nil);
  try
    ServerOnline:=false;
    for SrvID in CandidateIDs do
    begin
      IPCClient.ServerID := SrvID;
      //IPCClient.Global := True; // Match the Global setting of your servers

      if IPCClient.ServerRunning then
      begin
        IPCClient.Active:=true;
        IPCClient.Connect;
        ServerOnline:=true;
        IPCClient.SendStringMessage(s);
        break;
      end;
    end;
  finally
    IPCClient.Disconnect;
    IPCClient.Active:=false;
    IPCClient.Free;
  end;

end;

procedure TForm1.OnIdle(Sender: TObject; var Done: boolean);
var
  IPCClient: TSimpleIPCClient;
  CandidateIDs: array[0..3] of string;// Or array of string for older FPC versions
  SrvID: string;
begin

  // List of IDs you expect or want to test for
  //CandidateIDs := ['ServerOne', 'ServerTwo', 'AppInstance_123', 'MyServerID'];
  CandidateIDs[0]:='MessageLogConsole20';
  CandidateIDs[1]:='MessageLogConsole50';
  CandidateIDs[2]:='MessageLogConsole100';
  CandidateIDs[3]:='MessageLogConsole200';

  IPCClient := TSimpleIPCClient.Create(nil);
  try
    ServerOnline:=false;
    for SrvID in CandidateIDs do
    begin
      IPCClient.ServerID := SrvID;
      //IPCClient.Global := True; // Match the Global setting of your servers

      if IPCClient.ServerRunning then
      begin
        IPCClient.Active:=true;
        IPCClient.Connect;
        ServerOnline:=true;
        break;
      end;
    end;
  finally
    IPCClient.Disconnect;
    IPCClient.Active:=false;
    IPCClient.Free;
  end;
  if ServerOnline then
  begin
    Label1.Caption:={$i %LINE%}+ ': '+'Connect';
    Shape1.Brush.Color:=clGreen;
  end;
  if not ServerOnline then
  begin
    Label1.Caption:={$i %LINE%}+ ': '+'Disonnect';
    Shape1.Brush.Color:=clSilver;
  end;

  Done:=false;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  EventsList.Free;
  SendMessage_('clear');
  SendMessage_({$i %LINE%}+ ': Goodby');
end;

procedure TForm1.CmdClearClick(Sender: TObject);
begin
  SendMessage_('clear');
  EventsList.Clear;
  Memo1.Lines.Assign(EventsList);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  TestStr:String;
  Size_:SizeUInt;
begin
  SendMessage_('clear');

  Size_:=SizeOf(boolean);
  SendMessage_({$i %LINE%}+ ' Side of boolean structure: '+IntToStr(Size_));

  Size_:=SizeOf(Integer);
  SendMessage_({$i %LINE%}+ ' Side of Integer structure: '+IntToStr(Size_));

  Size_:=SizeOf(Extended);
  SendMessage_({$i %LINE%}+ ' Side of Real structure: '+IntToStr(Size_));

  TestStr:='';
  Size_:=SizeOf(String);
  SendMessage_({$i %LINE%}+ ' Side of empty String structure: '+IntToStr(Size_));

  Size_:=length(TestStr);
  SendMessage_({$i %LINE%}+ ' Side of empty String: '+IntToStr(Size_));

  TestStr:=' A ';
  Size_:=SizeOf(String);
  SendMessage_({$i %LINE%}+ ' Side of empty String structure: '+IntToStr(Size_));

  Size_:=length(TestStr);
  SendMessage_({$i %LINE%}+ ' Side of empty String: '+IntToStr(Size_));
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  A_Bool: array of boolean;
  Size_:SizeUInt;
  T_A_Bool:A_Bool_;
  A_Bool_Ptr:A_Bool_Ptr_;
begin
  SendMessage_('clear');
  Size_:=SizeOf(A_Bool);
  SendMessage_({$i %LINE%}+ ' Side of array of boolean structure: '+IntToStr(Size_));
  Size_:=length(A_Bool);
  SendMessage_({$i %LINE%}+ ' Side of array of boolean: '+IntToStr(Size_));
  Size_:=SizeOf(A_Bool_);
  SendMessage_({$i %LINE%}+ ' Side of array of boolean structure: '+IntToStr(Size_));
  Size_:=SizeOf(A_Bool_Ptr_(A_Bool_Ptr));
  SendMessage_({$i %LINE%}+ ' Side of array of boolean structure by pointer: '+IntToStr(Size_));
  Size_:=length(T_A_Bool);
  SendMessage_({$i %LINE%}+ ' Side of Type array of boolean: '+IntToStr(Size_));

  SetLength(A_Bool, 11);
  Size_:=SizeOf(A_Bool);
  SendMessage_({$i %LINE%}+ ' Side of array of boolean structure: '+IntToStr(Size_));
  Size_:=length(A_Bool);
  SendMessage_({$i %LINE%}+ ' Side of array of boolean: '+IntToStr(Size_));
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  TestStr:String;
  TestStrPtr:Pchar;
  Size_:SizeUInt;
begin
  SendMessage_('clear');

  TestStr:='';
  Size_:=SizeOf(String);
  SendMessage_({$i %LINE%}+ ' Side of empty String structure: '+IntToStr(Size_));
  Size_:=length(TestStr);
  SendMessage_({$i %LINE%}+ ' Side of empty String: '+IntToStr(Size_));

  if length(TestStr) = 0 then TestStrPtr:=@TestStr;
  if length(TestStr) > 0 then TestStrPtr:=@TestStr[1];
  Size_:=SizeOf(Pchar(TestStrPtr));
  SendMessage_({$i %LINE%}+ ' Side of empty String structure by pointer: '+IntToStr(Size_));
  Size_:=length(Pchar(TestStrPtr));
  SendMessage_({$i %LINE%}+ ' Side of empty String by pointer: '+IntToStr(Size_));
  if length(TestStr) > 0 then
  begin
    TestStrPtr:=@TestStr[1];
    Size_:=length(TestStrPtr^);
    SendMessage_({$i %LINE%}+ ' Side of empty String by pointer: '+IntToStr(Size_));
    SendMessage_({$i %LINE%}+ ' Empty TestStrPtr^: '+TestStrPtr^);
    SendMessage_({$i %LINE%}+ ' Empty TestStrPtr^ Hex: '+IntToHex(Ord(TestStrPtr^), 2));
  end;

  TestStr:=' A ';
  Size_:=SizeOf(TestStr);
  SendMessage_({$i %LINE%}+ ' Side of String structure: '+IntToStr(Size_));
  Size_:=length(TestStr);
  SendMessage_({$i %LINE%}+ ' Side of String: '+IntToStr(Size_));

  if length(TestStr) = 0 then TestStrPtr:=@TestStr;
  if length(TestStr) > 0 then TestStrPtr:=@TestStr[1];
  Size_:=SizeOf(Pchar(TestStrPtr));
  SendMessage_({$i %LINE%}+ ' Side of empty String structure by pointer: '+IntToStr(Size_));
  Size_:=length(Pchar(TestStrPtr));
  SendMessage_({$i %LINE%}+ ' Side of empty String by pointer: '+IntToStr(Size_));
  if length(TestStr) > 0 then
  begin
    TestStrPtr:=@TestStr[1];
    Size_:=length(Pchar(TestStrPtr));
    SendMessage_({$i %LINE%}+ ' Side of String by pointer: '+IntToStr(Size_));
    SendMessage_({$i %LINE%}+ ' Pchar TestStrPtr: "'+Pchar(TestStrPtr)+'"');
    SendMessage_({$i %LINE%}+ ' string TestStrPtr: "'+string(TestStrPtr)+'"');
    SendMessage_({$i %LINE%}+ ' TestStrPtr^: "'+TestStrPtr^+'"');
    SendMessage_({$i %LINE%}+ ' TestStrPtr+1^: "'+(TestStrPtr+1)^+'"');
    SendMessage_({$i %LINE%}+ ' TestStrPtr+1^ Hex: '+IntToHex(Ord((TestStrPtr+1)^), 2));
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   u,i,n:longword;
   base:byte;
   s:pchar;
   g:string;
   f,r:single;
begin
  base:=16;
  SendMessage_('clear');
  SendMessage_('Integers');
  for i:=1 to 10 do
  begin
    n:=random(500);
    s:=uintTobase(n,base);
    u:=uintFromBase(s,base);
    SendMessage_('num = '+n.ToString+'  base '+base.ToString+' = '+pchar(s)+'   return = '+u.ToString+'   compare '+n.ToString+'='+u.ToString );
  end;

  SendMessage_('Floats');
  for i:=1 to 10 do
  begin
    r:=random* 500-random*500;
    s:=floattobase(r,base);
    f:=floatfrombase(s,base);
    SendMessage_('num = '+r.ToString+'  base '+base.ToString+' = '+pchar(s)+'   return = '+FloatToStr(f)+'   compare '+FloatToStr(r)+'='+FloatToStr(f) );
  end;

end;

procedure TForm1.Button5Click(Sender: TObject);
var
   F:single;
   s:string;
begin
  F := 1.2;
  SendMessage_('clear');
  SendMessage_({$i %LINE%}+' F='+ FloatToStr(F));
  Str(F:0:2, s);
  SendMessage_({$i %LINE%}+' F='+ s);
  SendMessage_({$i %LINE%}+' F='+ FormatFloat('#.##', F));
  SendMessage_({$i %LINE%}+' Hex='+ IntToHex(pQword(@F)^,8));
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  p: pointer;
  adr: PtrUInt;
  s:string;
  Size_:SizeUInt;
begin
  s:=' A ';
  p := @s;
  adr := PtrToI64(p);

  SendMessage_('clear');

  SendMessage_({$i %LINE%}+' s= "'+s+'"');
  SendMessage_({$i %LINE%}+' p^= "'+ Pchar(p^)+'"');
  SendMessage_({$i %LINE%}+' adr^= "'+ Pchar(pQword(adr)^)+'"');

  Size_:=SizeOf(s);
  SendMessage_({$i %LINE%}+ ' Side of structure: '+IntToStr(Size_));
  Size_:=SizeOf(Pchar(p));
  SendMessage_({$i %LINE%}+ ' Side of structure by pointer: '+IntToStr(Size_));
  Size_:=SizeOf(pQword(adr));
  SendMessage_({$i %LINE%}+ ' Side of structure by pointer: '+IntToStr(Size_));

  if length(s) > 0 then
  begin
    Size_:=length(s);
    SendMessage_({$i %LINE%}+ ' Side of string: '+IntToStr(Size_));
    Size_:=length(Pchar(p^));
    SendMessage_({$i %LINE%}+ ' Side of string by pointer: '+IntToStr(Size_));
    Size_:=length(Pchar(pQword(adr)^));
    SendMessage_({$i %LINE%}+ ' Side of string by pointer: '+IntToStr(Size_));
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ServerOnline:=false;
  Application.OnIdle := @OnIdle;
  NoNeedServer:=false;
  EventsList:=TStringList.Create;
end;

end.

