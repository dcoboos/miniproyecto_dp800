USE CatalogoInteligente;
GO

CREATE OR ALTER VIEW dbo.vw_CatalogoProductos
AS
    SELECT
        p.ProductoId,
        p.Nombre,
        c.Nombre AS Categoria,
        p.Descripcion,
        p.Precio,
        p.Stock,
        CAST(
            CASE WHEN p.Stock > 0 THEN 1 ELSE 0 END
            AS BIT
        ) AS Disponible,
        CAST(
            CASE WHEN p.Embedding IS NOT NULL THEN 1 ELSE 0 END
            AS BIT
        ) AS TieneEmbedding
    FROM dbo.Productos AS p
    INNER JOIN dbo.Categorias AS c
        ON c.CategoriaId = p.CategoriaId;
GO

-- Consultar el catálogo.
SELECT *
FROM dbo.vw_CatalogoProductos
ORDER BY Categoria, Nombre;
GO

-- Validar el número de productos y sus embeddings.
SELECT
    COUNT(*) AS total_productos,
    SUM(CAST(TieneEmbedding AS INT)) AS con_embedding
FROM dbo.vw_CatalogoProductos;
GO