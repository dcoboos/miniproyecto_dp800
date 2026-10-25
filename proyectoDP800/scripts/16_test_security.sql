USE CatalogoInteligente;
GO

-- PRUEBAS DEL USUARIO DE CONSULTA
EXECUTE AS USER = N'usuario_Consulta';

SELECT USER_NAME() AS UsuarioActual;

-- Debe permitir consultar la vista.
SELECT TOP (2)
    ProductoId, Nombre, Precio, Stock
FROM dbo.vw_CatalogoProductos
ORDER BY ProductoId;

-- Debe permitir ejecutar la búsqueda textual.
EXEC dbo.usp_BuscarProductosPorPalabras
    @Consulta = N'teclado',
    @Categoria = N'Teclados',
    @PrecioMaximo = 100;

-- Debe rechazar la lectura directa de la tabla.
BEGIN TRY
    EXEC(N'SELECT TOP (1) ProductoId FROM dbo.Productos;');

    SELECT N'INESPERADO: permite leer la tabla directamente.'
        AS Resultado;
END TRY
BEGIN CATCH
    SELECT
        N'Lectura directa rechazada' AS Prueba,
        ERROR_NUMBER() AS CodigoError,
        ERROR_MESSAGE() AS Detalle;
END CATCH;

-- Debe rechazar la modificación de stock.
BEGIN TRY
    EXEC(N'UPDATE dbo.Productos SET Stock = 0 WHERE 1 = 0;');

    SELECT N'INESPERADO: permite actualizar stock.' AS Resultado;
END TRY
BEGIN CATCH
    SELECT
        N'Actualización de stock rechazada' AS Prueba,
        ERROR_NUMBER() AS CodigoError,
        ERROR_MESSAGE() AS Detalle;
END CATCH;

REVERT;
GO

-- PRUEBAS DEL USUARIO DE STOCK
EXECUTE AS USER = N'usuario_Stock';

SELECT USER_NAME() AS UsuarioActual;

-- Debe permitir consultar la vista.
SELECT TOP (2)
    ProductoId, Nombre, Precio, Stock
FROM dbo.vw_CatalogoProductos
ORDER BY ProductoId;

-- Debe permitir una sentencia UPDATE sobre Stock.
BEGIN TRY
    EXEC(N'UPDATE dbo.Productos SET Stock = 0 WHERE 1 = 0;');

    SELECT N'Actualización de Stock permitida; cero filas modificadas.'
        AS Resultado;
END TRY
BEGIN CATCH
    SELECT
        N'INESPERADO: actualización de Stock rechazada' AS Prueba,
        ERROR_NUMBER() AS CodigoError,
        ERROR_MESSAGE() AS Detalle;
END CATCH;

-- Debe rechazar una sentencia UPDATE sobre Precio.
BEGIN TRY
    EXEC(N'UPDATE dbo.Productos SET Precio = 0 WHERE 1 = 0;');

    SELECT N'INESPERADO: permite actualizar Precio.' AS Resultado;
END TRY
BEGIN CATCH
    SELECT
        N'Actualización de Precio rechazada' AS Prueba,
        ERROR_NUMBER() AS CodigoError,
        ERROR_MESSAGE() AS Detalle;
END CATCH;

REVERT;
GO

SELECT USER_NAME() AS UsuarioRestaurado;
GO