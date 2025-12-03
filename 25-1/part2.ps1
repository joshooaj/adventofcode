param(
    [Parameter(Mandatory)]
    [string]
    $PuzzleInput
)

$position = 50
$ticks = 0

Get-Content $PuzzleInput | ForEach-Object {
    $direction = $_ -match '^L' ? -1 : 1
    $distance = [int]($_ -replace '(L|R)')
    while ($distance -gt 0) {
        $distance--
        $position = $position + $direction
        if ($position -eq 100) {
            $position = 0
        } elseif ($position -eq -1) {
            $position = 99
        }
        if ($position -eq 0) {
            $ticks++
        }
    }
}
$ticks