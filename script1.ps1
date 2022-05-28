function Time-Command {
<#
.SYNOPSIS
Times the execution of one or more commands.
.DESCRIPTION
Times the execution of one or more commands, averaging the timings of
15 runs by default; use -Count to customize.
The commands' output is suppressed by default.
-OutputToHost prints it, but only straight to the host (console).
To see the total execution time and other diagnostic info, pass -Verbose.
The results are reported from fastest to slowest.
.PARAMETER ScriptBlock
The commands to time, passed as an array of script blocks, optionally
via the pipeline.
.PARAMETER Count
How many times to run each command; defaults to 15.
The average timing will be reported.
Note: 15 was chosen so as not to trigger JIT compilation of the test
script blocks by default, which can skew the results.
.PARAMETER InputObject
Optional input objects to expose to the script blocks as variable $_.
$_ refers to the *entire collection* of input objects, whether
you supply the objects via the pipeline or as an argument.
Note that this requires that even with pipeline input *all input must
be collected in memory first*.
.PARAMETER OutputToHost
Prints the commands' (success) output, which is suppressed by default,
directly to the host (console).
Note:
* You cannot capture such output.
* Printing the output clearly affects the duration of the execution.
The primary purpose of this switch is to verify that the commands work
as intended.
.OUTPUTS
[pscustombject] A custom object with the following properties:
Factor ... relative performance ratio, with 1.00 representing the fastest
command. A factor of 2.00, for instance, indicates that the given command
took twice as long to run as the fastest one.
Secs (<n>-run avg.) ... a friendly string representation of the execution
times in seconds; the number of averaged runs in reflected in the property
name. For programmatic processing, use .TimeSpan instead.
Command ... the command at hand, i.e., the code inside a script block passed
to -ScriptBlock.
TimeSpan ... the execution time of the command at hand, as a [timespan]
instance.
.EXAMPLE
Time-Command { Get-ChildItem -recurse /foo }, { Get-ChildItem -recurse /bar } 50
Times 50 runs of two Get-ChildItem commands and reports the average execution
time.
.EXAMPLE
'hi', 'there' | Time-Command { $_.Count } -OutputToHost
Shows how to pass input objects to the script block and how to reference
them there. Output is 2, because $_ refers to the entire collection of input
objects.
.NOTES
This function is meant to be an enhanced version of the built-in
Measure-Command cmdlet that improves on the latter in the following ways:
* Supports multiple commands whose timings can be compared.
* Supports averaging the timings of multiple runs per command.
* Supports passing input objects via the pipeline that the commands see
as the entire collection in variable $_
* Supports printing command output to the console for diagnostic purposes.
* Runs the script blocks in a *child* scope (unlike Measure-Object) which
avoids pollution of the caller's scope and the execution slowdown that
happens with dot-sourcing
(see https://github.com/PowerShell/PowerShell/issues/8911).
* Also published as a Gist: https://gist.github.com/mklement0/9e1f13978620b09ab2d15da5535d1b27
#>

    [CmdletBinding(PositionalBinding = $False)]
    [OutputType([pscustomobject])]
    param(
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'ScriptBlock')]
    [scriptblock[]] $ScriptBlock
    ,
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'ToBeDefined'))]
    [hashtable[]] $ToBeDefined
    ,
    [Parameter(Position = 1)]
    [int] $Count = 15
    ,
    [Parameter(ValueFromPipeline, Position = 2)]
    [object[]] $InputObject
    ,
    [switch] $OutputToHost
    )

    begin {
        # IMPORTANT:
        # Declare all variables used in this cmdlet with $private:...
        # so as to prevent them from shadowing the *caller's* variables that
        # the script blocks may rely upon.
        # !! See below re manual "unshadowing" of the *parameter* variables.
        $private:dtStart = [datetime]::UtcNow
        $private:havePipelineInput = $MyInvocation.ExpectingInput
        [System.Collections.ArrayList] $private:inputObjects = @()
        # To prevent parameter presets from affecting test results,
        # create a local, empty $PSDefaultParameterValues instance.
        $PSDefaultParameterValues = @{ }
    }

    process {
        # Collect all pipeline input.
        if ($havePipelineInput) { $inputObjects.AddRange($InputObject) }
    }

    end {
        if (-not $havePipelineInput) { $inputObjects = $InputObject }
        # !! The parameter variables too may accidentally shadow *caller* variables
        # !! that the script blocks passed may rely upon.
        # !! We don't bother trying to *manually* "unshadow" ALL parameter variables,
        # !! but we do it for -Count / $Count, because it is such a common variable name.
        # !! Note that this unshadowing will NOT work if the caller is in a different
        # !! scope domain.
        $__tcm_runCount = $Count # !! Cannot use $private, because it is used in child scopes of calculated properties.
        $Count = Get-Variable -Scope 1 Count -ValueOnly -ErrorAction Ignore

        # Time the commands and sort them by execution time (fastest first):
        [ref] $__tcm_fastestTicks = 0 # !! Cannot use $private, because it is used in child scopes of calculated properties.
        if($PSCmdlet.ParameterSetName -eq 'ScriptBlock') {
        $ScriptBlock | ForEach-Object {
            $__tcm_block = $private:blockToRun = $_  # !! Cannot use $private, because it is used in child scopes of calculated properties.
            if ($OutputToHost) {
            # Note: We use ... | Out-Host, which prints to the console, but faster
            #       and more faithfully than ... | Out-String -Stream | Write-Verbose would.
            #       Enclosing the original block content in `. { ... }` is necessary to ensure that
            #       Out-Default applies to *all* statements in the block, if there are multiple.
            $blockToRun = [scriptblock]::Create('. {{ {0} }} | Out-Host' -f $__tcm_block.ToString())
            }
            Write-Verbose "Starting $__tcm_runCount run(s) of: $__tcm_block..."
            # Force garbage collection now, to minimize the risk of collection kicking in during
            # execution due to memory pressure from previous runs.
            [GC]::Collect(); [GC]::WaitForPendingFinalizers()
            1..$__tcm_runCount | ForEach-Object {
            # Note how we pass all input objects as an *argument* to -InputObject
            # so that the script blocks can refer to *all* input objects as $_
            # !! Run the script block via a wrapper that executes it in a *child scope*
            # !! to as to eliminate the effects of variable lookups that occur in
            # !! (implicitly) dot-sourced code.
            # !! (Measure-Command runs its script-block argument dot-sourced).
            # !! See https://github.com/PowerShell/PowerShell/issues/8911
            Measure-Command { & $blockToRun } -InputObject $inputObjects
            } | Measure-Object -Property Ticks -Average |
            Select-Object @{ n = 'Command'; e = { $__tcm_block.ToString().Trim() } },
            @{ n = 'Ticks'; e = { $_.Average } }
            } | Sort-Object Ticks |
            # Note: Choose the property order so that the most important information comes first:
            #       Factor, (friendly seconds, followed by the potentially truncated Command (which is not a problem - it just needs to be recognizable).
            #       The TimeSpan column will often not be visible, but its primary importance is for *programmatic* processing only.
            #       A proper solution would require defining formats via a *.format.ps1xml file.
            Select-Object @{ n = 'Factor'; e = { if ($__tcm_fastestTicks.Value -eq 0) { $__tcm_fastestTicks.Value = $_.Ticks }; '{0:N2}' -f ($_.Ticks / $__tcm_fastestTicks.Value) } },
            @{ n = "Secs ($__tcm_runCount-run avg.)"; e = { '{0:N3}' -f ($_.Ticks / 1e7) } },
            Command,
            @{ n = 'TimeSpan'; e = { [timespan] [long] $_.Ticks } }

            Write-Verbose "Overall time elapsed: $([datetime]::UtcNow - $dtStart)"
    }
}