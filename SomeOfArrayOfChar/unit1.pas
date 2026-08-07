unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, simpleipc, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Unit2, StrUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button2: TButton;
    Button3: TButton;
    CmdClear: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    Shape1: TShape;
    SimpleIPCClient1: TSimpleIPCClient;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
  if EventsList <> nil then begin EventsList.Free; EventsList:=nil; end;
  SendMessage_('clear');
  SendMessage_({$i %LINE%}+ ': Goodby');
end;

procedure TForm1.CmdClearClick(Sender: TObject);
begin
  SendMessage_('clear');
  EventsList.Clear;
  Memo1.Lines.Assign(EventsList);
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
  SendMessage_({$i %LINE%}+ ' Side of static array String structure Arr: '+IntToStr(Size_));
  Size_:=length(Arr);
  SendMessage_({$i %LINE%}+ ' Side of static array String Arr: '+IntToStr(Size_));
  Size_:=SizeOf(s);
  SendMessage_({$i %LINE%}+ ' Side of String structure Arr: '+IntToStr(Size_));
  Size_:=length(s);
  SendMessage_({$i %LINE%}+ ' Side of String Arr: '+IntToStr(Size_));
  SendMessage_({$i %LINE%}+ ' s: "'+s+'"');

  SetLength(Arr2, 0);
  SetLength(Arr2, 5);
  //Arr2:='Hello';
  Arr2:= ['H', 'e', 'l', 'l', 'o'];
  ////FillChar(Arr2[0], 5, ''); this is for rebuild Structure
  SendMessage_({$i %LINE%}+ ' FillChar(Arr2[0], 5, ''); this is for rebuild Structure');
  Assert(Length(Arr2) <> 0,'CreatedRandomFile: blank name not allowed');
  SetString(s, PChar(@Arr2[0]), Length(Arr2));
  Size_:=SizeOf(Arr2);
  SendMessage_({$i %LINE%}+ ' Side of dynamic array String structure Arr2: '+IntToStr(Size_));
  Size_:=length(Arr2);
  SendMessage_({$i %LINE%}+ ' Side of dynamic array String Arr2: '+IntToStr(Size_));
  Size_:=SizeOf(s);
  SendMessage_({$i %LINE%}+ ' Side of String structure Arr2: '+IntToStr(Size_));
  Size_:=length(s);
  SendMessage_({$i %LINE%}+ ' Side of String Arr2: '+IntToStr(Size_));
  SendMessage_({$i %LINE%}+ ' s: "'+s+'"');
  SendMessage_({$i %LINE%}+ ' Hex: "'+CharArrayToHexStr(Arr2)+'"');
  s := '';
  for i := Low(Arr2) to High(Arr2) do
    s := s + Arr2[i];
  Size_:=SizeOf(Arr2);
  SendMessage_({$i %LINE%}+ ' Side of dynamic array String structure Arr2: '+IntToStr(Size_));
  Size_:=length(Arr2);
  SendMessage_({$i %LINE%}+ ' Side of dynamic array String Arr2: '+IntToStr(Size_));
  Size_:=SizeOf(s);
  SendMessage_({$i %LINE%}+ ' Side of String structure Arr2: '+IntToStr(Size_));
  Size_:=length(s);
  SendMessage_({$i %LINE%}+ ' Side of String Arr2: '+IntToStr(Size_));
  SendMessage_({$i %LINE%}+ ' s: "'+s+'"');

  s := '';
  Arr3:='Hello';
  for i := Low(Arr3) to High(Arr3) do
    s := s + Arr3[I];
  Size_:=SizeOf(Arr3);
  SendMessage_({$i %LINE%}+ ' Side of static array String structure Arr3: '+IntToStr(Size_));
  Size_:=length(Arr3);
  SendMessage_({$i %LINE%}+ ' Side of static array String Arr3: '+IntToStr(Size_));
  Size_:=SizeOf(s);
  SendMessage_({$i %LINE%}+ ' Side of String structure Arr3: '+IntToStr(Size_));
  Size_:=length(s);
  SendMessage_({$i %LINE%}+ ' Side of String Arr3: '+IntToStr(Size_));
  SendMessage_({$i %LINE%}+ ' s: "'+s+'"');
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  BinData: array[0..2] of Byte;
  HexStr: array[0..5] of Char; // Needs 2 characters per byte + null terminator space if needed
  s: String;
begin
  // Fill sample binary data: values 10, 255, 0
  BinData[0] := 10;
  BinData[1] := 255;
  BinData[2] := 0;

  // Convert 3 bytes to hex characters
  BinToHex(@BinData[0], @HexStr[0], SizeOf(BinData));

  // HexStr now contains '0AFF00'

  SetString(s, PChar(@HexStr[0]), Length(HexStr));
  SendMessage_('clear');
  SendMessage_({$i %LINE%}+ ' Hex: "'+s+'"');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ServerOnline:=false;
  Application.OnIdle := @OnIdle;
  NoNeedServer:=false;
  EventsList:=TStringList.Create;
end;

end.

