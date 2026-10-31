{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cUtilities.pas,v 1.17 2003/11/27 22:21:20 aidave Exp $
}
unit cUtilities;

interface

uses
  Classes, VectorGeometry;

function BoolToStr(const aBoolean: boolean): string;
function BoolToYesNoStr(const aBoolean: boolean): string;
function BoolToGender(const aBoolean: boolean): string;
function PtrToStr(const aPointer: pointer): string;
function StandardizeText(const aString: string): string;
function ClockTime: comp;
function Pluralize(aString: string): string;
function RandomPolarity: integer;
function RandomSwing: single;
function AdjustValue(const aCurrent, aTarget, aAmount: single): single;
procedure writeFileBoolean(var aFile: TextFile; aBoolean: boolean);
function readFileBoolean(var aFile: TextFile): boolean;
function Max(const aNum1, aNum2, aNum3, aNum4: single): single; overload;
function Max(const aNum1, aNum2: single): single; overload;
function Max(const aNum1, aNum2, aNum3, aNum4, aNum5: single): single; overload;
function Max(const aNum1, aNum2, aNum3, aNum4, aNum5, aNum6, aNum7, aNum8, aNum9: single): single; overload;
function Min(const aNum1, aNum2, aNum3, aNum4: single): single; overload;
function Min(const aNum1, aNum2, aNum3: single): single; overload;
function Min(const aNum1, aNum2, aNum3, aNum4, aNum5: single): single; overload;
function Min(const aNum1, aNum2: single): single; overload;
function Avg(const aNum1, aNum2, aNum3, aNum4: single): single; overload;
function Avg(const aNum1, aNum2: single): single; overload;
function Cap(const aNumber, aCap: integer): integer;
function VectorToString(aVect: TVector): string; overload;
function VectorToString(aVect: TAffineVector): string; overload;
procedure LimitVector(var aVect: TAffineVector; const aMax: single);
procedure writeVector(var aFile: TextFile; var aVector: TAffineVector);
procedure readVector(var aFile: TextFile; var aVector: TAffineVector);
function AccumulativeSum(n:single; x:integer): single;

type

   TStopWatch = class(TObject)
      private
        fStartTick: comp;
        fEndTick: comp;
        fTiming: boolean;
      public
        Constructor Create;
        procedure Go;
        procedure Stop;
        function Timer: comp;
        function CurrentTime: comp;
        property Timing: boolean read fTiming;
   end;

implementation

uses SysUtils;


// ----------------------------------------------------------------------------
function BoolToStr(const aBoolean: boolean): string;
begin
  if aBoolean then
    result := 'true'
  else
    result := 'false';
end;

// ----------------------------------------------------------------------------
function BoolToYesNoStr(const aBoolean: boolean): string;
begin
  if aBoolean then
    result := 'yes'
  else
    result := 'no';
end;

// ----------------------------------------------------------------------------
function PtrToStr(const aPointer: pointer): string;
begin
  result := '$' + IntToHex(integer(aPointer), 6);
end;

// ----------------------------------------------------------------------------
function StandardizeText(const aString: string): string;
begin
  result := StringReplace(aString, ' ', '', [rfReplaceAll]);
  result := StringReplace(result, '-', '', [rfReplaceAll]);
end;

// ----------------------------------------------------------------------------
function ClockTime: comp;
begin
  result := TimeStampToMSecs(DateTimeToTimeStamp(Now));
end;

// ----------------------------------------------------------------------------
function Pluralize(aString: string): string;
begin
  result := aString + 's';
end;

// ----------------------------------------------------------------------------
function RandomPolarity: integer;
begin
  result := Random(3) - 1;
end;

// ----------------------------------------------------------------------------
// move the Current value towards the Target value by an amount
function AdjustValue(const aCurrent, aTarget, aAmount: single): single;
begin
  result := aCurrent;

  // adjust value up
  if result < aTarget then
  begin
    result := result + aAmount;
    if result > aTarget then
      result := aTarget;
  end
  else
  // adjust value down
  if result > aTarget then
  begin
    result := result - aAmount;
    if result < aTarget then
      result := aTarget;
  end;
end;

// ----------------------------------------------------------------------------
procedure writeFileBoolean(var aFile: TextFile; aBoolean: boolean);
begin
  if aBoolean then
    writeln(aFile, '0')
  else
    writeln(aFile, '1');
end;

// ----------------------------------------------------------------------------
function readFileBoolean(var aFile: TextFile): boolean;
var
  i: integer;
begin
  readln(aFile, i);
  if i = 0 then
    result := true
  else
    result := false;
end;

Constructor TStopWatch.Create;
begin
  inherited Create;

  fTiming := false;
  fStartTick := 0;
  fEndTick := 0;
