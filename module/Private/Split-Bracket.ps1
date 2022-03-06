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
  # TODO: Make it deal with an objet array like "Object[]"
  # return $Str.Substring(1, $Str.Length - 3)
  return ([RegEx]::Matches($Str, "(?<=\[).*?(?=\])")).Value
}
