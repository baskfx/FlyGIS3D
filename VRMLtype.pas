unit VRMLtype;

interface

uses GL, GLU;

type

  SFEnum = ( AUTO, UNKNOWN_ORDERING, CLOCKWISE, COUNTERCLOCKWISE,
             UNKNOWN_SHAPE_TYPE, SOLID, UNKNOWN_FACE_TYPE, CONVEX,
             BINDINGS_DEFAULT, OVERALL, PER_PART, PER_PART_INDEXED,
             PER_FACE, PER_FACE_INDEXED, PER_VERTEX, PER_VERTEX_INDEXED,
             SFLEFT, SFCENTER, SFRIGHT );
  Float = GLfloat;

  SFFloat = real;//Float;
  MFFloat = Float;
  SFBool = boolean;
  SFVec3f = array [ 0..2 ] of SFFloat;
  SFColor = SFVec3f;
  MFVec3f = array [ 0..2 ] of SFFloat;
  MFColor = MFVec3f;
  SFRotation = array [ 0..3 ] of SFFloat;
  SFBitMask = longint;
  SFLong = longint;
  MFLong = longint;
  MFString = string;

  TCube = object
    width,
    height,
    depth : real;
  end;

  TSphere = object
    radius : SFFloat;
  end;

  TCone = object
    parts        : SFBitMask;
    bottomRadius : SFFloat;
    height       : SFFloat;
  end;

  TCoordinate3 = record
    point : MFVec3f;
  end;

  TShapeHints = object
    vertexOrdering : SFEnum;
    shapetype      : SFEnum;
    facetype       : SFEnum;
    creaseAngle    : SFFloat;
  end;

  TSpotLight = object
    lightOn     : SFBool;
    intensity   : SFFloat;
    color       : SFVec3f;
    location    : SFVec3f;
    direction   : SFVec3f;
    dropOffRate : SFFloat;
    cutOffAngle : SFFloat;
  end;

  TAsciiText = object
    asciiString   : MFString;
    spacing       : SFFloat;
    justification : SFEnum;
    width         : MFFloat;
  end;

  TDirectionalLight = object
    lightOn    : SFBool;
    intensity  : SFFloat;
    color      : SFColor;
    Adirection : SFVec3f;
  end;

  TIndexedFaceSet = object
    coordIndex        : MFLong;
    materialIndex     : MFLong;
    normalIndex       : MFLong;
    textureCoordIndex : MFLong;
  end;

  TIndexedLineSet = record
    coordIndex        : MFLong;
    materialIndex     : MFLong;
    normalIndex       : MFLong;
    textureCoordIndex : MFLong;
  end;

  TMaterial = record
    ambientColor  : MFColor;
    diffuseColor  : MFColor;
    specularColor : MFColor;
    emissiveColor : MFColor;
    shininess     : MFFloat;
    transparency  : MFFloat;
  end;

  TMaterialBinding = object
    value : SFEnum;
  end;

  TMatrixTransform = array [ 0..3, 0..3 ] of SFFloat;

  TTransform = object
    translation       : SFVec3f;
    rotation          : SFRotation;
    scaleFactor       : SFVec3f;
    scaleOrientation  : SFRotation;
    center            : SFVec3f;
  end;

  TPerspectiveCamera = object
    position      : SFVec3f;
    orientation   : SFRotation;
    focalDistance : SFFloat;
    heightAngle   : SFFloat;
  end;

  TCylinder = object
    parts  : SFBitMask;
    radius : SFFloat;
    height : SFFloat;
  end;

const
// PARTS
  PARTS_SIDES  = $0001;
  PARTS_TOP    = $0002;
  PARTS_BOTTOM = $0004;
  PARTS_ALL    = $ffff;

