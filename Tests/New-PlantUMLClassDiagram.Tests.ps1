$RootDir = $PSScriptRoot | Split-Path -Parent

Import-Module ($RootDir | Join-Path -ChildPath PSDiagramGenerator | Join-Path -ChildPath PSDiagramGenerator.psm1)

Describe 'Normal case' {
  BeforeAll {
    function RunAndAssert {
      param (
        [String]
        $fileName
      )
      Mock -ModuleName PSDiagramGenerator Write-Host {}
      
      $PSMPath = $PSScriptRoot | Join-Path -ChildPath fixture | Join-Path -ChildPath "$fileName.psm1"
      $actual = New-PlantUMLClassDiagram -Path $PSMPath
    
      $TxtPath = $PSScriptRoot | Join-Path -ChildPath fixture | Join-Path -ChildPath "$fileName.pu"
      $expected = Get-Content $TxtPath -Encoding UTF8
    
      $actual | Should -Be $expected
    }
  }
  It 'should pass' {
    RunAndAssert -fileName 'Animal'
  }
  It 'should not generate class if the class has no member' {
    RunAndAssert -fileName 'NoMember'
  }
  It 'should generate array type class property correctly' {
    RunAndAssert -fileName 'ListProperty'
  }
  It 'should generate class that has dependency relation' {
    RunAndAssert -fileName 'Dependency'
  }

}