end;

procedure TStopWatch.Go;
begin
  fTiming := true;
  fStartTick := ClockTime;
end;

procedure TStopWatch.Stop;
begin
  fEndTick := ClockTime;
  fTiming := false;
end;

function TStopWatch.Timer: comp;
begin
  result := (fEndTick - fStartTick);
end;

function TStopWatch.CurrentTime: comp;
begin
  result := (ClockTime - fStartTick);
end;

function Max(const aNum1, aNum2, aNum3, aNum4: single): single;
begin
  result := aNum1;
  if aNum2 > result then result := aNum2;
  if aNum3 > result then result := aNum3;
  if aNum4 > result then result := aNum4;
end;

function Min(const aNum1, aNum2, aNum3, aNum4: single): single;
begin
  result := aNum1;
  if aNum2 < result then result := aNum2;
  if aNum3 < result then result := aNum3;
  if aNum4 < result then result := aNum4;
end;

function Min(const aNum1, aNum2: single): single;
begin
  result := aNum1;
  if aNum2 < result then result := aNum2;
end;

function Min(const aNum1, aNum2, aNum3, aNum4, aNum5: single): single;
begin
  result := aNum1;
  if aNum2 < result then result := aNum2;
  if aNum3 < result then result := aNum3;
  if aNum4 < result then result := aNum4;
  if aNum5 < result then result := aNum5;
end;

function Min(const aNum1, aNum2, aNum3: single): single;
begin
  result := aNum1;
  if aNum2 < result then result := aNum2;
  if aNum3 < result then result := aNum3;
end;

function Max(const aNum1, aNum2: single): single;
begin
  result := aNum1;
  if aNum2 > result then result := aNum2;
end;

function Max(const aNum1, aNum2, aNum3, aNum4, aNum5: single): single;
begin
  result := aNum1;
  if aNum2 > result then result := aNum2;
  if aNum3 > result then result := aNum3;
  if aNum4 > result then result := aNum4;
  if aNum5 > result then result := aNum5;
end;

function Max(const aNum1, aNum2, aNum3, aNum4, aNum5, aNum6, aNum7, aNum8, aNum9: single): single;
begin
  result := aNum1;
  if aNum2 > result then result := aNum2;
  if aNum3 > result then result := aNum3;
  if aNum4 > result then result := aNum4;
  if aNum5 > result then result := aNum5;
  if aNum6 > result then result := aNum6;
  if aNum7 > result then result := aNum7;
  if aNum8 > result then result := aNum8;
  if aNum9 > result then result := aNum9;
end;

function Cap(const aNumber, aCap: integer): integer;
begin
  result := aNumber;
  if result > aCap then
    result := aCap;
end;

function RandomSwing: single;
begin
  result := Random - 0.5;
end;

function Avg(const aNum1, aNum2, aNum3, aNum4: single): single;
begin
  result := (aNum1 + aNum2 + aNum3 + aNum4) / 4;
end;

function Avg(const aNum1, aNum2: single): single;
begin
  result := (aNum1 + aNum2) / 2;
end;

function VectorToString(aVect: TVector): string;
begin
  result := Format('x=%0.2f y=%0.2f z=%0.2f', [aVect[0], aVect[1], aVect[2]])
end;

function VectorToString(aVect: TAffineVector): string;
begin
  result := Format('x=%0.2f y=%0.2f z=%0.2f', [aVect[0], aVect[1], aVect[2]])
end;

function BoolToGender(const aBoolean: boolean): string;
begin
  if aBoolean then
    result := 'Female'
  else
    result := 'Male';
end;

procedure LimitVector(var aVect: TAffineVector; const aMax: single);
var
  mySpeed: single;
begin
  mySpeed := VectorLength(aVect);
  if mySpeed > aMax then
  begin
    aVect[0] := (aVect[0] / mySpeed) * aMax;
    aVect[1] := (aVect[1] / mySpeed) * aMax;
    aVect[2] := (aVect[2] / mySpeed) * aMax;
  end;
end;

procedure writeVector(var aFile: TextFile; var aVector: TAffineVector);
begin
  writeln(aFile, aVector[0]);
  writeln(aFile, aVector[1]);
  writeln(aFile, aVector[2]);
end;

procedure readVector(var aFile: TextFile; var aVector: TAffineVector);
begin
  readln(aFile, aVector[0]);
  readln(aFile, aVector[1]);
  readln(aFile, aVector[2]);
end;

function AccumulativeSum(n:single; x:integer): single;
var
  i: integer;
begin
  result := 0;
  for i:=1 to x do
    result := result + n*Variant(i*(x-i+1));
end;

end.
