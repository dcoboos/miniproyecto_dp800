$ErrorActionPreference = "Stop"

$modelo = "embeddinggemma:300m"
$url = "http://localhost:11434/api/embed"

# Conexión local mediante tu identidad de Windows.
$conexion = New-Object System.Data.SqlClient.SqlConnection
$conexion.ConnectionString = (
    "Server=localhost;" +
    "Database=CatalogoInteligente;" +
    "Integrated Security=True;" +
    "Encrypt=True;" +
    "TrustServerCertificate=True;"
)

try {
    $conexion.Open()

    # Leer únicamente los productos pendientes.
    $lectura = $conexion.CreateCommand()
    $lectura.CommandText = @"
SELECT
    p.ProductoId,
    p.Nombre,
    c.Nombre AS Categoria,
    p.Descripcion
FROM dbo.Productos AS p
INNER JOIN dbo.Categorias AS c
    ON c.CategoriaId = p.CategoriaId
WHERE p.Embedding IS NULL
ORDER BY p.ProductoId;
"@

    $tabla = New-Object System.Data.DataTable
    $lector = $lectura.ExecuteReader()

    try {
        $tabla.Load($lector)
    }
    finally {
        $lector.Dispose()
        $lectura.Dispose()
    }

    Write-Host "Productos pendientes: $($tabla.Rows.Count)"

    # Actualización parametrizada: el vector se envía como JSON.
    $actualizacion = $conexion.CreateCommand()
    $actualizacion.CommandText = @"
UPDATE dbo.Productos
SET Embedding = CAST(@vector AS VECTOR(768))
WHERE ProductoId = @id
  AND Embedding IS NULL;
"@

    $paramVector = $actualizacion.Parameters.Add(
        "@vector", [System.Data.SqlDbType]::NVarChar, -1
    )
    $paramId = $actualizacion.Parameters.Add(
        "@id", [System.Data.SqlDbType]::Int
    )

    try {
        foreach ($producto in $tabla.Rows) {
            $texto = "title: $($producto.Nombre) | text: " +
                     "$($producto.Categoria). $($producto.Descripcion)"

            $cuerpo = @{
                model    = $modelo
                input    = $texto
                truncate = $false
            } | ConvertTo-Json

            $respuesta = Invoke-RestMethod `
                -Uri $url `
                -Method Post `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes($cuerpo)) `
                -TimeoutSec 180

            $vector = $respuesta.embeddings[0]

            if ($null -eq $vector -or $vector.Count -ne 768) {
                throw "Vector no válido para el producto $($producto.ProductoId)."
            }

            # ConvertTo-Json conserva el formato numérico JSON,
            # independientemente de la configuración regional.
            $paramVector.Value = ConvertTo-Json `
                -InputObject $vector -Compress

            $paramId.Value = [int]$producto.ProductoId

            $filas = $actualizacion.ExecuteNonQuery()

            Write-Host (
                "Producto {0}: {1} | Filas actualizadas: {2}" -f
                $producto.ProductoId, $producto.Nombre, $filas
            )
        }
    }
    finally {
        $actualizacion.Dispose()
    }

    Write-Host "Proceso completado."
}
finally {
    $conexion.Dispose()
}