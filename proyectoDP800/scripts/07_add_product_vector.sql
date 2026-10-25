USE CatalogoInteligente;
GO

-- Preparar dónde guardar el embedding de cada producto.
IF COL_LENGTH(N'dbo.Productos', N'Embedding') IS NULL
BEGIN
    ALTER TABLE dbo.Productos
        ADD Embedding VECTOR(768) NULL;
END;
GO

-- Verificar la columna.
SELECT
    name AS columna,
    TYPE_NAME(user_type_id) AS tipo,
    vector_dimensions AS dimensiones,
    is_nullable AS permite_null
FROM sys.columns
WHERE object_id = OBJECT_ID(N'dbo.Productos')
  AND name = N'Embedding';
GO

-- Comprobar los embeddings pendientes.
SELECT
    COUNT(*) AS total_productos,
    COUNT(Embedding) AS con_embedding,
    COUNT(*) - COUNT(Embedding) AS pendientes
FROM dbo.Productos;
GO