USE CatalogoInteligente;
GO

;WITH ProductosDisponibles AS
(
    SELECT
        ProductoId,
        Nombre,
        Categoria,
        Precio,
        Stock
    FROM dbo.vw_CatalogoProductos
    WHERE Disponible = 1
),
AnalisisPorCategoria AS
(
    SELECT
        ProductoId,
        Nombre,
        Categoria,
        Precio,
        Stock,
        AVG(Precio) OVER (
            PARTITION BY Categoria
        ) AS PrecioMedioCategoria,
        COUNT(*) OVER (
            PARTITION BY Categoria
        ) AS ProductosDisponiblesCategoria,
        ROW_NUMBER() OVER (
            PARTITION BY Categoria
            ORDER BY Precio, ProductoId
        ) AS PosicionPrecio
    FROM ProductosDisponibles
)
SELECT
    Categoria,
    PosicionPrecio,
    Nombre,
    Precio,
    Stock,
    CAST(
        PrecioMedioCategoria AS DECIMAL(10,2)
    ) AS PrecioMedioCategoria,
    CAST(
        Precio - PrecioMedioCategoria AS DECIMAL(10,2)
    ) AS DiferenciaRespectoMedia,
    ProductosDisponiblesCategoria
FROM AnalisisPorCategoria
WHERE PosicionPrecio <= 2
ORDER BY Categoria, PosicionPrecio;
GO



USE CatalogoInteligente;
GO

SELECT
    i.name AS Indice,
    i.type_desc AS Tipo,
    i.is_unique AS EsUnico,
    ic.key_ordinal AS OrdenColumnaClave,
    c.name AS Columna,
    ic.is_included_column AS EsColumnaIncluida,
    i.filter_definition AS Filtro
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