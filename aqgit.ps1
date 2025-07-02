param (
    [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
    [string[]]$Args
)

# List of known file extensions.
$knownExtensions = @(".ts", ".min.js", ".scss", ".css", ".md")

# Define the repository paths.
$repos = @(
    "C:\path\to\project\_\",
    "C:\path\to\project\js\",
    "C:\path\to\project\css\"
)

# Helper function: If a filename ends with any of the known extensions,
# return the base (i.e. filename without that extension).
function Get-BaseFileName($filename) {
    foreach ($ext in $knownExtensions) {
        if ($filename.EndsWith($ext)) {
            return $filename.Substring(0, $filename.Length - $ext.Length)
        }
    }
    return $filename
}

# Check if any argument has one of the known file extensions.
$hasKnownExtension = $false
foreach ($arg in $Args) {
    foreach ($ext in $knownExtensions) {
        if ($arg.EndsWith($ext)) {
            $hasKnownExtension = $true
            break
        }
    }
    if ($hasKnownExtension) { break }
}

if ($hasKnownExtension) {
    # At least one argument is a file reference.
    # For each repository folder...
    foreach ($repo in $repos) {
        Write-Host "Running git command in $repo"
        Push-Location $repo
        # And for each known extension...
        foreach ($ext in $knownExtensions) {
            # Build a new argument list:
            # - For any argument ending with a known extension, remove the extension and re–append the current $ext.
            # - Otherwise, leave the argument unchanged.
            $newArgs = @()
            foreach ($arg in $Args) {
                $modified = $arg
                foreach ($known in $knownExtensions) {
                    if ($arg.EndsWith($known)) {
                        $base = Get-BaseFileName $arg
                        $modified = $base + $ext
                        break
                    }
                }
                $newArgs += $modified
            }
            Write-Host "Running: git $($newArgs -join ' ')"
            git @newArgs
        }
        Pop-Location
    }
}
else {
    # No known file extension detected, run the command as provided in every repo.
    foreach ($repo in $repos) {
        Write-Host "Running git command in $repo"
        Push-Location $repo
        Write-Host "Running: git $($Args -join ' ')"
        git @Args
        Pop-Location
    }
}
