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
