class Animal {
  [Name] $name

  Animal([Name] $name) {
    $this.name = $name
  }

  [Void] move() {
    Write-Host 'Move!'
  }
}

class Name {
  [String] $value

  Name([String] $name) {
    $this.value = $name
  }
}

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