const
// дают возможность по отельности восстанавливать значения по умолчанию
//  в любой момент времени для любой переменной
  DefaultColor : SFColor = ( 1, 1, 1 );
  DefaultLocation : SFVec3f = ( 0, 0, 1 );
  DefaultDirection : SFVec3f = ( 0, 0, -1 );

  DefaultMaterial : TMaterial =
    ( ambientColor   : ( 0.9, 0.9, 0.9 );
      diffuseColor   : ( 0.8, 0.8, 0.8 );
      specularColor  : ( 0, 0, 0 );
      emissiveColor  : ( 0, 0, 0 );
      shininess : 0.2;
      transparency : 0 );

  DefaultMatrixTransform : TMatrixTransform =
    ( ( 1, 0, 0, 0),
      ( 0, 1, 0, 0),
      ( 0, 0, 1, 0),
      ( 0, 0, 6.2, 1) );

  DefaultTransform : TTransform =
    ( translation      : ( 0, 0, 0 );
      rotation         : ( 0, 0, 1, 0 );
      scaleFactor      : ( 1, 1, 1 );
      scaleOrientation : ( 0, 0, 1, 0 );
      center           : ( 0, 0, 0 ) );

  DefaultMaterialBinding : TMaterialBinding = ( value : OVERALL );

  DefaultPerspectiveCamera : TPerspectiveCamera =
    ( position : ( 0, 0, 1 );
      orientation : ( 0, 0, 1, 0 );
      focalDistance : 5;
      heightAngle : 0.785398 );

  DefaultCylinder : TCylinder =
    ( parts : PARTS_ALL;
      radius : 1;
      height : 2 );

var
  cube : TCube;
  sphere : TSphere;
  cone : TCone;
  cylinder : TCylinder;
  renderculling : SFEnum;
  shapehints : TShapeHints;
  spotLight : TSpotLight;
  AsciiText : TAsciiText;
  Coordinate3 : TCoordinate3;
  DirectionalLight : TDirectionalLight;
  IndexedFaceSet : TIndexedFaceSet;
  IndexedLineSet : TIndexedLineSet;
  Material : TMaterial;
  MaterialBinding : TMaterialBinding;
  MatrixTransform : TMatrixTransform;
  PerspectiveCamera : TPerspectiveCamera;
  Transform : TTransform;

procedure DefaultTypeDeclarations;

implementation

procedure DefaultTypeDeclarations;
begin
  cube.width := 2;
  cube.height := 2;
  cube.depth := 2;

  sphere.radius := 1;

  renderculling := AUTO;

  with shapehints do begin
    vertexOrdering := UNKNOWN_ORDERING;
    shapetype      := UNKNOWN_SHAPE_TYPE;
    facetype       := CONVEX;
    creaseAngle    := 0.5;
  end;

  with SpotLight do begin
    lightOn     := TRUE;
    intensity   := 1;
    color       := DefaultColor;
    location    := DefaultLocation;
    direction   := DefaultDirection;
    dropOffRate := 0;
    cutOffAngle := 0.785398;
  end;

  with AsciiText do begin
    asciiString   := '';
    spacing       := 1;
    justification := SFLEFT;
    width         := 0;
  end;

  with Cone do begin
    parts        := PARTS_ALL;
    bottomRadius := 1;
    height       := 2;
  end;

  cylinder := DefaultCylinder;

  with Coordinate3 do begin
    point [ 0 ] := 0;
    point [ 1 ] := 0;
    point [ 2 ] := 0;
  end;

  with DirectionalLight do begin
    lightOn          := TRUE;
    intensity        := 1;
    color := DefaultColor;
    Adirection [ 0 ] := 0;
    Adirection [ 1 ] := 0;
    Adirection [ 2 ] := -1;
  end;

  with IndexedFaceSet do begin
    coordIndex        := 0;
    materialIndex     := -1;
    normalIndex       := -1;
    textureCoordIndex := -1;
  end;

  with IndexedLineSet do begin
    coordIndex        := 0;
    materialIndex     := -1;
    normalIndex       := -1;
    textureCoordIndex := -1;
  end;

  Material := DefaultMaterial;
  MaterialBinding := DefaultMaterialBinding;
  MatrixTransform := DefaultMatrixTransform;
  Transform := DefaultTransform;

  PerspectiveCamera := DefaultPerspectiveCamera;

end;

end.
