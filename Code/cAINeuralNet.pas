{
  ai.planet
  http://aiplanet.sourceforge.net
  Created by Dave Kerr (kerrd@hotmail.com)
  $Id: cAINeuralNet.pas,v 1.1 2004/05/14 12:34:53 aidave Exp $
}
unit cAINeuralNet;

interface

uses Classes, cAIThings, cAIBaseObject, cAICoordinates, cAIPosition;

const
  cNeural = 0;

type

AINeuron = class;
AINeuronList = class;
AIConnection = class;
AIConnectionList = class;

// ============================================================================
AINeuralBrain = Class(AIBaseObject)
private
  fNeurons: AINeuronList;
  fConnections: AIConnectionList;
public
  Constructor Create(aParent: pointer);
  Destructor Destroy; override;

  property Neurons: AINeuronList read fNeurons;
  property Connections: AIConnectionList read fConnections;

{  procedure Fuel;

  function OneLineDisplay: string; override;
  procedure FullDisplay(aList: TStrings); override;
  procedure SaveToFile(var aFile: TextFile); override;
  procedure LoadFromFile(var aFile: TextFile); override;}
end;

// ----------------------------------------------------------------------------
AINeuron = Class(AIBaseObject)
private
  fConnections: AIConnectionList;
  fWeight: single;
public
{  Constructor Create(aEnvironment: pointer);
  Destructor Destroy; override;

  procedure SaveToFile(var aFile: TextFile);
  procedure LoadFromFile(var aFile: TextFile);}
end;

// ----------------------------------------------------------------------------
AIConnection = Class(AIBaseObject)
private
  fWeight: single;
  fInNeuron: AINeuron;
  fOutNeuron: AINeuron;
  fInNeuronHandle: integer;
  fOutNeuronHandle: integer;
public
end;

// ----------------------------------------------------------------------------
AINeuronList = Class(AIBaseContainer)
end;

// ----------------------------------------------------------------------------
AIConnectionList = Class(AIBaseContainer)
end;

implementation

uses
  SysUtils, VectorGeometry;

// ----------------------------------------------------------------------------
Constructor AINeuralBrain.Create(aParent: pointer);
begin
  inherited Create(aParent);

  fNeurons := AINeuronList.Create(self);
  fConnections := AIConnectionList.Create(self);
end;

// ----------------------------------------------------------------------------
Destructor AINeuralBrain.Destroy;
begin
  fConnections.Free;
  fNeurons.Free;

  inherited Destroy;
end;

end.
