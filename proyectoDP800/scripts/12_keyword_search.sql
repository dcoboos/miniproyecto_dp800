USE CatalogoInteligente;
GO

CREATE OR ALTER PROCEDURE dbo.usp_BuscarProductosPorPalabras
    @Consulta NVARCHAR(500),
    @Categoria NVARCHAR(50) = NULL,
    @PrecioMaximo DECIMAL(10,2) = NULL,
    @SoloDisponibles BIT = 1,
    @Top INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    IF @Consulta IS NULL OR LEN(TRIM(@Consulta)) = 0
        THROW 50005, N'Debe proporcionarse una consulta.', 1;

    IF @Top IS NULL OR @Top < 1 OR @Top > 30
        THROW 50006, N'Top debe estar entre 1 y 30.', 1;

    IF @PrecioMaximo < 0
        THROW 50007, N'El precio máximo no puede ser negativo.', 1;

    -- Normalizar los signos de puntuación más habituales.
    DECLARE @Texto NVARCHAR(500) =
        TRANSLATE(
            LOWER(@Consulta),
            N'.,;:¿?¡!()',
            REPLICATE(N' ', 10)
        );

    ;WITH Palabras AS
    (
        SELECT DISTINCT
            value COLLATE Latin1_General_100_CI_AI AS Palabra
        FROM STRING_SPLIT(@Texto, N' ')
        WHERE LEN(value) >= 3
          AND value COLLATE Latin1_General_100_CI_AI NOT IN
          (
              N'para', N'con', N'sin', N'que',
              N'una', N'uno', N'los', N'las',
              N'del', N'por', N'como', N'mis'
          )
    ),
    Coincidencias AS
    (
        SELECT
            p.ProductoId,
            p.Nombre,
            p.Categoria,
            p.Descripcion,
            p.Precio,
            p.Stock,
            COUNT(*) AS PalabrasCoincidentes
        FROM dbo.vw_CatalogoProductos AS p
        INNER JOIN Palabras AS t
            ON CHARINDEX(
                t.Palabra,
                CONCAT(p.Nombre, N' ', p.Descripcion)
                    COLLATE Latin1_General_100_CI_AI
            ) > 0
        WHERE (@Categoria IS NULL OR p.Categoria = @Categoria)
          AND (@PrecioMaximo IS NULL OR p.Precio <= @PrecioMaximo)
          AND (@SoloDisponibles = 0 OR p.Stock > 0)
        GROUP BY
            p.ProductoId,
            p.Nombre,
            p.Categoria,
            p.Descripcion,
            p.Precio,
            p.Stock
    )
    SELECT TOP (@Top)
        ROW_NUMBER() OVER (
            ORDER BY PalabrasCoincidentes DESC, ProductoId
        ) AS Posicion,
        ProductoId,
        Nombre,
        Categoria,
        Descripcion,
        Precio,
        Stock,
        PalabrasCoincidentes
    FROM Coincidencias
    ORDER BY PalabrasCoincidentes DESC, ProductoId;
END;
GO

-- Prueba 1: misma petición y filtros que en la búsqueda semántica.
EXEC dbo.usp_BuscarProductosPorPalabras
    @Consulta = N'Un portatil ligero para estudiar',
    @Categoria = N'Portátiles',
    @PrecioMaximo = 800;
GO

-- Prueba 2: misma petición y filtros que en la búsqueda semántica.
EXEC dbo.usp_BuscarProductosPorPalabras
    @Consulta = N'Un teclado para escribir sin molestar',
    @Categoria = N'Teclados',
    @PrecioMaximo = 100;
GO