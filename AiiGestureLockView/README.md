# AiiGestureLockView

[![CI Status](http://img.shields.io/travis/Sico2Sico/AiiGestureLockView.svg?style=flat)](https://travis-ci.org/Sico2Sico/AiiGestureLockView)
[![Version](https://img.shields.io/cocoapods/v/AiiGestureLockView.svg?style=flat)](http://cocoapods.org/pods/AiiGestureLockView)
[![License](https://img.shields.io/cocoapods/l/AiiGestureLockView.svg?style=flat)](http://cocoapods.org/pods/AiiGestureLockView)
[![Platform](https://img.shields.io/cocoapods/p/AiiGestureLockView.svg?style=flat)](http://cocoapods.org/pods/AiiGestureLockView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

AiiGestureLockView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AiiGestureLockView'
```

## Author

参考的git项目地址https://github.com/smlkts/IZGestureLockSwift  非常感谢大佬的开源 给我节省了好多时间

Sico2Sico, wu.dz@aiiage.com

## 示例代码

```swift
// 1 创建View 添加到容器
        let gestureLockView = AiiGestureLock()
        view.addSubview(gestureLockView)

        // 2 设置item大小  默认为48
        gestureLockView.itemSize = CGSize(width: 46, height: 46)

        // 3 设置内边距 默认为10个单位
        gestureLockView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        // 4 设置完成时 回调处理block
        gestureLockView.didFinishDrawing = {[weak self] (_ lockView: AiiGestureLock, _ password: String) in


            if lockView.lockType == .create {
                if password.count < 5 {
                    print("不能小于五个数")
                    lockView.errorShow(withDuration: 1.0, completion:nil)
                    return
                }

                self?.passward = password
                lockView.clean()
                lockView.lockType = .confirm
                return
            }


            if lockView.lockType == .confirm {

                if password == self?.passward {
                    print("验证成功")
                    lockView.clean()
                    lockView.lockType = .verify
                    return
                }else {
                    print("验证失败")
                    lockView.errorShow(withDuration:1, completion:nil)
                    return
                }
            }

            if lockView.lockType == .verify {
                if password == self?.passward {
                    print("密码正确")
                    lockView.clean()
                    lockView.lockType = .create
                    return
                }else {
                    print("密码错误")
                    lockView.errorShow(withDuration:1, completion:nil)
                    return
                }
            }
        }

        gestureLockView.snp.makeConstraints { (make) in
            make.size.equalTo(200)
            make.center.equalToSuperview()
        }
```





## License

AiiGestureLockView is available under the MIT license. See the LICENSE file for more info.
