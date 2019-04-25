import UIKit
import PlaygroundSupport

/*UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: [], animations: {
 self.transform = CGAffineTransform(scaleX: scale, y: scale)
 }, completion: nil)*/

let view = UIView()

view.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
view.backgroundColor = .white

let subview = UIView()
subview.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
subview.backgroundColor = .orange

view.addSubview(subview)

PlaygroundPage.current.liveView = view


//  Challenge 1. Extend UIView so that it has a bounceOut(duration:) method that uses animation to scale its size down to 0.0001 over a specified number of seconds.
extension UIView {
    func bounceOut(duration: Double, scale: CGFloat = 0.0001) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}

subview.bounceOut(duration: 3)

//  Challenge 2. Extend Int with a times() method that runs a closure as many times as the number is high. For example, 5.times { print("Hello!") } will print “Hello” five times.
extension Int {
    func times(action: () -> Void) {
        guard self > 0 else { return }
        
        for _ in 1 ... self {
            action()
        }
    }
}

5.times { print("Hello!") }


//  Challenge 3: Extend Array so that it has a mutating remove(item:) method. If the item exists more than once, it should remove only the first instance it finds. Tip: you will need to add the Comparable constraint to make this work!
extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        guard let index = self.firstIndex(of: item) else { return }
        self.remove(at: index)
    }
}
var array = [1, 20, 20, 40, 2, 4, 5, 10, 2]
array.remove(item: 20)
print(array)




