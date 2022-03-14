# Generated at 03/15/2022 00:45:42
function New-ClassMember {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    $CUClass,

    [Parameter(Mandatory = $true)]
    $ClassStrArr,

    [Parameter(Mandatory = $true)]
    $Syntax
  )
  $CUClass | ForEach-Object {
    # Skip if the class has no member
    if (($Null -eq $_.Property) -and ($Null -eq $_.Constructor) -and ($Null -eq $_.Method)) {
      return
    }

    $ClassName = $_.Name
    $ClassStrArr += 'class' + $syntax.space + $ClassName + $syntax.space + $syntax.sb

    # Property
    if ($Null -ne $_.Property) {
      $_.Property | ForEach-Object {
        $PropertyName = $_.Name
        $Type = $_.Type
        $Visibility = if ("Hidden" -eq $_.Visibility) { $syntax.minus } else { $syntax.plus }

        $Str = $syntax.tabSpace + $Visibility + $Type + $syntax.space + $PropertyName
        $ClassStrArr += $Str
      }
    }

    $ClassStrArr += ''

    # Constructor
    if ($Null -ne $_.Constructor) {
      $_.Constructor | ForEach-Object {
        $ConstructorName = $_.Name
        $Parameter = $_.Parameter

        $Str = $syntax.tabSpace + $syntax.plus + $ConstructorName + $syntax.sp

        if ($Null -ne $Parameter) {
          $Parameter | ForEach-Object {
            if ('' -eq $_.Type) { return }
            $ParameterName = $_.Name
            $Type = Split-Bracket -Str $_.Type

            $Str = $Str + $Type + $syntax.space + $ParameterName

            # In case there are multiple parameters
            if ($Parameter.IndexOf($_) -lt $Parameter.Count - 1) {
              $Str = $Str + $syntax.comma + $syntax.space
            }
          }
        }

        $Str = $Str + $syntax.ep + $syntax.space + $ConstructorName
        $ClassStrArr += $Str
      }
    }

    # Method
    if ($Null -ne $_.Method) {
      $_.Method | ForEach-Object {
        $MethodName = $_.Name
        $Parameter = $_.Parameter

        $Str = $syntax.tabSpace + $syntax.plus + $MethodName + $syntax.sp

        if ($Null -ne $Parameter) {
          $Parameter | ForEach-Object {
            $ParameterName = $_.Name
            if ('' -eq $_.Type) { return }
            $Type = Split-Bracket -Str $_.Type

            $Str = $Str + $Type + $syntax.space + $ParameterName

            # In case there are multiple parameters
            if ($Parameter.IndexOf($_) -lt $Parameter.Count - 1) {
              $Str = $Str + $syntax.comma + $syntax.space
            }
          }
        }

        if ('' -eq $_.ReturnType) { return }
        $ReturnType = Split-Bracket -Str $_.ReturnType
        $Str = $Str + $syntax.ep + $syntax.space + $ReturnType
        $ClassStrArr += $Str
      }
    }

    # End
    $ClassStrArr += $syntax.eb
    $ClassStrArr += ''
  }
  return $ClassStrArr
}
function New-ClassRelation {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    $CUClass,

    [Parameter(Mandatory = $true)]
    $ClassStrArr,

    [Parameter(Mandatory = $true)]
    $Syntax
  )
  $CUClass | ForEach-Object {
    $ClassName = $_.Name

    # Inheritance
    if ($Null -ne $_.ParentClassName) {
      $ParentClassName = $_.ParentClassName

      $Str = $ParentClassName + $syntax.space + $syntax.inheritance + $syntax.space + $ClassName
      $ClassStrArr += $Str
    }

    # Aggregation
    if ($Null -ne $_.Constructor) {
      $_.Constructor | ForEach-Object {
        $Parameter = $_.Parameter

        if ($Null -ne $Parameter) {
          $Parameter | ForEach-Object {
            if ('' -eq $_.Type) { return }
            $TypeOfParameter = Split-Bracket -Str $_.Type

            if ($TypeOfParameter -in $CUClass.Name) {
              $Str = $ClassName + $syntax.space + $syntax.aggregation + $syntax.space + $TypeOfParameter
              $ClassStrArr += $Str
            }
          }
        }
      }
    }

    # Dependency
    if ($Null -ne $_.Method) {
      $_.Method | ForEach-Object {
        $Parameter = $_.Parameter

        if ($Null -ne $Parameter) {
          $Parameter | ForEach-Object {
            if ('' -eq $_.Type) { return }
            $TypeOfParameter = Split-Bracket -Str $_.Type

            if ($TypeOfParameter -in $CUClass.Name) {
              $Str = $ClassName + $syntax.space + $syntax.dependency + $syntax.space + $TypeOfParameter
              $ClassStrArr += $Str
            }
          }
        }
      }
    }
  }
  return $ClassStrArr
}
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

  $syntax = @{
    space       = ' '
    tabSpace    = '  '
    sb          = '{'
    eb          = '}'
    sp          = '('
    ep          = ')'
    comma       = ','
    startStr    = '```mermaid'
    endStr      = '```'
    plus        = '+'
    minus       = '-'
    inheritance = '<|--'
    aggregation = 'o--'
    dependency  = '<..'
  }

  $ClassStrArr = @()
  $ClassStrArr += $syntax.startStr
  $ClassStrArr += 'classDiagram'
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
