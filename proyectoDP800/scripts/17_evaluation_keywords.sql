USE CatalogoInteligente;
GO

-- Caso 3
EXEC dbo.usp_BuscarProductosPorPalabras
    @Consulta = N'Un ordenador de menos de un kilo para trabajar muchas horas lejos de un enchufe',
    @Categoria = N'Portátiles',
    @PrecioMaximo = 1200,
    @SoloDisponibles = 1,
    @Top = 5;
GO

-- Caso 4
EXEC dbo.usp_BuscarProductosPorPalabras
    @Consulta = N'Una pantalla para juegos rápidos con movimientos fluidos',
    @Categoria = N'Monitores',
    @PrecioMaximo = 350,
    @SoloDisponibles = 1,
    @Top = 5;
GO

