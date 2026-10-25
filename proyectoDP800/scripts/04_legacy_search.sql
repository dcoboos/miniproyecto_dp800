USE CatalogoLegacy;
GO

-- 1. Buscar una palabra presente en las descripciones.
SELECT ProductoId, Nombre, Descripcion, Precio, Stock
FROM dbo.ProductosLegacy
WHERE Categoria = N'Teclados'
  AND Descripcion LIKE N'%silencios%'
  AND Stock > 0
ORDER BY Precio, ProductoId;
GO

-- 2. Buscar una necesidad expresada con otra palabra.
SELECT ProductoId, Nombre, Descripcion, Precio, Stock
FROM dbo.ProductosLegacy
WHERE Categoria = N'Portátiles'
  AND Descripcion LIKE N'%estudiar%'
  AND Precio <= 800
  AND Stock > 0
ORDER BY Precio, ProductoId;
GO

-- 3. Revisar los portátiles que cumplen los filtros de negocio.
SELECT ProductoId, Nombre, Descripcion, Precio, Stock
FROM dbo.ProductosLegacy
WHERE Categoria = N'Portátiles'
  AND Precio <= 800
  AND Stock > 0
ORDER BY Precio, ProductoId;
GO