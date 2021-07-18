//
//  Time Based Operators.swift
//  MyRxSwift
//
//  Created by Hamlit Jason on 2021/07/12.
//

import UIKit
import RxSwift
import RxCocoa

class TimeBased: UIViewController {
    
    
    var disposeBag = DisposeBag()
    
    let elementsPerSecond = 1
    let maxElements = 5
    let replayedElements = 1
    let replayDelay: TimeInterval = 3
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.disposeBag = DisposeBag()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(" ===== delaySubscription ===== ")
        Observable.of(1,2,3,4,5)
            .delaySubscription(.seconds(Int(1)), scheduler: MainScheduler.instance)
            .subscribe(onNext: { print("delaySubscription -> \($0)") })
            .disposed(by: disposeBag)
        
        print(" ===== delay ===== ")
        Observable.of(1,2,3,4,5)
            .delay(.seconds(Int(3)), scheduler: MainScheduler.instance)
            .subscribe(onNext: { print("delay -> \($0)") })
            .disposed(by: disposeBag)
        
        print(" ===== interval ===== " )
        print("이부분은 Transforming에 구현되어 있다.")
        
        
        print(" ===== timer ===== " )
        _ = Observable<Int>
            .timer(3, scheduler: MainScheduler.instance)
            .flatMap { _ in
                Observable.of(1,2,3,4,5)
                    .delay(.seconds(Int(3)), scheduler: MainScheduler.instance)
            }
            .subscribe(onNext:{ print("timer -> \($0)") })
            .disposed(by: disposeBag)
        
        print(" ===== timeOut ===== ")
        Observable.of(1,2,3,4,5)
            .timeout(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { print("timeout -> \($0)") })
            .disposed(by: disposeBag)
        
        
    }
    
    

}
