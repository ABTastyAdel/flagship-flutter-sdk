import 'package:flagship/hits/hit.dart';
import 'package:flagship/visitor/Ivisitor.dart';
import 'package:flagship/visitor/strategy/default_strategy.dart';
import 'package:flagship/visitor/strategy/no_consent_strategy.dart';
import 'package:flagship/visitor/strategy/not_ready_strategy.dart';
import 'package:flagship/visitor/strategy/panic_strategy.dart';
import 'package:flagship/flagship.dart';
import '../visitor.dart';

class VisitorDelegate implements IVisitor {
  final Visitor visitor;
  VisitorDelegate(this.visitor);
  // Get the strategy
  DefaultStrategy getStrategy() {
    switch (Flagship.getStatus()) {
      case Status.NOT_INITIALIZED:
        return NotReadyStrategy(visitor);
      case Status.PANIC_ON:
        return PanicStrategy(visitor);
      case Status.READY:
        if (visitor.getConsent() == false) {
          // Return non consented
          return NoConsentStrategy(visitor);
        } else {
          return DefaultStrategy(visitor);
        }
    }
  }

// Activate modification
  @override
  Future<void> activateModification(String key) {
    return getStrategy().activateModification(key);
  }

// Get modification
  @override
  T getModification<T>(String key, T defaultValue, {bool activate = false}) {
    return getStrategy().getModification(key, defaultValue, activate: activate);
  }

// Get modification info
  @override
  Map<String, Object>? getModificationInfo(String key) {
    return getStrategy().getModificationInfo(key);
  }

// Synchronize modification
  Future<Status> synchronizeModifications() {
    return getStrategy().synchronizeModifications();
  }

// Update context
  @override
  void updateContext<T>(String key, T value) {
    getStrategy().updateContext(key, value);
  }

// Send hits
  @override
  Future<void> sendHit(BaseHit hit) async {
    getStrategy().sendHit(hit);
  }

  @override
  void setConsent(bool isConsent) {
    getStrategy().setConsent(isConsent);
  }
}
