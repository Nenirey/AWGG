function f_clean {
    Write-Output "Clean up output directory"
}

function f_main {
    switch ($args[0]) {
        'clean' { f_clean }
        default { f_clean }
    }
}

f_main @args