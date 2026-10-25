USE master;
GO

IF DB_ID(N'CatalogoInteligente') IS NULL
BEGIN
    EXEC(N'CREATE DATABASE CatalogoInteligente;');
END;
GO

USE CatalogoInteligente;
GO

-- 1. Crear las tablas de destino.
IF OBJECT_ID(N'dbo.Categorias', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Categorias
    (
        CategoriaId INT IDENTITY(1,1) NOT NULL,
        Nombre NVARCHAR(50) NOT NULL,

        CONSTRAINT PK_Categorias
            PRIMARY KEY (CategoriaId),

        CONSTRAINT UQ_Categorias_Nombre
            UNIQUE (Nombre)
    );
END;
GO

IF OBJECT_ID(N'dbo.Productos', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Productos
    (
        ProductoId INT NOT NULL,
        CategoriaId INT NOT NULL,
        Nombre NVARCHAR(150) NOT NULL,
        Descripcion NVARCHAR(2000) NOT NULL,
        Precio DECIMAL(10,2) NOT NULL,
        Stock INT NOT NULL,

        CONSTRAINT PK_Productos
            PRIMARY KEY (ProductoId),

        CONSTRAINT FK_Productos_Categorias
            FOREIGN KEY (CategoriaId)
            REFERENCES dbo.Categorias (CategoriaId),

        CONSTRAINT CK_Productos_Precio
            CHECK (Precio >= 0),

        CONSTRAINT CK_Productos_Stock
            CHECK (Stock >= 0)
    );
END;
GO

-- 2. Migrar dentro de una transacción.
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Insertar las categorías que todavía no existen.
    INSERT INTO dbo.Categorias (Nombre)
    SELECT DISTINCT origen.Categoria
    FROM CatalogoLegacy.dbo.ProductosLegacy AS origen
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.Categorias AS destino
        WHERE destino.Nombre = origen.Categoria
    );

    -- Insertar los productos conservando sus identificadores.
    INSERT INTO dbo.Productos
        (ProductoId, CategoriaId, Nombre, Descripcion, Precio, Stock)
    SELECT
        origen.ProductoId,
        categoria.CategoriaId,
        origen.Nombre,
        origen.Descripcion,
        origen.Precio,
        origen.Stock
    FROM CatalogoLegacy.dbo.ProductosLegacy AS origen
    INNER JOIN dbo.Categorias AS categoria
        ON categoria.Nombre = origen.Categoria
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM dbo.Productos AS destino
        WHERE destino.ProductoId = origen.ProductoId
    );

    -- Comparar todos los campos en ambas direcciones.
    -- EXCEPT devuelve las filas que no coinciden.
    IF EXISTS
    (
        SELECT ProductoId, Nombre, Categoria, Descripcion, Precio, Stock
        FROM CatalogoLegacy.dbo.ProductosLegacy

        EXCEPT

        SELECT p.ProductoId, p.Nombre, c.Nombre,
               p.Descripcion, p.Precio, p.Stock
        FROM dbo.Productos AS p
        INNER JOIN dbo.Categorias AS c
            ON c.CategoriaId = p.CategoriaId
    )
    OR EXISTS
    (
        SELECT p.ProductoId, p.Nombre, c.Nombre,
               p.Descripcion, p.Precio, p.Stock
        FROM dbo.Productos AS p
        INNER JOIN dbo.Categorias AS c
            ON c.CategoriaId = p.CategoriaId

        EXCEPT

        SELECT ProductoId, Nombre, Categoria, Descripcion, Precio, Stock
        FROM CatalogoLegacy.dbo.ProductosLegacy
    )
    BEGIN
        THROW 50001, N'La validación detectó diferencias entre origen y destino.', 1;
    END;

    COMMIT TRANSACTION;

    SELECT N'Migración validada sin diferencias' AS resultado;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO

-- 3. Comprobar los recuentos.
SELECT
    (SELECT COUNT(*)
     FROM CatalogoLegacy.dbo.ProductosLegacy) AS productos_origen,
    (SELECT COUNT(*)
     FROM dbo.Productos) AS productos_destino,
    (SELECT COUNT(*)
     FROM dbo.Categorias) AS categorias_destino;
GO

-- 4. Consultar el catálogo reconstruido mediante JOIN.
SELECT
    p.ProductoId,
    p.Nombre,
    c.Nombre AS Categoria,
    p.Descripcion,
    p.Precio,
    p.Stock
FROM dbo.Productos AS p
INNER JOIN dbo.Categorias AS c
    ON c.CategoriaId = p.CategoriaId
ORDER BY p.ProductoId;
GO


