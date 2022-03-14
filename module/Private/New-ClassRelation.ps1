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
        $ConstructorName = $_.Name
        $Parameter = $_.Parameter

        if ($Null -ne $Parameter) {
          $Parameter | ForEach-Object {
            if ('' -eq $_.Type) { return }
            $Type = Split-Bracket -Str $_.Type

            if ($Type -in $CUClass.Name) {
              $Str = $ConstructorName + $syntax.space + $syntax.aggregation + $syntax.space + $Type
              $ClassStrArr += $Str
            }
          }
        }
      }
    }
  }
  return $ClassStrArr
}
