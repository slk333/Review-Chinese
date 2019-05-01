import UIKit
class KernButton:UIButton{
    let kern = 1.2
    
    
    required init?(coder aDecoder: NSCoder) {
        // init utilisé lorsque la view est présente sur la scène
        super.init(coder: aDecoder)
        
        
        // personnalisation du bouton et notamment du style de son texte
        if let currentText = self.titleLabel?.text{
            self.titleLabel?.attributedText = NSAttributedString(string: currentText, attributes: [.kern: kern])
            
        }
       
    }
    
}
