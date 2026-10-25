USE CatalogoLegacy;
GO

-- Crear la tabla si todavía no existe.
IF OBJECT_ID(N'dbo.ProductosLegacy', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductosLegacy
    (
        ProductoId INT NOT NULL,
        Nombre NVARCHAR(150) NOT NULL,
        Categoria NVARCHAR(50) NOT NULL,
        Descripcion NVARCHAR(2000) NOT NULL,
        Precio DECIMAL(10, 2) NOT NULL,
        Stock INT NOT NULL,

        CONSTRAINT PK_ProductosLegacy
            PRIMARY KEY (ProductoId),

        CONSTRAINT CK_ProductosLegacy_Precio
            CHECK (Precio >= 0),

        CONSTRAINT CK_ProductosLegacy_Stock
            CHECK (Stock >= 0)
    );
END;
GO

-- Comprobar las columnas creadas.
SELECT
    COLUMN_NAME AS columna,
    DATA_TYPE AS tipo,
    CHARACTER_MAXIMUM_LENGTH AS longitud_maxima,
    NUMERIC_PRECISION AS precision,
    NUMERIC_SCALE AS escala,
    IS_NULLABLE AS permite_null
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = N'dbo'
  AND TABLE_NAME = N'ProductosLegacy'
ORDER BY ORDINAL_POSITION;
GO

-- Comprobar el número de productos.
SELECT COUNT(*) AS total_productos
FROM dbo.ProductosLegacy;
GO