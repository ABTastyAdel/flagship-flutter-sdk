import 'package:flagship/flagship.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flagship/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  test('Start Client ', () {
    Flagship.start("envId", "apiKey");

    Flagship.setCurrentVisitor(
        Flagship.newVisitor("user1").withContext({"key1": "val1", "key2": 2, "key3": true, "key4": 12.01}).build());
    var v1 = Flagship.getCurrentVisitor();

    // Check the user id
    expect(v1?.visitorId, "user1");
    // check the mode
    expect(v1?.config.decisionMode, Mode.DECISION_API);
    expect(v1?.getConsent(), true);

    // Create visitor v2
    var v2 = Flagship.newVisitor("user2")
        .withContext({"key1": "val1", "key2": 2, "key3": true, "key4": 12.01})
        .hasConsented(false)
        .build();
    expect(v2.visitorId, "user2");
    expect(v2.getConsent(), false);
    v2.setConsent(true);
    expect(v2.getConsent(), true);
  });
}
