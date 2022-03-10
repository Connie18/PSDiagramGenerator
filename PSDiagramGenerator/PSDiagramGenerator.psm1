# Generated at 03/10/2022 23:44:12
function Split-Bracket {
  <#
  .SYNOPSIS
    Remove the bracket of a CUClass like '[String]'
  .OUTPUTS
    String
  #>
  param (
    [Parameter(Mandatory = $true)]
    [String] $Str
  )
  $ret = ([RegEx]::Matches($Str, "(?<=^\[).*?(?=\])")).Value
  if ($ret.EndsWith('[')) {
    return $ret + ']'
  }
  else {
    return $ret
  }
}
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
  $startStr = ($mdCode + 'mermaid')
  $endStr = $mdCode
  $plus = '+'
  $minus = '-'
  $inheritance = '<|--'
  $aggregation = 'o--'

  $ClassStrArr = @()
  $ClassStrArr += $startStr
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
    # Skip if the class has no member
    if (($Null -eq $_.Property) -and ($Null -eq $_.Constructor) -and ($Null -eq $_.Method)) {
      return
    }

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
        $Parameter = $_.Parameter

        $Str = $tabSpace + $plus + $MethodName + $sp

        if ($Null -ne $Parameter) {
          $Parameter | ForEach-Object {
            $ParameterName = $_.Name
            if ('' -eq $_.Type) { return }
            $Type = Split-Bracket -Str $_.Type

            $Str = $Str + $Type + $space + $ParameterName

            # In case there are multiple parameters
            if ($Parameter.IndexOf($_) -lt $Parameter.Count - 1) {
              $Str = $Str + $comma + $space
            }
          }
        }

        if ('' -eq $_.ReturnType) { return }
        $ReturnType = Split-Bracket -Str $_.ReturnType
        $Str = $Str + $ep + $space + $ReturnType
        $ClassStrArr += $Str
      }
    }

    # End
    $ClassStrArr += $eb
    $ClassStrArr += ''
  }

  $ClassStrArr += $endStr

  Set-Clipboard -Value $ClassStrArr
  Write-Host 'Source code of the class diagram for mermaid is copied to clipboard.'

  return $ClassStrArr
}
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

  $space = ' '
  $tabSpace = '  '
  $sb = '{'
  $eb = '}'
  $sp = '('
  $ep = ')'
  $comma = ','
  $startStr = '@startuml'
  $endStr = '@enduml'
  $plus = '+'
  $minus = '-'
  $inheritance = '<|--'
  $aggregation = 'o--'

  $ClassStrArr = @()
  $ClassStrArr += $startStr
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
    # Skip if the class has no member
    if (($Null -eq $_.Property) -and ($Null -eq $_.Constructor) -and ($Null -eq $_.Method)) {
      return
    }

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
        $Parameter = $_.Parameter

        $Str = $tabSpace + $plus + $MethodName + $sp

        if ($Null -ne $Parameter) {
          $Parameter | ForEach-Object {
            $ParameterName = $_.Name
            if ('' -eq $_.Type) { return }
            $Type = Split-Bracket -Str $_.Type

            $Str = $Str + $Type + $space + $ParameterName

            # In case there are multiple parameters
            if ($Parameter.IndexOf($_) -lt $Parameter.Count - 1) {
              $Str = $Str + $comma + $space
            }
          }
        }

        if ('' -eq $_.ReturnType) { return }
        $ReturnType = Split-Bracket -Str $_.ReturnType
        $Str = $Str + $ep + $space + $ReturnType
        $ClassStrArr += $Str
      }
    }

    # End
    $ClassStrArr += $eb
    $ClassStrArr += ''
  }

  $ClassStrArr += $endStr

  Set-Clipboard -Value $ClassStrArr
  Write-Host 'Source code of the class diagram for mermaid is copied to clipboard.'

  return $ClassStrArr
}
