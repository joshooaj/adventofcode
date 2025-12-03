param(
    [Parameter(Mandatory)]
    [string]
    $PuzzleInput
)

$position = 50
$tick = 0
Get-Content $PuzzleInput | ForEach-Object {
    $direction = $_ -match '^L' ? -1 : 1
    $distance = [int]($_ -replace '(L|R)') * $direction
    $newPosition = $position + $distance
    while ($newPosition -lt 0) {
        $newPosition += 100
    }
    while ($newPosition -ge 100) {
        $newPosition -= 100
    }
    $position = $newPosition
    Write-Verbose "Position: $position"
    if ($position -eq 0) {
        $tick++
    }
}
$tick