import 'package:flagship/api/service.dart';
import 'package:flagship/decision/interface_decision_manager.dart';
import 'package:flagship/model/campaign.dart';
import 'package:flagship/model/modification.dart';

abstract class DecisionManager extends IDecisionManager {
  //panic mode
  bool _panic = false;

  bool _isConsent = true; // By default teh value is true

  Service service;

  DecisionManager(this.service);

  Map<String, Modification> getModifications(List<Campaign> campaigns) {
    Map<String, Modification> result = new Map<String, Modification>();

    for (var itemCampaign in campaigns) {
      result.addAll(itemCampaign.getAllModification());
    }
    return result;
  }

  bool isPanic() {
    return _panic;
  }

  void updatePanicMode(bool newValue) {
    _panic = newValue;
  }

  void updateConsent(bool newValue) {
    _isConsent = newValue;
  }

  bool isConsent() {
    return _isConsent;
  }

  void startPolling() {} // used by the bucketing
}
