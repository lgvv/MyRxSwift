//
//  Filtering.swift
//  MyRxSwift
//
//  Created by Hamlit Jason on 2021/07/10.
//

import UIKit
import RxSwift
import RxCocoa

class Filtering: UIViewController {
    
    @IBOutlet weak var debounceLabel: UILabel!
    @IBOutlet weak var debounceBtn: UIButton!
    @IBOutlet weak var debounClickLabel: UILabel!
    
    @IBOutlet weak var ThrottleBtn: UIButton!
    @IBOutlet weak var ThrottleLabel: UILabel!
    @IBOutlet weak var ThrottleClickLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var debounceCount = 0
    var debounceClickCount = 0
    
    var ThrottleCount = 0
    var ThrottleClickCount = 0

    let strikes = PublishSubject<String>()
    
    let data = PublishSubject<String>()
    let trigger = PublishSubject<Void>()
    
    let subject = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        print(" ===== debounce ===== ")
        debounceBtn.rx.tap.asDriver()
            .debounce(.seconds(2))
            .drive(onNext: { (_) in
                self.debounceCount += 1
                self.debounceLabel.text = "\(self.debounceCount)"
            }).disposed(by: disposeBag)
    
    
        print(" ===== distinctUntilChanged ===== ")
        Observable.of("A","A","B","B","A","C","c")
            .distinctUntilChanged()
            .subscribe(onNext : {
                print($0)
            }).disposed(by: disposeBag)
        
        
        print(" ===== distinctUntilChanged(:_) ")
        customDistinct()
        
        
        print(" ===== elementAt ===== ")
        Observable.of(0,1,2,3,4,5,6,7,8,9)
            .elementAt(3)
            .subscribe(onNext : {
                print($0)
            }).disposed(by: disposeBag)
        
        strikes.elementAt(2)
            .subscribe(onNext : { event in
            print(event)
            }, onCompleted: {
                print("Complete")
            }).disposed(by: disposeBag)
        strikes.onNext("A")
        strikes.onNext("B")
        strikes.onNext("C")
        
        
        print(" ===== Filter ===== ")
        Observable.of(1,2,3,4,5,6)
            .filter({ (int) -> Bool in
                int % 2 == 0
            })
            .subscribe(onNext : {
                print($0)
            }).disposed(by: disposeBag)
        
        
        print(" ===== First ===== ")
        Observable.of(1,2,3,4,5,6)
            .first()
            .subscribe({
                print("observable - first success \($0)")
            }).disposed(by: disposeBag)
        
        strikes.first().subscribe(onSuccess: {
            print("strike - first sucess \($0)")
        }, onError: nil).disposed(by: disposeBag)
        strikes.first().subscribe(onSuccess: {
            print("strike - second sucess \($0)")
        }, onError: nil).disposed(by: disposeBag)
        strikes.onNext("C")
        strikes.onNext("D")
        
        
        print(" ===== ignoreElements ===== ")
        strikes.ignoreElements()
            .subscribe {
                print("complete")
            } onError: { error in
                print("error -> \(error.localizedDescription)")
            }
        strikes.onNext("1")
        strikes.onNext("2")
        strikes.onNext("3")
        strikes.onCompleted()
        
        
        print(" ===== takelast ===== ")
        Observable.of(1,2,3,4,5)
            .takeLast(1)
            .subscribe(onNext : { print($0) })
            .disposed(by: disposeBag)

        print(" ===== smaple ===== ")
        data.sample(trigger)
            .subscribe{ print($0) }
            .disposed(by: disposeBag)
        trigger.onNext(())
        data.onNext("first")
        data.onNext("last")
        trigger.onNext(())
        trigger.onNext(())
        data.onCompleted()
        trigger.onNext(())
        
        print(" ===== skip ===== ")
        Observable.of(1,2,3,4,5,6)
            .skip(2)
            .subscribe({ print($0) })
            .disposed(by: disposeBag)
        
        print(" ===== skipWhile ===== ")
        Observable.of(2,2,3,2,4,5,6)
            .skipWhile({$0 % 2 == 0})
            .subscribe(onNext : { print($0) })
            .disposed(by: disposeBag)
        
        print(" ===== skipUntil ===== ")
        subject
            .skipUntil(trigger)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
                
        subject.onNext("A")
        subject.onNext("B")
        trigger.onNext(())
        subject.onNext("C")
        
        
        print(" ===== take ===== ")
        Observable.of(1,2,3,4,5,6)
            .take(3)
            .subscribe(onNext : { print($0) })
            .disposed(by: disposeBag)
        
        print(" ===== takelast ===== ")
        Observable.of(1,2,3,4,5,6)
            .takeLast(3)
            .subscribe(onNext : { print($0) })
            .disposed(by: disposeBag)
        
        print(" ===== takewhile ===== ")
        Observable.of(2,2,3,2,4,5,6)
            .takeWhile({ $0 % 2 == 0})
            .subscribe(onNext : { print($0) })
            .disposed(by: disposeBag)
        
        print(" ===== takeuntil ===== ")
        subject
            .takeUntil(trigger)
            .subscribe(onNext: { print("subscribe value \($0)") })
            .disposed(by: disposeBag)
                
        subject.onNext("1")
        subject.onNext("2")
        trigger.onNext(())
        subject.onNext("C")
        
        print(" ===== enumerated ===== ")
        Observable.of(2, 4, 7, 8, 2, 5, 4, 4, 6, 6)
            .enumerated()
            .takeWhile({ index, value in
                value % 2 == 0 && index < 4
            })
            //.map { $0.element }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        
        print(" ===== throttle ===== ")
        ThrottleBtn.rx.tap.asDriver()
            .throttle(.seconds(3))
            .drive(onNext: { (_) in
                self.ThrottleCount += 1
                self.ThrottleLabel.text = "\(self.ThrottleCount)"
            }).disposed(by: disposeBag)
        
        
        print(" ===== single ===== ")
        Observable.of("📱", "⌚️", "💻", "🖥")
            .single()
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func DebounceBtn(_ sender: Any) {
        self.debounceClickCount += 1
        self.debounClickLabel.text = "\(self.debounceClickCount)"
        print("\(self.debounceClickCount)")
    }
    
    @IBAction func ThrottleBtn(_ sender: Any) {
        self.ThrottleClickCount += 1
        self.ThrottleClickLabel.text = "\(self.ThrottleClickCount)"
        print("\(self.ThrottleClickCount)")
    }
    
}

extension Filtering {
    func customDistinct() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut // 애플 공식 문서에 따르면 숫자의 포맷을 맞춤 en으로 맞춰진다.
        /*
         ex) 123 : one, hundred, twenty-three
         10 : ten
         110 : one, hundred, ten -> ten 겹침
         20 : twenty
         200 : two , hundred
         210 : two, hundred, ten -> two, hundred 겹침
         310 : three, hundred, ten -> hundred, ten 겹침
         */
        Observable<NSNumber>.of(10,110,20,200,210,310)
            .distinctUntilChanged {a, b in
                //각 숫자를 [String] 으로 쪼개서 넣기
                guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
                        let bWords = formatter.string(from: b)?.components(separatedBy: " ")
                else { return false }
                
                var containsMatch = false
                   
                //배열을 돌아가면서 a가 b 에 포함되는지 체크
                for aWord in aWords where bWords.contains(aWord) {
                    containsMatch = true
                    break
                }
                return containsMatch
                // return true가 반환되면 종료되서 subscribe쪽으로 들어가질 않게 돼.
            }.subscribe(onNext: {print($0)})
            .disposed(by: disposeBag)
       }
}
