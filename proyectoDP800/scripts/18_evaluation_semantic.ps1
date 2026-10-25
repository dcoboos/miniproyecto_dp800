$ErrorActionPreference = "Stop"

Write-Host "Caso 3"
& (Join-Path $PSScriptRoot "10_search_products.ps1") -Consulta "Un ordenador de menos de un kilo para trabajar muchas horas lejos de un enchufe" -Categoria "Portátiles" -PrecioMaximo 1200

Write-Host "Caso 4"
& (Join-Path $PSScriptRoot "10_search_products.ps1") -Consulta "Una pantalla para juegos rápidos con movimientos fluidos" -Categoria "Monitores" -PrecioMaximo 350

