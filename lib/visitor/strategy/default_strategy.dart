import 'package:flagship/hits/activate.dart';
import 'package:flagship/hits/event.dart';
import 'package:flagship/hits/hit.dart';
import 'package:flagship/model/modification.dart';
import 'package:flagship/utils/logger/log_manager.dart';
import 'package:flagship/utils/constants.dart';
import 'package:flagship/flagship.dart';
import 'package:flagship/visitor.dart';
import 'package:flagship/visitor/Ivisitor.dart';

// This class represent the default behaviour
class DefaultStrategy implements IVisitor {
  final Visitor visitor;

  DefaultStrategy(this.visitor);

  @override
  void updateContext<T>(String key, T value) {
    switch (value.runtimeType) {
      case int:
      case double:
      case String:
      case bool:
        visitor.getContext().addAll({key: value as Object});
        break;
      default:
        Flagship.logger(Level.WARNING, CONTEXT_PARAM_ERROR);
    }
  }

  /// Activate
  Future<void> _sendActivate(Modification pModification) async {
    // Construct the activate hit
    // Refractor later the envId
    Activate activateHit = Activate(pModification, visitor.visitorId,
        Flagship.sharedInstance().envId ?? "");

    await visitor.trackingManager.sendActivate(activateHit);
  }

  @override
  Future<void> activateModification(String key) async {
    if (visitor.modifications.containsKey(key)) {
      try {
        var modification = visitor.modifications[key];

        if (modification != null) {
          await _sendActivate(modification);
        }
      } catch (exp) {
        Flagship.logger(Level.EXCEPTIONS, EXCEPTION.replaceFirst("%s", "$exp"));
      }
    }
  }

  @override
  T getModification<T>(String key, T defaultValue, {bool activate = false}) {
    var ret = defaultValue;

    if (visitor.modifications.containsKey(key)) {
      try {
        var modification = visitor.modifications[key];

        if (modification == null) {
          Flagship.logger(
              Level.INFO, GET_MODIFICATION_ERROR.replaceFirst("%s", key));
          return ret;
        }
        switch (T) {
          case double:
            if (modification.value is double) {
              ret = modification.value as T;
              break;
            }

            if (modification.value is int) {
              ret = (modification.value as int).toDouble() as T;
              break;
            }
            Flagship.logger(Level.INFO,
                "Modification value ${modification.value} type ${modification.value.runtimeType} cannot be casted as $T, will return default value");
            break;
          default:
            if (modification.value is T) {
              ret = modification.value as T;
              break;
            }
            Flagship.logger(Level.INFO,
                "Modification value ${modification.value} type ${modification.value.runtimeType} cannot be casted as $T, will return default value");
            break;
        }
        if (activate) {
          /// send activate later
          _sendActivate(modification);
        }
      } catch (exp) {
        Flagship.logger(Level.INFO,
            "an exception raised  $exp , will return a default value ");
      }
    }
    return ret;
  }

  @override
  Map<String, Object>? getModificationInfo(String key) {
    if (visitor.modifications.containsKey(key)) {
      try {
        var modification = visitor.modifications[key];
        return modification?.toJsonInformation();
      } catch (exp) {
        return null;
      }
    } else {
      Flagship.logger(
          Level.ERROR, GET_MODIFICATION_INFO_ERROR.replaceFirst("%s", key));
      return null;
    }
  }

  /// Synchronize modification for the visitor
  @override
  Future<Status> synchronizeModifications() async {
    Flagship.logger(Level.ALL, SYNCHRONIZE_MODIFICATIONS);
    Status state = Flagship.getStatus();
    try {
      var camp = await visitor.decisionManager.getCampaigns(
          Flagship.sharedInstance().envId ?? "",
          visitor.visitorId,
          visitor.getContext());
      // Clear the previous modifications
      visitor.modifications.clear();
      // Update panic value
      visitor.decisionManager.updatePanicMode(camp.panic);
      if (camp.panic) {
        state = Status.PANIC_ON;
        // Update the state when panic mode is ON
        visitor.flagshipDelegate.onUpdateState(state);
      } else {
        var modif = visitor.decisionManager.getModifications(camp.campaigns);
        visitor.modifications.addAll(modif);
        Flagship.logger(
            Level.INFO,
            SYNCHRONIZE_MODIFICATIONS_RESULTS.replaceFirst(
                "%s", "${visitor.modifications}"));
      }
    } catch (error) {
      Flagship.logger(Level.EXCEPTIONS,
          EXCEPTION.replaceFirst("%s", "${error.toString()}"));
    }
    // Return the state
    return state;
  }

  @override
  Future<void> sendHit(BaseHit hit) async {
    await visitor.trackingManager.sendHit(hit);
  }

  @override
  void setConsent(bool isConsent) {
    // Create the hit of consent
    Consent hitConsent = Consent(hasConsented: isConsent);
    // Send hit ...
    visitor.sendHit(hitConsent);
  }
}
