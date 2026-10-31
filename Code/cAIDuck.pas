{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Aaron Hochwimmer and David Kerr
  $Id: cAIDuck.pas,v 1.27 2003/11/27 22:21:19 aidave Exp $
}
unit cAIDuck;

interface

uses Classes, cAIBaseObject, cAIThings,
     cAIPosition, cAILife, cAILink, cAICreature, cAICommunity,
     cAIMating;

type

// ============================================================================
// an individual Duck
AIDuck = Class(AIMatingCreature)
protected
  procedure FloatWithCommunity;
  procedure Float;
  procedure DevelopIntoBaby; override;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  procedure Fuel; override;
end;

implementation

uses
  cAIReality, SysUtils, cGlobals, cAITrees, cAIBird, cAIVibes, cUtilities,
  VectorGeometry;

// ----------------------------------------------------------------------------
Constructor AIDuck.Create(aParent: pointer);
begin
  inherited Create(aParent);

  Kind := cDuck;
  
  Size := 1;
  Position.SetSize(1, 0.75, 0.75, true);
  Position.SetProperties(5, 0.1, 4.5);
  Position.Collider := true;

  Health := 4000;
  Desire := cDesireWander;
end;

// ----------------------------------------------------------------------------
destructor AIDuck.Destroy;
begin

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
procedure AIDuck.Fuel;
begin
  inherited Fuel;

  if (Size < 1) and (Health > 1536) then
  begin
    Size := Size + 0.0002; // 5000 ticks to reach 1
    Position.SetSize(Size, Size, Size);
  end;

  desire := cDesireNone;
  if (Health < 3000) and not Grabber.Holding then
    desire := cDesireFood
  else
  begin
    case Stage of
      cCreatureBaby:  desire := cDesireWander;
      cCreatureAdult: desire := cDesireMate;
      cCreatureElder: desire := cDesireWander;
    end;
  end;

  // find food           yeah i need a new duck quack
  case desire of
    cDesireFood:
    begin
      case Stage of
        cCreatureBaby:  Forage(0.12);
        cCreatureAdult: ForageFruitAndPrey(0.11);
        cCreatureElder: Forage(0.1);
      end;

      if Bump then AvoidNeighbour;
    end;
    cDesireWander: FloatWithCommunity;
    cDesireMate:
    begin
      if Random(512)=0 then
        Noise(cNoiseQuack, 1);
      MatingBehaviour;
      FloatWithCommunity;
    end;
  end;

  if Grabber.Holding then
    if Eat(16) then Noise(cNoiseEat, 1);
end;

// ----------------------------------------------------------------------------
procedure AIDuck.FloatWithCommunity;
var
  myCommunity: AICommunity;
  myForce: TAffineVector;
begin
//  if not Position.UnderWater then exit;

  // in a Community?
  if Community.ValidTarget then
  begin
    myCommunity := AICommunity(Community.Target);
    // Boids
    // http://www.vergenet.net/~conrad/boids/pseudocode.html
    // Rule 1: Boids try to fly towards the centre of mass of neighbouring boids.
    myForce[0] := (myCommunity.Center[0] - Position.X) / 400;
    myForce[1] := (myCommunity.Center[1] - Position.Y) / 400;
    myForce[2] := 0;
    // Rule 2: Boids try to keep a small distance away from other objects (including other boids).
{    if Bump then
    begin
      myForce[0] := myForce[0] + Avoidance[0];
      myForce[1] := myForce[1] + Avoidance[1];
    end;}
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
    // make sure not to surface from underwater
    if Position.Height < (Position.Water -1) then
      Position.Acceleration.DeltaHeight := Position.Acceleration.DeltaHeight + 0.2;
  end
  else // not in a Community
    JoinCommunity;
end;

// ----------------------------------------------------------------------------
procedure AIDuck.Float;
begin
  Position.Acceleration.ApplyAngularForce(Position.DirectionXY, 0.05);
  Position.Velocity.LimitSpeed(0.1);
end;

// ----------------------------------------------------------------------------
procedure AIDuck.DevelopIntoBaby;
begin
  Size := 0.3;
  Position.SetSize(Size, Size, Size/2);
  Noise(cNoiseDuckling, 1);
end;

end.
