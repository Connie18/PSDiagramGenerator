function New-PlantUMLClassDiagram {
  <#
  .SYNOPSIS
    Generate class diagram for PlantUML.
  .PARAMETER Path
    The path of a file containing PowerShell Classes.
  .OUTPUTS
    None. Source code of the class diagram for PlantUML is copied to clipboard.
  #>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [System.IO.FileInfo[]]$Path
  )
  $CUClass = Get-CUClass -Path $Path

  $syntax = @{
    space       = ' '
    tabSpace    = '  '
    sb          = '{'
    eb          = '}'
    sp          = '('
    ep          = ')'
    comma       = ','
    startStr    = '@startuml'
    endStr      = '@enduml'
    plus        = '+'
    minus       = '-'
    inheritance = '<|--'
    aggregation = 'o--'
    dependency  = '<..'
  }

  $ClassStrArr = @()
  $ClassStrArr += $syntax.startStr
  $ClassStrArr += ''

  # Generate Class relation
  $ClassStrArr = New-ClassRelation -CUClass $CUClass -ClassStrArr $ClassStrArr -Syntax $syntax

  $ClassStrArr += ''

  # Generate Class
  $ClassStrArr = New-ClassMember -CUClass $CUClass -ClassStrArr $ClassStrArr -Syntax $syntax


  $ClassStrArr += $syntax.endStr

  Set-Clipboard -Value $ClassStrArr
  Write-Host 'Source code of the class diagram for mermaid is copied to clipboard.'

  return $ClassStrArr
}
