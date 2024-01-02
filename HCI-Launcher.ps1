########################################################### CONFIG ###########################################################

$memtest = "memtest.exe"
$threads = $null
$affinity = $null

########################################################### CONFIG ###########################################################

if(!(Test-Path -Path $memtest))
{
    Write-Error -Message "[ERROR] Invalid path" -ErrorAction Stop
}

if($null -eq $threads)
{
    Write-Host "If you wish to skip this prompt, you can adjust the number of threads in the config section of the .ps1 file"
    Write-Host "Threads: " -NoNewline
    $threads = Read-Host
}

try
{
    $threads = [int]$threads
    if($threads -lt 1)
    {
        throw
    }
}
catch
{
    Write-Error -Message "[ERROR] Number of threads must be a positive integer" -ErrorAction Stop
}

$cores = (Get-WmiObject Win32_Processor).NumberOfLogicalProcessors

if($null -eq $affinity)
{
    Write-Host "Running $threads threads across all cores..."
    for($i = 0; $i -lt $threads; $i++)
    {
        $aff = $i % $cores
        $p = Start-Process -FilePath $memtest -PassThru
        $p.ProcessorAffinity = [int][Math]::Pow(2, $aff)
    }
}else
{
    try
    {
        for($i = 0; $i -lt $affinity.Count; $i++)
        {
            $temp = [int]$affinity[$i]
            if(($temp -lt 0) -or ($temp -gt $cores-1))
            {
                throw
            }
        }
    }catch
    {
        Write-Error -Message "[ERROR] Invalid affinity requested" -ErrorAction Stop
    }

    Write-Host "Running $threads threads across the following cores: $affinity"
    for($i = 0; $i -lt $threads; $i++)
    {
        $aff = $affinity[$i % $affinity.Count]
        $p = Start-Process -FilePath $memtest -PassThru
        $p.ProcessorAffinity = [int][Math]::Pow(2, $aff)
    }
}