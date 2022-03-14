class ClassName {
  [Void]Method([DependentClassA]$ClassA, [DependentClassB]$ClassB) {
    
  }
}

class DependentClassA {
  
}

class DependentClassB {
  [String]$Property
}