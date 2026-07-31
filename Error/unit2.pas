unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

//libc.so linux
function  ultoa(T:longword;F:pointer;sz:integer):pchar ;cdecl external 'msvcrt.dll' name '_ultoa';
function strtoul (s:pchar;b:pointer;L: longint):longword ;cdecl external 'msvcrt.dll' name 'strtoul';

function uintToBase(N:longword;_base:byte):pchar;
function uintFromBase(s:pchar;_base:byte):longword ;

type
switch =record
case integer of
  0:(float:single);
  1:(value:longword);
end;

function floattobase(n:single;b:byte):pchar;
function floatfrombase(s:string;b:byte):single;
function PtrToI64(p:pointer):PtrUInt; inline;


type
  A_Bool_Ptr_ = ^A_Bool_;
  A_Bool_ = Array of boolean;
  A_Char_Ptr_ = ^A_Char_;
  A_Char_ = Array of Char;

implementation

function uintToBase(N:longword;_base:byte):pchar;
var
  s:ansistring;
   buffer:pchar;
begin
   setlength(s,50);
   buffer:=@s[1];
   ultoa(n,buffer,_base);
   result:= (buffer)
end;

function uintFromBase(s:pchar;_base:byte):longword ;
begin
   result:= strtoul(s,nil,_base);
end;

function floattobase(n:single;b:byte):pchar;
var
z:switch;
begin
    z.float:=n;
    result:= uinttobase(z.value,b);
end;

function floatfrombase(s:string;b:byte):single;
var
z:switch;
p:pchar;
begin
p:=@s[1] ;
    z.value:=uintfrombase(p,b);
    result:= z.float;
end;

function PtrToI64(p:pointer):PtrUInt; inline;
begin
  result := {%H-}PtrUInt(p);
end;


end.

