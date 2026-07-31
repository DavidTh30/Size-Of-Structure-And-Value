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
  Buffer: PByte; // Pointer to byte (built-in type)
  Count: Integer;
  I: Integer;
begin
  SendMessage_('clear');

  Count := 10; // Number of elements

  // Allocate memory for 10 bytes
  GetMem(Buffer, Count * SizeOf(Byte));

  try
    // Fill and access array using pointer indexing
    for I := 0 to Count - 1 do
    begin
      Buffer[I] := I * 10;
      SendMessage_({$i %LINE%}+ ' Element '+ I.ToString+ ': '+ Buffer[I].ToString);
    end;

  finally
    // Ensure memory is always freed
    FreeMem(Buffer, Count * SizeOf(Byte));
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Arr: array[0..4] of Char = ('H', 'e', 'l', 'l', 'o');
  Arr2: array of Char;
  Arr3: array[1..5] of Char;
  s: String;
  Size_:SizeUInt;
  i:integer;
begin
  SendMessage_('clear');
  SetString(s, PChar(@Arr[0]), Length(Arr));
  Size_:=SizeOf(Arr);
  SendMessage_({$i %LINE%}+ ' Side of static array String structure: '+IntToStr(Size_));
  Size_:=length(Arr);
  SendMessage_({$i %LINE%}+ ' Side of static array String: '+IntToStr(Size_));
  Size_:=SizeOf(s);
  SendMessage_({$i %LINE%}+ ' Side of String structure: '+IntToStr(Size_));
  Size_:=length(s);
  SendMessage_({$i %LINE%}+ ' Side of String: '+IntToStr(Size_));
  SendMessage_({$i %LINE%}+ ' s: "'+s+'"');

  SetLength(Arr2, 0);
  SetLength(Arr2, 5);
  //FillChar(Arr2, 5, chr(0));  //Why error?
  Arr2:='Hello';
  Arr2:= ['H', 'e', 'l', 'l', 'o'];
  s := PChar(Arr2);    //Why error?
  s := PChar(@Arr2);    //Automatically stops reading at the #0 terminator //Why error?
  s := StrPas(PChar(@Arr2));    //Automatically stops reading at the #0 terminator //Why error?
  Size_:=SizeOf(Arr2);
  SendMessage_({$i %LINE%}+ ' Side of dynamic array String structure: '+IntToStr(Size_));
  Size_:=length(Arr2);
  SendMessage_({$i %LINE%}+ ' Side of dynamic array String: '+IntToStr(Size_));
  Size_:=SizeOf(s);
  SendMessage_({$i %LINE%}+ ' Side of String structure: '+IntToStr(Size_));
  Size_:=length(s);
  SendMessage_({$i %LINE%}+ ' Side of String: '+IntToStr(Size_));
  SendMessage_({$i %LINE%}+ ' s: "'+s+'"');
  s := '';
  for i := Low(Arr2) to High(Arr2) do
    s := s + Arr2[i];
  Size_:=SizeOf(Arr2);
  SendMessage_({$i %LINE%}+ ' Side of dynamic array String structure: '+IntToStr(Size_));
  Size_:=length(Arr2);
  SendMessage_({$i %LINE%}+ ' Side of dynamic array String: '+IntToStr(Size_));
  Size_:=SizeOf(s);
  SendMessage_({$i %LINE%}+ ' Side of String structure: '+IntToStr(Size_));
  Size_:=length(s);
  SendMessage_({$i %LINE%}+ ' Side of String: '+IntToStr(Size_));
  SendMessage_({$i %LINE%}+ ' s: "'+s+'"');

  s := '';
  Arr3:='Hello';
  for i := Low(Arr3) to High(Arr3) do
    s := s + Arr3[I];
  Size_:=SizeOf(Arr3);
  SendMessage_({$i %LINE%}+ ' Side of static array String structure: '+IntToStr(Size_));
  Size_:=length(Arr3);
  SendMessage_({$i %LINE%}+ ' Side of static array String: '+IntToStr(Size_));
  Size_:=SizeOf(s);
  SendMessage_({$i %LINE%}+ ' Side of String structure: '+IntToStr(Size_));
  Size_:=length(s);
  SendMessage_({$i %LINE%}+ ' Side of String: '+IntToStr(Size_));
  SendMessage_({$i %LINE%}+ ' s: "'+s+'"');
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  MyPointer: Pointer;
  A_ChrPtr:A_Char_Ptr_;
  DataSize: Integer;
  s: String;
  Size_:SizeUInt;
  name_: array[1..100] of char;
  description: ^string;
  //Todo  Buffer: PChar;
