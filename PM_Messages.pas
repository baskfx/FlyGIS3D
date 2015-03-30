unit PM_Messages;

interface

type
  TMode = (AM_None, AM_Move, AM_Grabber, AM_Scale, AM_ZoomIn, AM_ZoomOut, AM_CROP);
  TCameraType = ( CT_CONST_H_DONT_OBSCURE, CT_CONST_H_OBSCURE,
                  CT_GLIDE_TERRAIN_DONT_OBSCURE,
                  CT_GLIDE_TERRAIN_OBSCURE, CT_GLIDE_TERRAIN_GLIDE );

resourcestring

// programm messages
  PM_HEIGHT_CONST_ANGLE_CONST = '������-���������� ��� ������� ����, ������ ������-����������';

  PM_MAIN_HEADER = 'FlyGIS3D';
  PM_ZONES_HEADER = '���� ��������� ';
  PM_MODEL_3D = '��������� ������ ���������';
  PM_PROCESS_HEADER = '������������';
  PM_BREAK_TRIANGULATION = '�������� ������� ������������?';
  PM_ATTENTION_HEADER = '��������!';
  PM_NO_POINTS_MSG = '��� ������ �����, ����������� ������ ���������.';
  PM_TN_WAS_CREATED_CONTINUE = '���������������� ���� ��� �������. ����������?';
  MIF_COLUMNS = 'Columns';
  MIF_ABSOLUTE_HEIGHT = '������_����������';
  MIF_PLINE = 'Pline';
  PM_NO_TRAEKTORY = '���������� �� ������!';
  PM_NOT_GRAYSCALE_IMAGE_MSG = '����������� �� �����������! ��� ����� ��������� '+
       '������ � �������� ��������.';
  PM_NO_TRIANGULATION_NETWORK = '���������������� ���� �� �������!';
  PM_HEIGHT_RASTER_HEADER = '�������� ������������ �����������';
  PM_HEIGHT_RASTER_PROCESS = '�������� ��������� ������...';
  PM_GET_ISOLINES_HEADER = '��������� ��������';
  PM_DISCRETISATION_MSG1 = '������������� �� ������� (����� ';
  PM_DISCRETISATION_MSG2 = ' ����.)...';
  PM_GET_ISOLINES_PROCESS = '��������� ��������...';
  PM_FORMAT_NOT_SUPPORTED_MSG = '������ ����� �� �������������� !';
  PM_NO_VISIBLE_POINT_MSG = '�� ���������� ����� ���������!';
  PM_VISIBLE_ZONE_HEADER = '���� ��������� ';
  PM_VISIBLE_ZONE_MSG1 = '����������� ���� ��������� ( ���.: ';
  PM_VISIBLE_ZONE_MSG2 = ' ����.)';
  PM_VISIBLE_ZONE_PROCESS = '����������� ���� ���������...';
  PM_DTM_HEADER = '�������� ����';
  PM_DTM_PROCESS = '�������� ����...';
  PM_POINTS_INFO = '����� �����: ';
  PM_MIN_X_INFO = 'Xmin = ';
  PM_MAX_X_INFO = 'Xmax = ';
  PM_MIN_Y_INFO = 'Ymin = ';
  PM_MAX_Y_INFO = 'Ymax = ';
  PM_MIN_Z_INFO = 'Zmin = ';
  PM_MAX_Z_INFO = 'Zmax = ';

const
  PM_CAMERA_DESCRIPTION: array [0..4] of string =
    (PM_HEIGHT_CONST_ANGLE_CONST,
     '������-���������� ��� ������� ����, ����� �������� �����',
     '������� �������� ������� ���������, ������ ������-����������',
     '������� �������� ������� ���������, ����� �������� �����',
     '������� �������� ������� ���������, ������ ������� ������');

var
  CameraType: TCameraType;

implementation

end.
