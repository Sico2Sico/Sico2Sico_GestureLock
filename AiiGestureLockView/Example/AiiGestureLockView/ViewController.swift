//
//  ViewController.swift
//  AiiGestureLockView
//
//  Created by Sico2Sico on 02/09/2018.
//  Copyright (c) 2018 Sico2Sico. All rights reserved.
//

import UIKit
import SnapKit
import AiiGestureLockView

class ViewController: UIViewController {


    var passward = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white



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

    }
}

