```mermaid
classDiagram

Animal o-- Name
Animal <|-- Dog
Dog o-- Name
Animal <|-- Fish
Fish o-- Name

class Animal {
  +Name name

  +Animal(Name name) Animal
  +move() Void
}

class Name {
  +String value

  +Name(String name) Name
}

class Dog {

  +Dog(Name name) Dog
  +move() Void
}

class Fish {

  +Fish(Name name) Fish
  +move() Void
}

```