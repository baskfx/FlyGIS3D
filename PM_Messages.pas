unit PM_Messages;

interface

type
  TMode = (AM_None, AM_Move, AM_Grabber, AM_Scale, AM_ZoomIn, AM_ZoomOut, AM_CROP);
  TCameraType = ( CT_CONST_H_DONT_OBSCURE, CT_CONST_H_OBSCURE,
                  CT_GLIDE_TERRAIN_DONT_OBSCURE,
                  CT_GLIDE_TERRAIN_OBSCURE, CT_GLIDE_TERRAIN_GLIDE );

resourcestring

// programm messages
  PM_HEIGHT_CONST_ANGLE_CONST = 'Высота-постоянная над уровнем моря, наклон камеры-постоянный';

  PM_MAIN_HEADER = 'FlyGIS3D';
  PM_ZONES_HEADER = 'Зона видимости ';
  PM_MODEL_3D = 'Трёхмерная модель местности';
  PM_PROCESS_HEADER = 'Триангуляция';
  PM_BREAK_TRIANGULATION = 'Прервать процесс триангуляции?';
  PM_ATTENTION_HEADER = 'Внимание!';
  PM_NO_POINTS_MSG = 'Нет набора точек, описывающих рельеф местности.';
  PM_TN_WAS_CREATED_CONTINUE = 'Триангуляционная сеть уже создана. Продолжить?';
  MIF_COLUMNS = 'Columns';
  MIF_ABSOLUTE_HEIGHT = 'ВЫСОТА_АБСОЛЮТНАЯ';
  MIF_PLINE = 'Pline';
  PM_NO_TRAEKTORY = 'Траектория не задана!';
  PM_NOT_GRAYSCALE_IMAGE_MSG = 'Изображение не полутоновое! Его можно применить '+
       'только в качестве текстуры.';
  PM_NO_TRIANGULATION_NETWORK = 'Триангуляционная сеть не создана!';
  PM_HEIGHT_RASTER_HEADER = 'Создание полутонового изображения';
  PM_HEIGHT_RASTER_PROCESS = 'Создание высотного растра...';
  PM_GET_ISOLINES_HEADER = 'Выделение изолиний';
  PM_DISCRETISATION_MSG1 = 'Дискретизация по уровням (через ';
  PM_DISCRETISATION_MSG2 = ' пикс.)...';
  PM_GET_ISOLINES_PROCESS = 'Выделение изолиний...';
  PM_FORMAT_NOT_SUPPORTED_MSG = 'Формат файла не поддерживается !';
  PM_NO_VISIBLE_POINT_MSG = 'Не определена точка видимости!';
  PM_VISIBLE_ZONE_HEADER = 'Зона видимости ';
  PM_VISIBLE_ZONE_MSG1 = 'Определение зоны видимости ( выс.: ';
  PM_VISIBLE_ZONE_MSG2 = ' пикс.)';
  PM_VISIBLE_ZONE_PROCESS = 'Определение зоны видимости...';
  PM_DTM_HEADER = 'Создание ЦМРМ';
  PM_DTM_PROCESS = 'Создание ЦМРМ...';
  PM_POINTS_INFO = 'Всего точек: ';
  PM_MIN_X_INFO = 'Xmin = ';
  PM_MAX_X_INFO = 'Xmax = ';
  PM_MIN_Y_INFO = 'Ymin = ';
  PM_MAX_Y_INFO = 'Ymax = ';
  PM_MIN_Z_INFO = 'Zmin = ';
  PM_MAX_Z_INFO = 'Zmax = ';

const
  PM_CAMERA_DESCRIPTION: array [0..4] of string =
    (PM_HEIGHT_CONST_ANGLE_CONST,
     'Высота-постоянная над уровнем моря, обзор заданной точки',
     'Плавное огибание рельефа местности, наклон камеры-постоянный',
     'Плавное огибание рельефа местности, обзор заданной точки',
     'Плавное огибание рельефа местности, камера огибает рельеф');

var
  CameraType: TCameraType;

implementation

end.
