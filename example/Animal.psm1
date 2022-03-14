class Animal {
  [Name] $name

  Animal([Name] $name) {
    $this.name = $name
  }

  [Void] move() {}
}

class Name {
  [String] $value

  Name([String] $name) {
    $this.value = $name
  }
}

class Dog : Animal {
  Dog([Name] $name) : base($name) {}

  [Void] move() {}
}

class Fish : Animal {
  Fish([Name] $name) : base($name) {}

  [Void] move() {}
}