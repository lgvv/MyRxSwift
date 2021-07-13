//
//  Combining.swift
//  MyRxSwift
//
//  Created by Hamlit Jason on 2021/07/11.
//


import UIKit
import RxSwift
import RxCocoa

class Combining: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.disposeBag = DisposeBag()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewController Appear")
        
        print(" ===== stratwith =====" )
        Observable.of(2,3,4)
            .startWith(1)
            .subscribe(onNext : { print($0) }).disposed(by: disposeBag)
        
        
        print(" ===== concat =====" )
        let first = Observable.of(1,2,3)
        let second = Observable.of(4,5,6)
        
        Observable
            .concat([first,second])
            .subscribe(onNext : { print($0) })
            .disposed(by: disposeBag)
        
        
        print(" ===== concatMap =====" )
        let sequences = [
            "Germany" : Observable.of("Berlin","Munich","FrankFrut"),
            "Spain" : Observable.of("Madrid","Barcelona","Valencia")
        ]
        
        Observable.of("Germany","Spain")
            .concatMap { country in
                sequences[country] ?? .empty()
            }
            .subscribe(onNext : { string in
                print(string)
            }).disposed(by: disposeBag)
        
        print(" ===== merge ===== ")
        
        Observable.of(left.asObservable(),right.asObservable())
            .merge()
            .subscribe(onNext : {value in
                print(value)
            }).disposed(by: disposeBag)
        
        var leftValues = ["Berlin","Munich","FrankFrut"]
        var rightValues = ["Madrid","Barcelona","Valencia"]
        
        repeat {
            if arc4random_uniform(2) == 0{
                if !leftValues.isEmpty {
                    left.onNext("Left : " + leftValues.removeFirst())
                }
            }
            else if !rightValues.isEmpty {
                right.onNext("Right : " + rightValues.removeFirst())
            }
        } while !leftValues.isEmpty || !rightValues.isEmpty
        
        
        print(" ===== combineLatest ===== ")
        Observable
            .combineLatest(left,right) { lastLeft, lastRight in
                "\(lastLeft)\(lastRight)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        print("> Sending a value to Left")
        left.onNext("Hello,")
        
        print("> Sending a value to Right")
        right.onNext("world")
        
        print("> Sending another value to Right")
        right.onNext("RxSwift")
        
        print("> Sending another value to Left")
        left.onNext("Have a good day")
        
        print(" ===== combineLatest(다른타입) ===== ")
        let choice : Observable<DateFormatter.Style> = Observable.of(.short,.long)
        
        let dates = Observable.of(Date())
        
        Observable
            .combineLatest(choice,dates) { (format,when) -> String in
            let formatter = DateFormatter()
            formatter.dateStyle = format
            return formatter.string(from: when)
        }
        .subscribe(onNext : { value in
            print(value)
        })
            
        
        print(" ===== zip ===== ")
        
        let zipleft : Observable<Weather> = Observable.of(.sunny,.cloudy,.cloudy,.sunny)
        let zipright = Observable.of("Lisbon","Copenhagen","London","Madrid","Vienna")
        Observable
            .zip(zipleft,zipright) {  weather, city in
                
                return "It's \(weather) in \(city)"
            }
            .subscribe(onNext : { print($0) })
            .disposed(by: disposeBag)
            
        print(" ===== withLatestFrom ===== ")
        let button = PublishSubject<Void>()
        let textField = PublishSubject<String>()
        
        button
            .withLatestFrom(textField)
            .subscribe(onNext : {value in
                print(value)
            })
        
        textField.onNext("Par")
        textField.onNext("Pari")
        textField.onNext("Paris")
        button.onNext(())
        button.onNext(())
        
        print(" ===== ambiguous ===== ")
        let ambleft = PublishSubject<String>()
        let ambright = PublishSubject<String>()
        ambleft.amb(ambright)
            .subscribe(onNext : { print($0) })
            .disposed(by: disposeBag)
        
        ambleft.onNext("Lisbon")
        ambright.onNext("Copenhagen")
        ambleft.onNext("London")
        ambleft.onNext("Madrid")
        ambright.onNext("Vienna")
        
        print(" ===== switchLatest ===== ")
        let one = PublishSubject<String>()
        let two = PublishSubject<String>()
        let three = PublishSubject<String>()
        
        let source = PublishSubject<Observable<String>>()
        
        source
            .switchLatest()
            .subscribe(onNext : { print($0) })
            .disposed(by: disposeBag)
        
        source.onNext(one)
        one.onNext("Some text from sequence one")
        two.onNext("Some text from sequence two")
        
        source.onNext(two)
        two.onNext("More text from sequence two")
        one.onNext("and also from sequence one")
        two.onNext("ㅇㅇㅇ text from sequence two")
        
        source.onNext(three)
        two.onNext("Why don't you see me?")
        one.onNext("I'm alone, help me")
        three.onNext("Hey it's three. I win.")
        
        source.onNext(one)
        one.onNext("Nope it's me, one!")
        one.onNext("plus + Nope it's me, one!")
       
        print(" ===== reduce ===== ")
        Observable.of(1,2,3,4,5)
            .reduce(0, accumulator: +)
            .subscribe(onNext : { print($0) })
            .disposed(by: disposeBag)
        
        print(" ===== reduce ex2 ===== ")
        Observable.of(1,2,3,4,5)
            .reduce(0, accumulator: { sum, value in
                return sum + value
            })
            .subscribe(onNext : { print($0) })
            .disposed(by: disposeBag)
    
        print(" ===== scan ===== ")
        Observable.of(1,2,3,4,5)
            .scan(0, accumulator: +)
            .subscribe(onNext : { print($0) })
            .disposed(by: disposeBag)
        
        
    }
}

enum Weather {
    case cloudy
    case sunny
}
