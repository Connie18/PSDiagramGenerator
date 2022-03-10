class ClassName {
  [String[]]$List

  ClassName([String[]]$List) {}

  [String[]] getList([String[]]$List) {
    return @()
  }
}