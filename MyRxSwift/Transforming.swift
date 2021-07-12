//
//  Transforming.swift
//  MyRxSwift
//
//  Created by Hamlit Jason on 2021/07/10.
//


import UIKit
import RxSwift
import RxCocoa

class Transforming: UIViewController {
    
    @IBOutlet weak var observeOnBtn: UIButton!
    @IBOutlet weak var observeOnLabel: UILabel!
    
    var disposeBag = DisposeBag()
    var obseveOnCount = 0
    let backgroundScheduler = SerialDispatchQueueScheduler(qos: .default)
    
    let timer1 = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).map({"o1: \($0)"})
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.disposeBag = DisposeBag()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(" ===== toArray ===== ")
        Observable.of("A", "B", "C")
            .toArray()
            .subscribe(onSuccess: {
                print($0)
                
            }, onError: { error in
                print("\(error.localizedDescription)")
            }).disposed(by: disposeBag)
    
        print(" ===== map ===== ")
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
        Observable<NSNumber>.of(123, 4, 56)
            .map {
                formatter.string(from: $0) ?? ""
            }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
        
        print(" ===== map + enumerated ===== ")
        Observable.of(1,2,3,4,5,6)
            .enumerated()
            .map{ index, value in
                index > 2 ? value * 2 : value
            }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        
        print(" ===== flatmap ===== ")
        let ryan = Student(score: BehaviorSubject(value: 80)) // 80으로 초기화
        let charlotte = Student(score: BehaviorSubject(value: 90)) // 90으로 초기화
        
        let student = PublishSubject<Student>() // student타입의 subject를 생성
        
        student
            .flatMap{ $0.score } // 이를 통해 student타입의 시퀀스인 student를 Student 내에 있는 score로 transform함
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        student.onNext(ryan) // student에게 라이언 넣어줌
        ryan.score.onNext(85) // 라이언의 선언된 behavior에 85를 건네줌
        
        student.onNext(charlotte)
        ryan.score.onNext(95)
        
        charlotte.score.onNext(100)
        
        
        print(" ===== flatMapLatest ===== ")
        let appech = Student(score: BehaviorSubject(value: 80)) // 80으로 초기화
        let muzi = Student(score: BehaviorSubject(value: 90)) // 90으로 초기화
        
        let friends = PublishSubject<Student>() // student타입의 subject를 생성
        
        
        friends.flatMapLatest{
            $0.score
        }
        .subscribe(onNext : { print($0) })
        .disposed(by: disposeBag)
        
        friends.onNext(appech)
        appech.score.onNext(85)
        friends.onNext(muzi)
        appech.score.onNext(95)
        muzi.score.onNext(100)
        
        
        print(" ===== materialize ===== ")
        let chulsu = Student(score: BehaviorSubject(value: 80)) // 80으로 초기화
        let younghee = Student(score: BehaviorSubject(value: 100)) // 90으로 초기화
        
        let couple = BehaviorSubject(value: chulsu)// student타입의 subject를 생성
        
        let coupleScore = couple.flatMapLatest{
            $0.score.materialize()
        }
        
        coupleScore.subscribe(onNext : {
            print($0)
        }).disposed(by: disposeBag)
        
        chulsu.score.onNext(85)
        chulsu.score.onError(MyError.anError)
        chulsu.score.onNext(90)
        
        couple.onNext(younghee)
        
        print(" ===== Dematerialize ===== ")
        let dechulsu = Student(score: BehaviorSubject(value: 80)) // 80으로 초기화
        let deyounghee = Student(score: BehaviorSubject(value: 100)) // 90으로 초기화
        
        let decouple = BehaviorSubject(value: dechulsu)// student타입의 subject를 생성
        
        let decoupleScore = decouple.flatMapLatest{
            $0.score.materialize()
        }
        
        decoupleScore.filter{
            guard $0.error == nil else {
                print($0.error!)
                return false
            }
            
            return true
        }
        .dematerialize()
        .subscribe(onNext : { print($0) })
        .disposed(by: disposeBag)
        
        dechulsu.score.onNext(85)
        dechulsu.score.onError(MyError.anError)
        dechulsu.score.onNext(90)
        
        decouple.onNext(deyounghee)
        
        
        print(" ===== delay ===== ")
        Observable.of(1,2,3,4,5)
            .delay(3, scheduler: MainScheduler.instance)
            .subscribe(onNext : { print("delay value ->\($0)") })
            .disposed(by: disposeBag)
        
        
        print(" ===== do ===== ")
        Observable.of("A","B","C")
            .do(onNext: {print("do on Next -> \($0)")} )
            .subscribe(onNext : {
                print("subscribe ->\($0)")
            }).disposed(by: disposeBag)
        
        print(" ===== observeOn ===== ")
        observeOnBtn.rx.tap
            .subscribe(onNext : {self.observeOnTest()})
            
        print(" ===== GroupBy ===== ")
        var first = Observable.of(1,2,3,4,5,6,7,8,9,10)
        
        first.groupBy { i -> String in
            if i%2 == 0 {
                return "odd"
            } else {
                return "even"
            }
        }
        .flatMap { o -> Observable<String> in
            if o.key == "odd" {
                return o.map { v in
                    "odd \(v)"
                }
            } else {
                return o.map { v in
                    "even \(v)"
                }
            }
        }
        .subscribe{ event in
            switch event {
            case let .next(value) :
                print(value)
            default :
                print("finished")
            }
        }.disposed(by: disposeBag)
        
        print(" ===== scan ===== ")
        Observable.of(1,2,3,4,5)
            .scan(0) { prev, next in
                return prev + next
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        
        print(" ===== buffer & window ===== ")
        

        
    }
    
    @IBAction func bufferStartBtn(_ sender: Any) {
        self.timer1.buffer(timeSpan: RxTimeInterval.seconds(3), count: 2, scheduler: MainScheduler.instance)
            .subscribe { event in
            switch event {
            case let .next(value):
                print(value)
            default:
                print("finished")
            }
            
            }.disposed(by: disposeBag)
    }
    @IBAction func bufferStopBtn(_ sender: Any) {
        print("buffer stop!")
        self.disposeBag = DisposeBag()
    }
    
    @IBAction func windowStartBtn(_ sender: Any) {
        timer1.window(timeSpan: RxTimeInterval.seconds(3), count: 2, scheduler: MainScheduler.instance)
            .subscribe { event in
                switch event {
                case let .next(observable):
                    observable.subscribe { e in
                        switch e {
                        case let .next(value):
                            print(value)
                        default:
                            print("inner finished")
                        }
                    }
                default:
                    print("finished")
                }
                
            }.disposed(by: disposeBag)

        timer1.window(timeSpan: RxTimeInterval.seconds(3), count: 2, scheduler: MainScheduler.instance)
            .subscribe { event in
                switch event {
                case let .next(observable):
                    observable.subscribe { e in
                        switch e {
                        case let .next(value):
                            print(value)
                        default:
                            print("inner finished")
                        }
                    }
                default:
                    print("finished")
                }
                
            }.disposed(by: disposeBag)
    }
    
    @IBAction func windowStopBtn(_ sender: Any) {
        print("window stop!")
        self.disposeBag = DisposeBag()
    }
    
    
    
}

struct Student {
    var score: BehaviorSubject<Int>
}

enum MyError : Error {
    case anError
}

extension Transforming {
    func observeOnTest() {
        Observable.of(2,3)
            .map{ n -> Int in
                print("this is background working")
                return n * 2
            }
            .subscribeOn(backgroundScheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { emit in
                    print("emit value = \(emit)")
                    self.obseveOnCount += 1
                    self.observeOnLabel.text = String(emit)})
            .disposed(by: disposeBag)
            
    }
}
