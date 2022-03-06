Using module ./Animal.psm1
Using module ./Name.psm1

class Dog : Animal {
  Dog([Name] $name) : base($name) {}

  [Void] move() {
    Write-Host 'Run!'
  }
}

class Cat : Animal {
  Cat([Name] $name) : base($name) {}

  [Void] move() {
    Write-Host 'Run!'
  }
}
