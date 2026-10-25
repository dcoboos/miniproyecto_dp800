USE CatalogoInteligente;
GO

CREATE OR ALTER PROCEDURE dbo.usp_BuscarProductosSemanticos
    @VectorJSON NVARCHAR(MAX),
    @Categoria NVARCHAR(50) = NULL,
    @PrecioMaximo DECIMAL(10,2) = NULL,
    @SoloDisponibles BIT = 1,
    @Top INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    IF @Top IS NULL OR @Top < 1 OR @Top > 30
        THROW 50002, N'Top debe estar entre 1 y 30.', 1;

    IF @PrecioMaximo < 0
        THROW 50003, N'El precio máximo no puede ser negativo.', 1;

    IF @VectorJSON IS NULL
        THROW 50004, N'Debe proporcionarse un vector.', 1;

    DECLARE @Vector VECTOR(768) =
        CAST(@VectorJSON AS VECTOR(768));

    ;WITH Resultados AS
    (
        SELECT
            p.ProductoId,
            p.Nombre,
            c.Nombre AS Categoria,
            p.Descripcion,
            p.Precio,
            p.Stock,
            VECTOR_DISTANCE(
                'cosine', p.Embedding, @Vector
            ) AS Distancia
        FROM dbo.Productos AS p
        INNER JOIN dbo.Categorias AS c
            ON c.CategoriaId = p.CategoriaId
        WHERE p.Embedding IS NOT NULL
          AND (@Categoria IS NULL OR c.Nombre = @Categoria)
          AND (@PrecioMaximo IS NULL OR p.Precio <= @PrecioMaximo)
          AND (@SoloDisponibles = 0 OR p.Stock > 0)
    )
    SELECT TOP (@Top)
        ROW_NUMBER() OVER (
            ORDER BY Distancia, ProductoId
        ) AS Posicion,
        ProductoId,
        Nombre,
        Categoria,
        Descripcion,
        Precio,
        Stock,
        Distancia
    FROM Resultados
    ORDER BY Distancia, ProductoId;
END;
GO