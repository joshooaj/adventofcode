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

    $ErrorActionPreference = 'Stop'

    $maxLength = [math]::Floor($Id.Length / 2)
    for ($length = 1; $length -le $maxLength; $length++) {
        if ($Id.Length % $length) {
            continue
        }
        $parts = for ($pos = 0; $pos -le $Id.Length - $length; $pos += $length) {
            $Id.Substring($pos, $length)
        }
        Write-Verbose ($parts -join ' ')
        $allPartsMatch = $true
        for ($index = 1; $index -lt $parts.Length; $index++) {
            if ($parts[0] -ne $parts[$index]) {
                $allPartsMatch = $false
            }
        }
        if ($allPartsMatch) {
            return $false
        }
    }

    $true
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
        Write-Verbose "Range start $($range.Start) invalid"
        $start = [long]$range.Start
        
        $invalidIdSum += $start
        $range.Start = $start + 1
    }
    if ($range.End -match '^0') {
        Write-Verbose "Range end $($range.End) invalid"
        $end = [long]$range.End
        
        $invalidIdSum += $end
        $range.End = $end - 1
    }
    if ($range.Start -eq $range.End) {
        Write-Verbose "Range start and end are the same $($range.Start)-$($range.End)"
        continue
    }


    foreach ($productId in $range | Get-Range) {
        $isValid = Test-ProductId -Id $productId
        Write-Verbose "ProductId $productId is valid? $isValid"
        if ($isValid) {
            continue
        }
        $invalidIdSum += $productId
    }
}

$invalidIdSum
