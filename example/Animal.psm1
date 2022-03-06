Using module ./Name.psm1

class Animal {
  [Name] $name

  Animal([Name] $name) {
    $this.name = $name
  }

  [Void] move() {
    Write-Host 'Move!'
  }
}