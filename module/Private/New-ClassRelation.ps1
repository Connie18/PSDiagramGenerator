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
