# From https://github.com/FatalMerlin/PowerShell/blob/master/Remove-ItemWithProgress.psm1
# Customized for AutoIDKU/BioniDKU by Bionic Butter

function Remove-ItemWithProgress {
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo] $Path
    )

    try {
        [string] $_Path = (Resolve-Path $Path).Path;
    }
    catch { throw 'Invalid Path.'; }

    $RegEx = '"([^"]+)"\.';
    $Activity = "$_Path removal progress:"
    Write-Progress -Id 0 -Activity $Activity -Status "Indexing files... This might take a few minutes" -PercentComplete 0;

    $Directory = Get-Location
    $ItemCount = (Get-ChildItem -Path $_Path -Recurse -Force).Count + 1; # Needs to include -Force for hidden directories
    $Counter = 0;

    $Start = (Get-Date)
    Remove-Item -Path $_Path -Recurse -Force -Verbose 4>&1 | ForEach-Object { 
        $Counter++;

        $Elapsed = ((Get-Date) - $Start).TotalSeconds
        $Remaining = ($Elapsed / ($Counter / $ItemCount)) - $Elapsed
        
        $Text = [regex]::Match($_, $RegEx).Captures.Groups[1].Value.Replace($Directory, ".");
        $Progress = $Counter * 100 / $ItemCount
        Write-Progress -Id 0 -Activity $Activity -Status "Deleting: $Text" -PercentComplete $Progress -SecondsRemaining $Remaining
    };
    Write-Progress -Id 0 -Activity $Activity -Status "Completed" -PercentComplete 100 -Completed;

    Write-Output "$Counter items have been deleted."
}

Export-ModuleMember -Function Remove-ItemWithProgress