begin
  SendMessage_('clear');

  DataSize := 100; { number of bytes }

  { Allocate memory }
  GetMem(MyPointer, DataSize);
  { Clear or use the memory block }
  FillChar(MyPointer^, DataSize, 0);    //Why error?
  //MyPointer^:='Hello';
  s := PChar(MyPointer^);
  Size_:=SizeOf(MyPointer^);
  SendMessage_({$i %LINE%}+ ' Side of Pointer structure: '+IntToStr(Size_));
  //Size_:=length(MyPointer^);
  //SendMessage_({$i %LINE%}+ ' Side of Pointer: '+IntToStr(Size_));
  Size_:=SizeOf(s);
  SendMessage_({$i %LINE%}+ ' Side of String structure: '+IntToStr(Size_));
  Size_:=length(s);
  SendMessage_({$i %LINE%}+ ' Side of String: '+IntToStr(Size_));
  SendMessage_({$i %LINE%}+ ' s: "'+s+'"');

  FreeMem(MyPointer, DataSize);

  { Allocate memory }
  GetMem(A_ChrPtr, DataSize);
  { Clear or use the memory block }
  FillChar(A_ChrPtr^, DataSize, 0);    //Why error?
  A_ChrPtr^:='Hello';    //Why error?
  A_ChrPtr^:=['H','E','L','L','O'];    //Why error?
  s := PChar(A_ChrPtr^);    //Why error?
  s := PChar(A_ChrPtr);    //Automatically stops reading at the #0 terminator //Why error?
  s := StrPas(PChar(A_ChrPtr));    //Automatically stops reading at the #0 terminator //Why error?
  Size_:=SizeOf(A_ChrPtr^);
  SendMessage_({$i %LINE%}+ ' Side of Pointer structure: '+IntToStr(Size_));
  //Size_:=length(A_ChrPtr^);
  //SendMessage_({$i %LINE%}+ ' Side of Pointer: '+IntToStr(Size_));
  Size_:=SizeOf(s);
  SendMessage_({$i %LINE%}+ ' Side of String structure: '+IntToStr(Size_));
  Size_:=length(s);
  SendMessage_({$i %LINE%}+ ' Side of String: '+IntToStr(Size_));
  SendMessage_({$i %LINE%}+ ' s: "'+s+'"');

  FreeMem(A_ChrPtr, DataSize);

  name_:= 'Zara Ali';
  s := 'Zara ali a DPS student.';

   description := getmem(30);
      if not assigned(description) then
         SendMessage_({$i %LINE%}+ ' Error - unable to allocate required memory')
      else
         FillChar(description^, 30, 0);

   (* Suppose you want to store bigger description *)
   description := reallocmem(description, 100);
   s := s + ' She is in class 10th.';
   description^:= s;     //Why error?;

   SendMessage_({$i %LINE%}+ ' Name = '+ name_ );
   SendMessage_({$i %LINE%}+ ' Description: '+ description^ );

   freemem(description);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   u,i,n:longword;
   base:byte;
   s:pchar;
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
   FS: TFormatSettings;
begin
  F := 1.2;
  SendMessage_('clear');
  SendMessage_({$i %LINE%}+' F='+ FloatToStr(F));
  Str(F:0:2, s);
  SendMessage_({$i %LINE%}+' F='+ s);
  SendMessage_({$i %LINE%}+' F='+ FormatFloat('#.##', F));
  FS := DefaultFormatSettings;
  FS.DecimalSeparator := '.';
  SendMessage_({$i %LINE%}+' F='+ FormatFloat('0.00', F, FS));
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

