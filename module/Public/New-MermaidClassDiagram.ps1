function New-MermaidClassDiagram {
  <#
  .SYNOPSIS
    Generate class diagram for mermaid.
  .PARAMETER Path
    The path of a file containing PowerShell Classes.
  .OUTPUTS
    None. Source code of the class diagram for mermaid is copied to clipboard.
  #>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [System.IO.FileInfo[]]$Path
  )
  $CUClass = Get-CUClass -Path $Path

  $space = ' '
  $tabSpace = '  '
  $sb = '{'
  $eb = '}'
  $sp = '('
  $ep = ')'
  $comma = ','
  $mdCode = '```'
  $plus = '+'
  $minus = '-'
  $inheritance = '<|--'
  $aggregation = 'o--'

  $ClassStrArr = @()
  $ClassStrArr += ($mdCode + 'mermaid')
  $ClassStrArr += 'classDiagram'
  $ClassStrArr += ''

  # Generate Class relation
  $CUClass | ForEach-Object {
    $ClassName = $_.Name

    # Inheritance
    if ($Null -ne $_.ParentClassName) {
      $ParentClassName = $_.ParentClassName

      $Str = $ParentClassName + $space + $inheritance + $space + $ClassName
      $ClassStrArr += $Str
    }

    # Aggregation
    if ($Null -ne $_.Constructor) {
      $_.Constructor | ForEach-Object {
        $ConstructorName = $_.Name
        $Parameter = $_.Parameter

        if ($Null -ne $Parameter) {
          $Parameter | ForEach-Object {
            if ('' -eq $_.Type) { return }
            $Type = Split-Bracket -Str $_.Type

            if ($Type -in $CUClass.Name) {
              $Str = $ConstructorName + $space + $aggregation + $space + $Type
              $ClassStrArr += $Str
            }
          }
        }
      }
    }
  }

  $ClassStrArr += ''

  # Generate Class
  $CUClass | ForEach-Object {

    $ClassName = $_.Name
    $ClassStrArr += 'class' + $space + $ClassName + $space + $sb

    # Property
    if ($Null -ne $_.Property) {
      $_.Property | ForEach-Object {
        $PropertyName = $_.Name
        $Type = $_.Type
        $Visibility = if ("Hidden" -eq $_.Visibility) { $minus } else { $plus }

        $Str = $tabSpace + $Visibility + $Type + $space + $PropertyName
        $ClassStrArr += $Str
      }
    }

    $ClassStrArr += ''

    # Constructor
    if ($Null -ne $_.Constructor) {
      $_.Constructor | ForEach-Object {
        $ConstructorName = $_.Name
        $Parameter = $_.Parameter

        $Str = $tabSpace + $plus + $ConstructorName + $sp

        if ($Null -ne $Parameter) {
          $Parameter | ForEach-Object {
            if ('' -eq $_.Type) { return }
            $ParameterName = $_.Name
            $Type = Split-Bracket -Str $_.Type

            $Str = $Str + $Type + $space + $ParameterName

            # In case there are multiple parameters
            if ($Parameter.IndexOf($_) -lt $Parameter.Count - 1) {
              $Str = $Str + $comma + $space
            }
          }
        }

        $Str = $Str + $ep + $space + $ConstructorName
        $ClassStrArr += $Str
      }
    }

    # Method
    if ($Null -ne $_.Method) {
      $_.Method | ForEach-Object {
        $MethodName = $_.Name
        $ReturnType = Split-Bracket -Str $_.ReturnType
        $Parameter = $_.Parameter

        $Str = $tabSpace + $plus + $MethodName + $sp

        if ($Null -ne $Parameter) {
          $Parameter | ForEach-Object {
            $ParameterName = $_.Name
            $Type = Split-Bracket -Str $_.Type

            $Str = $Str + $Type + $space + $ParameterName

            # In case there are multiple parameters
            if ($Parameter.IndexOf($_) -lt $Parameter.Count - 1) {
              $Str = $Str + $comma + $space
            }
          }
        }

        $Str = $Str + $ep + $space + $ReturnType
        $ClassStrArr += $Str
      }
    }

    # End
    $ClassStrArr += $eb
    $ClassStrArr += ''
  }

  $ClassStrArr += $mdCode

  # $ClassStrArr | ForEach-Object {
  #   $_
  # }
  Set-Clipboard -Value $ClassStrArr
  Write-Output 'Source code of the class diagram for mermaid is copied to clipboard.'
}