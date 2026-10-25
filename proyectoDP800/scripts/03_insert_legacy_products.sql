USE CatalogoLegacy;
GO

-- Productos ficticios: no representan ofertas ni fichas comerciales reales.
-- Si se repite el script, solo se insertan los identificadores que faltan.

INSERT INTO dbo.ProductosLegacy
    (ProductoId, Nombre, Categoria, Descripcion, Precio, Stock)
SELECT
    p.ProductoId,
    p.Nombre,
    p.Categoria,
    p.Descripcion,
    p.Precio,
    p.Stock
FROM
(
    VALUES
    -- PORTÁTILES
    (1, N'AulaBook 14', N'Portátiles',
     N'Portátil de 14 pulgadas, 1,3 kg de peso, 16 GB de RAM y SSD de 512 GB. Autonomía de hasta diez horas. Adecuado para ofimática, navegación y videollamadas. Fácil de transportar en una mochila.',
     699.00, 12),

    (2, N'OfficeBook 15', N'Portátiles',
     N'Portátil de 15,6 pulgadas con teclado numérico, 16 GB de RAM y SSD de 512 GB. Peso de 1,8 kg y autonomía de seis horas. Orientado a hojas de cálculo, documentos y trabajo administrativo.',
     749.00, 8),

    (3, N'GameForge 16', N'Portátiles',
     N'Portátil para videojuegos con pantalla de 16 pulgadas a 165 Hz, tarjeta gráfica dedicada, 32 GB de RAM y SSD de 1 TB. Peso de 2,6 kg y autonomía de tres horas. Refrigeración de alto rendimiento.',
     1499.00, 5),

    (4, N'TravelBook 13', N'Portátiles',
     N'Portátil compacto de 13 pulgadas y 990 gramos. Incluye 16 GB de RAM, SSD de 512 GB, carga USB-C y autonomía de hasta catorce horas. Pensado para trabajar durante desplazamientos frecuentes.',
     1099.00, 6),

    (5, N'CreatorBook 16', N'Portátiles',
     N'Portátil de 16 pulgadas con pantalla de amplia cobertura de color, 32 GB de RAM, SSD de 1 TB y gráfica dedicada. Adecuado para edición de vídeo y fotografía. Peso de 2,2 kg.',
     1799.00, 0),

    -- MONITORES
    (6, N'OfficeView 24', N'Monitores',
     N'Monitor IPS de 24 pulgadas y resolución Full HD. Incluye ajuste de altura, modo de baja luz azul y conexiones HDMI y DisplayPort. Adecuado para documentos y jornadas de oficina.',
     149.00, 20),

    (7, N'ColorView 27', N'Monitores',
     N'Monitor IPS de 27 pulgadas con resolución 4K, cobertura del 99 por ciento del espacio sRGB y calibración de fábrica. Orientado a retoque fotográfico y diseño gráfico. Incluye conexión USB-C.',
     429.00, 7),

    (8, N'SpeedView 27', N'Monitores',
     N'Monitor de 27 pulgadas con resolución QHD, frecuencia de 180 Hz y sincronización adaptativa. Diseñado para videojuegos rápidos y movimientos fluidos.',
     299.00, 10),

    (9, N'WideDesk 34', N'Monitores',
     N'Monitor ultrapanorámico de 34 pulgadas y resolución 3440 por 1440. Permite trabajar con varias ventanas simultáneamente. Incluye soporte regulable y conexión USB-C con carga de 65 W.',
     499.00, 4),

    (10, N'GoScreen 15', N'Monitores',
     N'Monitor portátil de 15,6 pulgadas, resolución Full HD y peso de 750 gramos. Se conecta mediante USB-C y se alimenta desde un equipo compatible. Incluye funda con soporte para usar como segunda pantalla durante viajes.',
     189.00, 9),

    -- TECLADOS
    (11, N'QuietKeys', N'Teclados',
     N'Teclado inalámbrico de membrana con pulsaciones silenciosas, distribución española y teclado numérico. Adecuado para oficinas compartidas y videollamadas. Conexión mediante receptor USB.',
     29.90, 25),

    (12, N'MechArena', N'Teclados',
     N'Teclado mecánico para videojuegos con interruptores de clic audible, iluminación RGB y conexión USB por cable. Permite registrar varias pulsaciones simultáneas.',
     89.90, 14),

    (13, N'ErgoSplit', N'Teclados',
     N'Teclado ergonómico dividido con reposamuñecas y distribución española. Diseñado para favorecer una postura cómoda durante sesiones prolongadas de escritura. Conexión USB por cable.',
     99.00, 6),

    (14, N'PocketKeys', N'Teclados',
     N'Teclado Bluetooth compacto, ligero y sin bloque numérico. Permite alternar entre tres dispositivos. Adecuado para llevar en una mochila y utilizar con tabletas o portátiles.',
     44.90, 11),

    (15, N'CodeKeys Mini', N'Teclados',
     N'Teclado mecánico compacto con interruptores lineales, teclas programables y conexión USB-C por cable. Libera espacio en el escritorio. Distribución española y retroiluminación blanca.',
     79.90, 0),

    -- RATONES
    (16, N'SilentMouse', N'Ratones',
     N'Ratón inalámbrico con botones de clic silencioso y sensor de 1600 DPI. Adecuado para bibliotecas y espacios de trabajo compartidos. Utiliza receptor USB.',
     19.90, 30),

    (17, N'VerticalComfort', N'Ratones',
     N'Ratón vertical para personas diestras, con apoyo para el pulgar y sensibilidad ajustable. Diseñado para favorecer una postura más neutra de la mano. Conexión inalámbrica mediante receptor USB.',
     39.90, 12),

    (18, N'AimPro', N'Ratones',
     N'Ratón para videojuegos de 65 gramos, sensor de alta precisión y botones programables. Conexión USB por cable y sensibilidad ajustable hasta 26000 DPI.',
     59.90, 16),

    (19, N'TravelMouse', N'Ratones',
     N'Ratón Bluetooth compacto de 60 gramos. Puede vincularse con dos equipos y no necesita receptor USB. Pensado para desplazamientos y uso con portátiles.',
     24.90, 18),

    (20, N'DesignTrack', N'Ratones',
     N'Ratón inalámbrico con rueda lateral, botones configurables y sensor de 8000 DPI. Permite desplazarse horizontalmente por hojas de cálculo y líneas de tiempo de edición.',
     84.90, 7),

    -- ALMACENAMIENTO
    (21, N'SafePocket SSD 1TB', N'Almacenamiento',
     N'Unidad SSD externa de 1 TB con conexión USB-C, carcasa resistente a golpes y peso de 80 gramos. Adecuada para transportar archivos y realizar copias de seguridad frecuentes.',
     94.90, 15),

    (22, N'ArchiveBox HDD 4TB', N'Almacenamiento',
     N'Disco duro externo de sobremesa de 4 TB con conexión USB y alimentación eléctrica propia. Orientado a almacenar grandes colecciones de archivos y copias de seguridad en un puesto fijo.',
     109.00, 9),

    (23, N'FlashMove 128GB', N'Almacenamiento',
     N'Memoria USB de 128 GB con conectores USB-A y USB-C. Permite trasladar documentos entre equipos compatibles. Tamaño de bolsillo.',
     18.90, 40),

    (24, N'SpeedCore NVMe 1TB', N'Almacenamiento',
     N'Unidad SSD interna NVMe de 1 TB en formato M.2 2280 con interfaz PCIe 4.0. Pensada para ampliar un ordenador compatible y reducir tiempos de carga. Requiere instalación interna.',
     79.90, 13),

    (25, N'PhotoCard 256GB', N'Almacenamiento',
     N'Tarjeta de memoria SD de 256 GB, clase U3 y V30. Adecuada para fotografía y grabación de vídeo en cámaras compatibles. No incluye lector de tarjetas.',
     34.90, 0),

    -- ACCESORIOS
    (26, N'ConnectHub 7', N'Accesorios',
     N'Adaptador USB-C con siete conexiones: HDMI 4K a 30 Hz, dos USB-A, USB-C de datos, lectores SD y microSD y entrada de alimentación de hasta 100 W. Requiere un puerto compatible con salida de vídeo.',
     49.90, 17),

    (27, N'MeetCam FullHD', N'Accesorios',
     N'Cámara web Full HD con micrófono integrado y tapa de privacidad. Conexión USB y soporte para colocar sobre un monitor. Adecuada para reuniones virtuales y clases a distancia.',
     39.90, 22),

    (28, N'FocusHeadset', N'Accesorios',
     N'Auriculares USB con micrófono direccional, almohadillas acolchadas y controles de volumen y silencio. Orientados a conversaciones claras durante videollamadas en oficinas compartidas.',
     54.90, 14),

    (29, N'LiftStand', N'Accesorios',
     N'Soporte plegable de aluminio para portátiles de 13 a 16 pulgadas. Permite elevar la pantalla y ajustar su inclinación. No incluye ventiladores. Adecuado para usar con teclado y ratón externos.',
     27.90, 19),

    (30, N'PowerTravel 65W', N'Accesorios',
     N'Cargador compacto USB-C de 65 W con tecnología GaN y Power Delivery. Permite alimentar portátiles y móviles compatibles. Incluye cable USB-C y resulta práctico para desplazamientos.',
     34.90, 10)
) AS p (ProductoId, Nombre, Categoria, Descripcion, Precio, Stock)
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.ProductosLegacy AS existente
    WHERE existente.ProductoId = p.ProductoId
);
GO

-- Comprobación 1: deben aparecer 30 productos.
SELECT COUNT(*) AS total_productos
FROM dbo.ProductosLegacy;
GO

-- Comprobación 2: deben aparecer 5 productos por categoría.
SELECT
    Categoria,
    COUNT(*) AS total_productos
FROM dbo.ProductosLegacy
GROUP BY Categoria
ORDER BY Categoria;
GO

-- Comprobación 3: revisar el catálogo completo.
SELECT
    ProductoId,
    Nombre,
    Categoria,
    Descripcion,
    Precio,
    Stock
FROM dbo.ProductosLegacy
ORDER BY ProductoId;
GO