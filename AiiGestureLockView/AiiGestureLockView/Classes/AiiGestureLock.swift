//
//  AiiGestureLock.swift
//  AppUIKit
//
//  Created by 德志 on 2018/2/8.
//

import UIKit

public class AiiGestureLock: UIControl {

    /// 设置类型
    public var lockType : LockType = .create

    //／ 线宽
    public var lineWidth : CGFloat = 10

    /// 按钮的大小
    public var itemSize = CGSize(width:48.0, height:48.0)

    /// view的内边距
    public var contentInset = UIEdgeInsetsMake(10, 10, 10, 10)

    /// 颜色 
    public var lineColor : UIColor = UIColor(red: 255/255.0, green: 174/255.0, blue: 0.0, alpha: 1)
    /// 错误的颜色
    public var errorLineColor : UIColor = UIColor.red


    /// 选中的点
    private var selectPoints = Array<UIButton>()

    /// 手指点
    private var fingerPoint: NSValue?

    /// 完成回调 所有的逻辑事件都在这里处理
    public var didFinishDrawing: ((_ lockView: AiiGestureLock, _ password: String) -> Void)? = nil


    /// 画线的layer层
    private lazy var drawingLayer: CAShapeLayer = {
        let drawLayer = CAShapeLayer()
        drawLayer.strokeColor = lineColor.cgColor
        drawLayer.lineWidth = lineWidth
        drawLayer.lineCap = kCALineCapRound
        drawLayer.lineJoin = kCALineJoinRound
        drawLayer.fillColor = UIColor.clear.cgColor
        drawLayer.strokeStart = 0.0
        drawLayer.strokeEnd = 1.0
        layer.insertSublayer(drawLayer, at: 0)
        return drawLayer
    }()

    /// 按钮数组
    private lazy var btns : [UIButton] = {
        var points = Array<UIButton>()
        for i in 0 ..< 9 {
            let btn  = UIButton(type: UIButtonType.custom)
            btn.tag = i + 1
            btn.isUserInteractionEnabled = false
            btn.isSelected = false
            points.append(btn)
            addSubview(btn)
        }
        return points
    }()


    public override init(frame: CGRect) {
        super.init(frame: frame)

        setNormalImage(image:UIImage(named:"p_nomal", in:Bundle.aiiResourceBundle(), compatibleWith: nil)!)
        setBackGgImage(image:UIImage(named:"p_nomal", in:Bundle.aiiResourceBundle(), compatibleWith: nil)!)
        setSelectedImage(image:UIImage(named:"p_select", in:Bundle.aiiResourceBundle(), compatibleWith: nil)!)
        setHighlightedImage(image:UIImage(named:"p_error", in:Bundle.aiiResourceBundle(), compatibleWith: nil)!)
    }


    //MARK:- 按钮不同状态的图片设置
    public func setBackGgImage(image: UIImage) {
        _ = btns.map { (btn) -> Void in
            btn.setBackgroundImage(image, for: .normal)
            btn.setBackgroundImage(image, for: .highlighted)
        }
    }

    public func setNormalImage(image: UIImage) {
        _ = btns.map({ (btn) -> Void in
            btn.setImage(image, for: .normal)
        })
    }

    public func setSelectedImage(image: UIImage) {
        _ = btns.map({ (btn) -> Void in
            btn.setImage(image, for: .selected)
        })
    }

    public func setHighlightedImage(image: UIImage) {
        _ = btns.map({ (btn) -> Void in
            btn.setImage(image, for: .highlighted)
        })
    }

    //MARK:- 错误的时候 执行的方法
    public  func errorShow(withDuration duration: TimeInterval, completion: (() -> Void)?) {
        drawingLayer.strokeColor = errorLineColor.cgColor
        for obj in selectPoints {
            obj.isSelected = false
            obj.isHighlighted = true
        }
        draw()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if !self.isTracking || !self.isTouchInside {
                self.clean()
            }
            if completion != nil {
                completion!()
            }
        }
    }

    //MARK:- 验证完成后清理layer
    public func clean() {
        for obj in btns{
            layer.insertSublayer(obj.layer, below: drawingLayer)
            obj.isHighlighted = false
            obj.isSelected = false
        }
        drawingLayer.strokeColor = lineColor.cgColor
        drawingLayer.path = nil
        selectPoints.removeAll()
    }

    public func clean(afterDuration duration: TimeInterval, completion : (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if !self.isTracking || !self.isTouchInside {
                self.clean()
            }
            if completion != nil {
                completion!()
            }
        }
    }

    //MARK:- 以下方法不需要关注
    override public func layoutSubviews() {
        super.layoutSubviews()
        let w: CGFloat = (bounds.size.width - contentInset.left - itemSize.width / 2 - itemSize.width / 2 - contentInset.right) / 2
        let h: CGFloat = (bounds.size.height - contentInset.top - itemSize.height / 2 - itemSize.height / 2 - contentInset.bottom) / 2
        for (idx, obj) in btns.enumerated(){
            let row: Int = idx / 3
            let col: Int = idx % 3
            obj.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(itemSize.width), height: CGFloat(itemSize.height))
            obj.center = CGPoint(x: CGFloat(contentInset.left + itemSize.width / 2 + w * CGFloat(col)), y: CGFloat(contentInset.top + itemSize.height / 2 + h * CGFloat(row)))
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UIControl
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        clean()
        var shouldBegin: Bool = false
        for obj in btns{
            if obj.frame.contains(touch.location(in: self)) {
                shouldBegin = true
                selectPoints.append(obj)
                obj.isSelected = true
                layer.insertSublayer(obj.layer, above: drawingLayer)
                self.draw()
                break
            }
        }
        return shouldBegin
    }

    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        fingerPoint = NSValue(cgPoint: touch.location(in: self))
        for obj in btns{
            if obj.frame.contains(touch.location(in: self)) {
                if !selectPoints.contains(obj) {
                    selectPoints.append(obj)
                    obj.isSelected = true
                    layer.insertSublayer(obj.layer, above: drawingLayer)
                }
            }
        }
        draw()
        sendActions(for: .valueChanged)
        return true
    }

    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        fingerPoint = nil
        draw()
        if (didFinishDrawing != nil) {
            guard let tags: [Int] = (selectPoints as NSArray).value(forKeyPath: "tag") as? [Int] else { return }

            let pwd = tags.reduce("", {
                $0 + String($1)
            })
            didFinishDrawing!(self, pwd)
        }
    }

    func draw() {
        if selectPoints.count > 0{
            let path = UIBezierPath()
            let p0: CGPoint = selectPoints.first!.center
            path.move(to: p0)
            for (idx, obj) in selectPoints.enumerated(){
                if idx != 0 {
                    path.addLine(to: obj.center)
                }
            }
            if fingerPoint != nil {
                path.addLine(to: (fingerPoint?.cgPointValue)!)
            }
            drawingLayer.path = path.cgPath
        }
        else {
            drawingLayer.path = nil
        }
    }
}


public enum LockType : Int {
    case create  //创建
    case confirm //确认
    case verify  //验证
}
