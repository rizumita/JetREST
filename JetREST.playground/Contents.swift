//: Playground - noun: a place where people can play

enum Sex: String {
    case Male, Female
}

class User {
    var name: String
    var sex: Sex
    init(name: String, sex: Sex) {
        self.name = name
        self.sex = sex
    }
}

let user = User(name: "test", sex: .Male)
let mirror = Mirror(reflecting: user)
mirror.children.first!.0
