import 'package:flagship/model/modification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flagship/hits/activate.dart';

void main() {
  test("Activate with Modification object ", () {
    Modification fakeModif = Modification(
        "key", "campaignId", "variationGroupId", "variationId", true, 12);

    Activate activateTest = Activate(fakeModif, "visitorId", "envId");
    var fakeJson = activateTest.toJson();
    expect(fakeJson["vaid"], "variationId");
    expect(fakeJson["caid"], "variationGroupId");
    expect(fakeJson["vid"], "visitorId");
    expect(fakeJson["cid"], "envId");
  });
}
