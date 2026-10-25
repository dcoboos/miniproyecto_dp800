USE master;
GO

-- Crear la base de datos si todavía no existe.
IF DB_ID(N'CatalogoLegacy') IS NULL
BEGIN
    EXEC(N'CREATE DATABASE CatalogoLegacy;');
END;
GO

-- Comprobar que se ha creado correctamente.
SELECT
    name AS base_de_datos,
    state_desc AS estado,
    compatibility_level AS nivel_compatibilidad
FROM sys.databases
WHERE name = N'CatalogoLegacy';
GO