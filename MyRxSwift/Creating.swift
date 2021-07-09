//
//  Creating.swift
//  MyRxSwift
//
//  Created by Hamlit Jason on 2021/07/09.
//

import UIKit
import RxSwift
import RxCocoa

class Creating: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Creating View Disappear")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(" ===== create ===== ")
        let createSequence = Observable<String>.create { observer in
            print("Emitting...")
            observer.onNext("🐶")
            observer.onNext("🐱")
            observer.onNext("🐵")
            return Disposables.create()
        }.subscribe()
        
        print(" ===== deferred ===== ")
        var count = 1
        let deferredSequence = Observable<String>.deferred {
            print("Creating \(count)")
            count += 1
            
            return Observable.create { observer in
                print("Emitting...")
                observer.onNext("🐶")
                observer.onNext("🐱")
                observer.onNext("🐵")
                return Disposables.create()
            }
        }
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        deferredSequence
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        print(" ===== empty ===== ")
        Observable<Int>.empty()
            .subscribe { event in
                print(event)
            }
            .disposed(by: disposeBag)
        
        print(" ===== never ===== ")
        let neverSequence = Observable<String>.never()
        let neverSequenceSubscription = neverSequence
            .subscribe { _ in
                print("This will never be printed")
        }
        neverSequenceSubscription.disposed(by: disposeBag)
        
        print(" ===== from ===== Array")
        Observable.from([1,2,3,4,5])
            .subscribe { elemets in
                print("\(elemets)")
            } onError: { error in
                print("from error -> \(error.localizedDescription)")
            } onCompleted: {
                print("onCompleted")
            } onDisposed: {
                print("onDisposed")
            }.disposed(by: disposeBag)
        
        print(" ===== from ===== Dictionary")
        Observable.from(["a":1, "b":2, "c":3])
            .subscribe { elemets in
                print("key:\(elemets.key),value:\(elemets.value)")
            } onError: { error in
                print("from error -> \(error.localizedDescription)")
            } onCompleted: {
                print("onCompleted")
            } onDisposed: {
                print("onDisposed")
            }.disposed(by: disposeBag)
        
        print(" ===== Interval ===== ")
        _ = Observable<Int>.interval(3.0, scheduler: MainScheduler.instance)
            .subscribe(onNext : { emitter in
                print("Interval 수행")
            }).disposed(by: disposeBag)
        
        print(" ===== just ===== ")
        Observable<Array>.just([1,2,3])
            .subscribe({
                element in
                print("\(element)")
            }).disposed(by: disposeBag)
        
        print(" ===== range ===== ")
        Observable.range(start: 1, count: 10)
            .subscribe { print($0) }
            .disposed(by: disposeBag)

        print(" ===== repeatElement ===== ")
        Observable.repeatElement("🔴")
                .take(3)
                .subscribe(onNext: { print($0) })
                .disposed(by: disposeBag)
        
        print(" ===== Timer =====")
        Observable<Int>.timer(10, scheduler: MainScheduler.instance)
            .subscribe(onNext : { emitter in
                print("Timer 수행")
            }).disposed(by: disposeBag)
        
        print(" ===== of ===== ")
        Observable.of("🐶", "🐱", "🐭", "🐹")
            .subscribe(onNext: { element in
                print(element)
            })
            .disposed(by: disposeBag)
        
        
        print(" ===== generate ===== ")
        Observable.generate(
                initialState: 0,
                condition: { $0 < 3 },
                iterate: { $0 + 1 }
            )
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        
//        print(" ===== error ===== ")
//        Observable<Int>.error()
//            .subscribe { print($0) }
//            .disposed(by: disposeBag)
        
        print(" ===== doOn =====" )
        Observable.of("🍎", "🍐", "🍊", "🍋")
            .do(onNext: { print("Intercepted:", $0) },
                onError: { print("Intercepted error:", $0) },
                onCompleted: { print("Completed")  })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
    }
}
