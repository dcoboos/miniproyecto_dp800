param(
    [string]$Consulta = "Un portatil ligero para estudiar",
    [string]$Categoria = "Portátiles",
    [decimal]$PrecioMaximo = 800
)

$ErrorActionPreference = "Stop"

# Generar el embedding de la petición con el mismo modelo del catálogo.
$cuerpo = @{
    model = "embeddinggemma:300m"
    input = "task: search result | query: $Consulta"
    truncate = $false
} | ConvertTo-Json

$respuesta = Invoke-RestMethod `
    -Uri "http://localhost:11434/api/embed" `
    -Method Post `
    -ContentType "application/json; charset=utf-8" `
    -Body ([System.Text.Encoding]::UTF8.GetBytes($cuerpo)) `
    -TimeoutSec 180

$vector = $respuesta.embeddings[0]

if ($null -eq $vector -or $vector.Count -ne 768) {
    throw "El modelo no ha devuelto un vector de 768 dimensiones."
}

$vectorJSON = ConvertTo-Json -InputObject $vector -Compress

$conexion = New-Object System.Data.SqlClient.SqlConnection
$conexion.ConnectionString = (
    "Server=localhost;Database=CatalogoInteligente;" +
    "Integrated Security=True;Encrypt=True;" +
    "TrustServerCertificate=True;"
)

try {
    $conexion.Open()

    $comando = $conexion.CreateCommand()
    $comando.CommandType = [System.Data.CommandType]::StoredProcedure
    $comando.CommandText = "dbo.usp_BuscarProductosSemanticos"

    try {
        $p = $comando.Parameters.Add(
            "@VectorJSON", [System.Data.SqlDbType]::NVarChar, -1
        )
        $p.Value = $vectorJSON

        $p = $comando.Parameters.Add(
            "@Categoria", [System.Data.SqlDbType]::NVarChar, 50
        )
        $p.Value = $Categoria

        $p = $comando.Parameters.Add(
            "@PrecioMaximo", [System.Data.SqlDbType]::Decimal
        )
        $p.Precision = 10
        $p.Scale = 2
        $p.Value = $PrecioMaximo

        $tabla = New-Object System.Data.DataTable
        $lector = $comando.ExecuteReader()

        try {
            $tabla.Load($lector)
        }
        finally {
            $lector.Dispose()
        }

        Write-Host "Consulta: $Consulta"
        Write-Host "Categoria: $Categoria | Precio maximo: $PrecioMaximo"

        if ($tabla.Rows.Count -eq 0) {
            Write-Host "No hay productos que cumplan los filtros."
        }
        else {
            $tabla | Format-Table `
                Posicion, Nombre, Precio, Stock, Distancia -AutoSize
        }
    }
    finally {
        $comando.Dispose()
    }
}
finally {
    $conexion.Dispose()
}