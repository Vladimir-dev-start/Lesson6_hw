//
//  main.swift
//  Lesson6_hw
//
//  Created by Владимир on 25.04.2021.
//
import Foundation

//---эмитация очереди мужчин и женщин на вакцинацию

protocol Human {
    
    var age: Int { get }
    var height: Double { get }
    var weight: Double { get }
}

class Man: Human {
    
    var age: Int
    var height: Double
    var weight: Double
    var wasHeIll: Bool
    
    init(age: Int, height: Double, weight: Double, wasHeIll: Bool) {
        self.age = age
        self.height = height
        self.weight = weight
        self.wasHeIll = wasHeIll
    }
}

class Woman: Human {
    
    var age: Int
    var height: Double
    var weight: Double
    var wasSheIll: Bool
    var gaveBirth: Bool = false
    
    init(age: Int, height: Double, weight: Double, wasSheIll: Bool) {
        self.age = age
        self.height = height
        self.weight = weight
        self.wasSheIll = wasSheIll
    }
}

struct Queue<T: Human> {
    
    private var arrayPatient: [T] = []
    
    mutating func formQueuePatient (human patient: T) {
        arrayPatient.append(patient)
    }
    
    mutating func vaccinationIsDone() -> T? {
        guard arrayPatient.count > 0 else { return nil }
        return arrayPatient.removeFirst()
    }
    
    func filterPatient (rule: (Human) -> Bool) -> [T] {
        
        var result: [T] = []
        
        for element in arrayPatient {
            if rule(element) {
                result.append(element)
            }
        }
        
        return result
    }
    
    func movingToTheBeginning(rule: (Human) -> Bool) -> [T] {
        
        var result: [T] = arrayPatient
        
        for (index, element) in result.enumerated() {
            
            if rule(element) {
                let i = result.remove(at: index)
                result.insert(i, at: 0)
            }
        }
        
        return result
    }
    
    subscript(idPatient: Int) -> Int? {
        
        guard idPatient >= 0 && idPatient < arrayPatient.count else { return nil }
        let patient = arrayPatient[idPatient]
        return patient.age
    }
    
    subscript(arrayIdPatient: Int ...) -> Int {
        var i: Int = 0
        for index in arrayIdPatient {
            guard index >= 0 && index < arrayPatient.count else { continue }
            if arrayPatient[index].age > 60 {
                i += 1
            }
        }
        
        return i
    }
}

enum VaccinationQueue: Human {
    
    case man(Man)
    case woman(Woman)
    
    var age: Int {
        switch self {
        case .man(let man):
            return man.age
        case .woman(let woman):
            return woman.age
        }
    }
    
    var height: Double {
        switch self {
        case .man(let man):
            return man.height
        case .woman(let woman):
            return woman.height
        }
    }
    
    var weight: Double {
        switch self {
        case .man(let man):
            return man.weight
        case .woman(let woman):
            return woman.weight
        }
    }
}

var queueToday = Queue<VaccinationQueue>()

queueToday.formQueuePatient(human: .man(Man(age: 38, height: 187, weight: 78, wasHeIll: true)))
queueToday.formQueuePatient(human: .woman(Woman(age: 30, height: 161, weight: 47, wasSheIll: false)))
queueToday.formQueuePatient(human: .man(Man(age: 25, height: 178, weight: 84, wasHeIll: true)))
queueToday.formQueuePatient(human: .woman(Woman(age: 62, height: 171, weight: 58, wasSheIll: false)))
queueToday.formQueuePatient(human: .woman(Woman(age: 64, height: 174, weight: 53, wasSheIll: true)))

if let freePatient = queueToday.vaccinationIsDone() {
    
    print(freePatient.age)
}

if let agePatient = queueToday[2] {
    
    print(agePatient)
}

//---количество пациентов после 60

print(queueToday[0, 1, 2, 3, 4, 5])

//---фильтр тех пациентов, вес которых меньше 50 кг

var weightLess50 = queueToday.filterPatient(rule: {$0.weight < 50})

//---правило для перевода пациентов в начало очереди, после 60

var resultTransfer = queueToday.movingToTheBeginning(rule: {$0.age > 60})
