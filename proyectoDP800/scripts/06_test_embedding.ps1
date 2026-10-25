$ErrorActionPreference = "Stop"

$cuerpo = @{
    model = "embeddinggemma:300m"
    input = "Un equipo ligero con buena autonomia para trabajar durante viajes."
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

"Dimension del vector: $($vector.Count)"
"Primeros cinco valores:"
$vector | Select-Object -First 5
