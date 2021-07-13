//
//  Subject.swift
//  MyRxSwift
//
//  Created by Hamlit Jason on 2021/07/10.
//

import UIKit
import RxSwift
import RxCocoa

class Subject: UIViewController {
    
    var disposeBag = DisposeBag()
    var publishSubject = PublishSubject<String>()
    var behaviorSubject = BehaviorSubject(value: "hehavior -> init")
    var replaySubject = ReplaySubject<String>.create(bufferSize: 2)
    var asyncSubject = AsyncSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.disposeBag = DisposeBag()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(" ==== publish Subject ==== ")
        publishSubject.onNext("publish -> idx 0")
        
        // first subscribe
        publishSubject.subscribe{ event in
            print(event)
        }.disposed(by: disposeBag)
        
        publishSubject.onNext("publish -> idx 1")
        publishSubject.onNext("publish -> idx 2")
        publishSubject.onCompleted() // 만약 이 부분이 빠지면 결과값은 어떻게 될까?
        publishSubject.onNext("publish -> idx 3")
        
        // second subscribe
        publishSubject.subscribe{ event in
            print(event)
        }.disposed(by: disposeBag)
        publishSubject.onNext("publish -> idx 4")
        publishSubject.onCompleted()
        
        
        print(" ==== replay Subject ==== ")
        behaviorSubject.onNext("behavior -> idx 0")
        // first subscribe
        behaviorSubject.subscribe{ event in
            print(event)
        }.disposed(by: disposeBag)
        behaviorSubject.onNext("behavior -> idx 1")
        behaviorSubject.onNext("behavior -> idx 2")
        behaviorSubject.onCompleted() // 만약 이 부분이 빠지면 결과값은 어떻게 될까?
        behaviorSubject.onNext("behavior -> idx 3")
        
        // second subscribe
        behaviorSubject.subscribe{ event in
            print(event)
        }.disposed(by: disposeBag)
        behaviorSubject.onNext("behavior -> idx 4")
        behaviorSubject.onCompleted()
        
        
        print(" ==== behavior Subject ==== ")
        replaySubject.onNext("replay -> idx 0")
        // first subscribe
        replaySubject.subscribe{ event in
            print(event)
        }.disposed(by: disposeBag)
        replaySubject.onNext("replay -> idx 1")
        replaySubject.onNext("replay -> idx 2")
        replaySubject.onCompleted() // 만약 이 부분이 빠지면 결과값은 어떻게 될까?
        replaySubject.onNext("replay -> idx 3")
        
        // second subscribe
        replaySubject.subscribe{ event in
            print(event)
        }.disposed(by: disposeBag)
        replaySubject.onNext("replay -> idx 4")
        replaySubject.onCompleted()
        
        
        print(" ==== async Subject ==== ")
        asyncSubject.onNext("async -> idx 0")
        
        // first subscribe
        asyncSubject.subscribe{ event in
            print(event)
        }.disposed(by: disposeBag)
        
        asyncSubject.onNext("async -> idx 1")
        asyncSubject.onNext("async -> idx 2")
        //asyncSubject.onCompleted() // 만약 이 부분이 빠지면 결과값은 어떻게 될까?
        asyncSubject.onNext("async -> idx 3")
        
        // second subscribe
        asyncSubject.subscribe{ event in
            print(event)
        }.disposed(by: disposeBag)
        asyncSubject.onNext("async -> idx 4")
        asyncSubject.onCompleted()
        
        
    }
    
}
