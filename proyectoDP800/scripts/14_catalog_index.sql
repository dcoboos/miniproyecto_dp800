USE CatalogoInteligente;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID(N'dbo.Productos')
      AND name = N'IX_Productos_Categoria_Precio'
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Productos_Categoria_Precio
        ON dbo.Productos (CategoriaId, Precio)
        INCLUDE (Nombre, Stock);
END;
GO

-- Verificar los índices y sus columnas.
SELECT
    i.name AS Indice,
    i.type_desc AS Tipo,
    c.name AS Columna,
    ic.key_ordinal AS OrdenColumnaClave,
    ic.is_included_column AS EsColumnaIncluida
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic
    ON ic.object_id = i.object_id
   AND ic.index_id = i.index_id
INNER JOIN sys.columns AS c
    ON c.object_id = ic.object_id
   AND c.column_id = ic.column_id
WHERE i.object_id = OBJECT_ID(N'dbo.Productos')
  AND i.index_id > 0
ORDER BY i.name, ic.index_column_id;
GO

-- Consulta que utilizaremos para revisar el plan de ejecución.
SELECT
    p.ProductoId,
    p.Nombre,
    p.Precio,
    p.Stock
FROM dbo.Productos AS p
WHERE p.CategoriaId =
(
    SELECT c.CategoriaId
    FROM dbo.Categorias AS c
    WHERE c.Nombre = N'Portátiles'
)
  AND p.Precio <= 800
  AND p.Stock > 0
ORDER BY p.Precio, p.ProductoId;
GO


USE CatalogoInteligente;
GO

SET STATISTICS XML ON;
GO

SELECT
    p.ProductoId,
    p.Nombre,
    p.Precio,
    p.Stock
FROM dbo.Productos AS p
WHERE p.CategoriaId =
(
    SELECT c.CategoriaId
    FROM dbo.Categorias AS c
    WHERE c.Nombre = N'Portátiles'
)
  AND p.Precio <= 800
  AND p.Stock > 0
ORDER BY p.Precio, p.ProductoId;
GO

SET STATISTICS XML OFF;
GO