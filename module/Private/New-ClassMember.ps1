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
