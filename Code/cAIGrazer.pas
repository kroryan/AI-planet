{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAIGrazer.pas,v 1.12 2003/11/27 22:21:19 aidave Exp $
}
unit cAIGrazer;

interface

uses Classes, cAIBaseObject, cAIThings, cAICommunity,
     cAIPosition, cAILife, cAILink, cAICreature, cAIMating;

type

// ============================================================================
// an individual Grazer
AIGrazer = Class(AIMatingCreature)
protected
  procedure WalkWithCommunity;
  procedure FindFood;
  procedure DevelopIntoBaby; override;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  procedure Fuel; override;
end;

implementation

uses
  cAIReality, SysUtils, cGlobals, cAIVibes, VectorGeometry, cUtilities;

// ----------------------------------------------------------------------------
Constructor AIGrazer.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cGrazer;
  Health := 1000;
  DevelopIntoBaby;
end;

// ----------------------------------------------------------------------------
destructor AIGrazer.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIGrazer.Fuel;
begin
  inherited Fuel;

  // determine desire
  desire := cDesireNone;
  if (Health < 4000) then
    desire := cDesireFood
  else
  begin
    case Stage of
      cCreatureBaby:  desire := cDesireWander;
      cCreatureAdult: desire := cDesireMate;
      cCreatureElder: desire := cDesireWander;
    end;
  end;

  case desire of
    cDesireFood: FindFood;
    cDesireWander: WalkWithCommunity;
    cDesireMate:
    begin
      MatingBehaviour;
      WalkWithCommunity;
    end;
  end;

  if Grabber.Holding then
  begin
    if Eat(64) then
    begin
      Noise(cNoiseEat, 1);
      if Size < 2 then
        Size := Size + 0.03;
      Position.SetSize(Size*2.5, Size*2.5, Size*2.5);
      Position.Mass := Position.SizeY;
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIGrazer.FindFood;
var
  myThing: AIThing;
begin
  if (desire = cDesireFood) and not Grabber.Holding then
  begin
    // apple is in sight
    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;

      if myThing.Position.Carried then
        Eyes.InvalidateTarget;

      if myThing.Position.Underwater then
        Eyes.InvalidateTarget;
    end;

    if Eyes.ValidTarget then
    begin
      myThing := Eyes.Target;
      Position.TurnTowardsTarget(myThing.Position, ca30);
      if Position.Velocity.XYStrength < 0.075 then
        Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.075);
      if (Position.DistancePlusHeightTo(myThing.Position) < 1.5) then
        Grab(myThing);
    end
    else // find apple
    begin
      myThing := gEnvironment.Things.Fruits.NearestAvailableNotUnderWaterThing(Position);
      if not (myThing = nil) then
        Eyes.AssignTarget(myThing);
    end;
  end;
end;

// ----------------------------------------------------------------------------
procedure AIGrazer.WalkWithCommunity;
var
  myCommunity: AICommunity;
  myForce: TAffineVector;
begin
  // in a Community?
  if Community.ValidTarget then
  begin
    myCommunity := AICommunity(Community.Target);

    if myCommunity.Position.UnderWater then
      exit;
    // Boids
    // http://www.vergenet.net/~conrad/boids/pseudocode.html
    // Rule 1: Boids try to fly towards the centre of mass of neighbouring boids.
    myForce[0] := (myCommunity.Center[0] - Position.X) / 400;
    myForce[1] := (myCommunity.Center[1] - Position.Y) / 400;
    myForce[2] := 0;
    // Rule 3: Boids try to match velocity with near boids.
    myForce[0] := myForce[0] + myCommunity.Velocity[0];
    myForce[1] := myForce[1] + myCommunity.Velocity[1];
    myForce[2] := myForce[2] + myCommunity.Velocity[2];
    // Limiting the speed
    LimitVector(myForce, 0.1);
    // Face direction of velocity
    Position.TurnTowardsVector(myForce, ca15);
    // move
    Position.Acceleration.ApplyAngularForce(Position.DirectionXY, VectorLength(myForce));
  end
  else // not in a Community
    JoinCommunity;
end;

// ----------------------------------------------------------------------------
procedure AIGrazer.DevelopIntoBaby;
begin
  Size := 0.4;
  Position.SetSize(Size*2.5, Size*2.5, Size*2.5);
  Position.Mass := Position.SizeY;
end;

end.

