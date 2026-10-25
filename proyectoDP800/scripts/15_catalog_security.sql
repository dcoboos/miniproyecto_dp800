USE CatalogoInteligente;
GO

-- 1. Crear los roles.
IF DATABASE_PRINCIPAL_ID(N'rol_ConsultaCatalogo') IS NULL
    CREATE ROLE rol_ConsultaCatalogo AUTHORIZATION dbo;
GO

IF DATABASE_PRINCIPAL_ID(N'rol_GestionStock') IS NULL
    CREATE ROLE rol_GestionStock AUTHORIZATION dbo;
GO

-- 2. Permisos del perfil de consulta.
GRANT SELECT
    ON OBJECT::dbo.vw_CatalogoProductos
    TO rol_ConsultaCatalogo;

GRANT EXECUTE
    ON OBJECT::dbo.usp_BuscarProductosSemanticos
    TO rol_ConsultaCatalogo;

GRANT EXECUTE
    ON OBJECT::dbo.usp_BuscarProductosPorPalabras
    TO rol_ConsultaCatalogo;
GO

-- 3. Permisos del perfil de gestión de stock.
GRANT SELECT
    ON OBJECT::dbo.vw_CatalogoProductos
    TO rol_GestionStock;

GRANT UPDATE (Stock)
    ON OBJECT::dbo.Productos
    TO rol_GestionStock;
GO

-- 4. Crear usuarios para las pruebas.
IF DATABASE_PRINCIPAL_ID(N'usuario_Consulta') IS NULL
    CREATE USER usuario_Consulta WITHOUT LOGIN;
GO

IF DATABASE_PRINCIPAL_ID(N'usuario_Stock') IS NULL
    CREATE USER usuario_Stock WITHOUT LOGIN;
GO

-- 5. Incorporar los usuarios a sus roles.
IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_role_members
    WHERE role_principal_id =
          DATABASE_PRINCIPAL_ID(N'rol_ConsultaCatalogo')
      AND member_principal_id =
          DATABASE_PRINCIPAL_ID(N'usuario_Consulta')
)
    ALTER ROLE rol_ConsultaCatalogo ADD MEMBER usuario_Consulta;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_role_members
    WHERE role_principal_id =
          DATABASE_PRINCIPAL_ID(N'rol_GestionStock')
      AND member_principal_id =
          DATABASE_PRINCIPAL_ID(N'usuario_Stock')
)
    ALTER ROLE rol_GestionStock ADD MEMBER usuario_Stock;
GO

-- 6. Comprobar los permisos explícitos de los roles.
SELECT
    r.name AS Rol,
    p.state_desc AS Estado,
    p.permission_name AS Permiso,
    OBJECT_SCHEMA_NAME(p.major_id) AS Esquema,
    OBJECT_NAME(p.major_id) AS Objeto,
    c.name AS Columna
FROM sys.database_permissions AS p
INNER JOIN sys.database_principals AS r
    ON r.principal_id = p.grantee_principal_id
LEFT JOIN sys.columns AS c
    ON c.object_id = p.major_id
   AND c.column_id = p.minor_id
WHERE r.name IN
(
    N'rol_ConsultaCatalogo',
    N'rol_GestionStock'
)
  AND p.class = 1
ORDER BY r.name, Objeto, Permiso;
GO