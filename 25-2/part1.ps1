param(
    [Parameter(Mandatory)]
    [string]
    $PuzzleInput
)

function Test-ProductId {
    param(
        [Parameter(Mandatory)]
        [string]
        $Id
    )

    if ($Id.Length % 2 -gt 0) {
        return $true
    }

    $s1 = $Id.Substring(0, $Id.Length / 2)
    $s2 = $Id.Substring(($Id.Length / 2))
    
    $s1 -ne $s2
}

function Get-Range {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $Range
    )
    $start = [long]($Range.Start)
    $end = [long]($Range.End)
    for ($i = $start; $i -le $end; $i++) {
        $i
    }
}


$ranges = (Get-Content $PuzzleInput) -split ',' | ForEach-Object {
    # 11-22
    $parts = $_ -split '-'
    [pscustomobject]@{
        Start = $parts[0]
        End   = $parts[1]
    }
}

[long]$invalidIdSum = 0

foreach ($range in $ranges) {
    if ($range.Start -match '^0') {
        $start = [long]$range.Start
        
        $invalidIdSum += $start
        $range.Start = $start + 1
    }
    if ($range.End -match '^0') {
        $end = [long]$range.End
        
        $invalidIdSum += $end
        $range.End = $end - 1
    }
    if ($range.Start -eq $range.End) {
        continue
    }


    foreach ($productId in $range | Get-Range) {
        if (Test-ProductId -Id $productId) {
            continue
        }
        $invalidIdSum += $productId
    }
}

$invalidIdSum

# Sample answer is 1227775554