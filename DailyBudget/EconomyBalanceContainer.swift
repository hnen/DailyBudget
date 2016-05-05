
import UIKit

class EconomyBalanceContainer : NSObject {
    
    private var _currEconomyBalance : EconomyBalance?;
    private var _economyController : EconomyController;
    private var _lastUpdated : Double;
    
    init (economyController : EconomyController) {
        self._economyController = economyController;
        self._lastUpdated = 0;
    }
    
    func getEconomyBalance() -> EconomyBalance {
        if (needsUpdate()) {
            let currency = SettingsController.get().getActiveCurrency()!;
            _currEconomyBalance = _economyController.evaluateBalance(currency);
            _lastUpdated = CACurrentMediaTime();
        }
        return _currEconomyBalance!;
    }
    
    func needsUpdate() -> Bool {
        let t : Double = CACurrentMediaTime();
        if (_currEconomyBalance == nil) {
            return true;
        }
        if (t - _lastUpdated > 1.0) {
            return true;
        }
        
        return false;
    }
    
    
}

