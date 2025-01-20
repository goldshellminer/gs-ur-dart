import 'dart:typed_data';

import 'package:gs_ur_dart/src/bc_ur/bytewords.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';

void main() {
  group('Bytewords', () {
    const hexInput = 'd9012ca20150c7098580125e2ab0981253468b2dbc5202d8641947da';
    final bufferInput = Uint8List.fromList([
      245, 215, 20, 198, 241, 235, 69, 59, 209, 205, 165, 18, 150, 158, 116, 135,
      229, 212, 19, 159, 17, 37, 239, 240, 253, 11, 109, 191, 37, 242, 38, 120,
      223, 41, 156, 189, 242, 254, 147, 204, 66, 163, 216, 175, 191, 72, 169, 54,
      32, 60, 144, 230, 210, 137, 184, 197, 33, 113, 88, 14, 157, 31, 177, 46,
      1, 115, 205, 69, 225, 150, 65, 235, 58, 144, 65, 240, 133, 69, 113, 247,
      63, 53, 242, 165, 160, 144, 26, 13, 79, 237, 133, 71, 82, 69, 254, 165,
      138, 41, 85, 24
    ]);

    final testCbor = Uint8List.fromList(HEX.decode("a101784b62776552446f6d7964386e44433544563939324767525234626256646166354c3878595376316146585874363261527134785a71614b57786e485735624b43645266374e7272745a417841"));
    final testHexCbor = "a101784b62776552446f6d7964386e44433544563939324767525234626256646166354c3878595376316146585874363261527134785a71614b57786e485735624b43645266374e7272745a417841";

    group('Encoding to Bytewords', () {
      test('Standard', () {
        expect(encode(hexInput, style: Styles.standard),
            'tuna acid draw oboe acid good slot axis limp lava brag holy door puff monk brag guru frog luau drop roof grim also trip idle chef fuel twin tied draw grim ramp');
        expect(encode(bufferInput.buffer.asUint8List().map((e) => e.toRadixString(16).padLeft(2, '0')).join(), style: Styles.standard),
            'yank toys bulb skew when warm free fair tent swan open brag mint noon jury list view tiny brew note body data webs what zinc bald join runs data whiz days keys user diet news ruby whiz zone menu surf flew omit trip pose runs fund part even crux fern math visa tied loud redo silk curl jugs hard beta next cost puma drum acid junk swan free very mint flap warm fact math flap what limp free jugs yell fish epic whiz open numb math city belt glow wave limp fuel grim free zone open love diet gyro cats fizz holy city puff');
      });

      test('URI', () {
        expect(encode(hexInput, style: Styles.uri),
            'tuna-acid-draw-oboe-acid-good-slot-axis-limp-lava-brag-holy-door-puff-monk-brag-guru-frog-luau-drop-roof-grim-also-trip-idle-chef-fuel-twin-tied-draw-grim-ramp');
        expect(encode(bufferInput.buffer.asUint8List().map((e) => e.toRadixString(16).padLeft(2, '0')).join(), style: Styles.uri),
            'yank-toys-bulb-skew-when-warm-free-fair-tent-swan-open-brag-mint-noon-jury-list-view-tiny-brew-note-body-data-webs-what-zinc-bald-join-runs-data-whiz-days-keys-user-diet-news-ruby-whiz-zone-menu-surf-flew-omit-trip-pose-runs-fund-part-even-crux-fern-math-visa-tied-loud-redo-silk-curl-jugs-hard-beta-next-cost-puma-drum-acid-junk-swan-free-very-mint-flap-warm-fact-math-flap-what-limp-free-jugs-yell-fish-epic-whiz-open-numb-math-city-belt-glow-wave-limp-fuel-grim-free-zone-open-love-diet-gyro-cats-fizz-holy-city-puff');
      });

      test('Minimal', () {
        // expect(encode(hexInput, style: Styles.minimal),
        //     'taaddwoeadgdstaslplabghydrpfmkbggufgludprfgmaotpiecffltntddwgmrp');
       expect(encode(testHexCbor, style: Styles.minimal),
            'oyadksgridktihgmfyjljnkkieetjtfyfxecfyhfeseseyfliogmgmeeididhfiehsiyecgsetkshkgukoehhsfghdhdjyeneyhsgmjseekshtjshsgrhgksjtfdhgecidgrfxiegmiyemgljpjpjyhtfpksfpfhtnlpgl');
        // expect(encode(bufferInput.buffer.asUint8List().map((e) => e.toRadixString(16).padLeft(2, '0')).join(), style: Styles.minimal),
        //     'yktsbbswwnwmfefrttsnonbgmtnnjyltvwtybwnebydawswtzcbdjnrsdawzdsksurdtnsrywzzemusffwottppersfdptencxfnmhvatdldroskcljshdbantctpadmadjksnfevymtfpwmftmhfpwtlpfejsylfhecwzonnbmhcybtgwwelpflgmfezeonledtgocsfzhycypf');
      });
    });

    group('Decoding from Bytewords', () {
      test('Standard', () {
        expect(decode(
            'tuna acid draw oboe acid good slot axis limp lava brag holy door puff monk brag guru frog luau drop roof grim also trip idle chef fuel twin tied draw grim ramp',
            style: Styles.standard),
            hexInput);
        expect(decode(
            'yank toys bulb skew when warm free fair tent swan open brag mint noon jury list view tiny brew note body data webs what zinc bald join runs data whiz days keys user diet news ruby whiz zone menu surf flew omit trip pose runs fund part even crux fern math visa tied loud redo silk curl jugs hard beta next cost puma drum acid junk swan free very mint flap warm fact math flap what limp free jugs yell fish epic whiz open numb math city belt glow wave limp fuel grim free zone open love diet gyro cats fizz holy city puff',
            style: Styles.standard),
            bufferInput.buffer.asUint8List().map((e) => e.toRadixString(16).padLeft(2, '0')).join());
      });

      test('URI', () {
        expect(decode(
            'tuna-acid-draw-oboe-acid-good-slot-axis-limp-lava-brag-holy-door-puff-monk-brag-guru-frog-luau-drop-roof-grim-also-trip-idle-chef-fuel-twin-tied-draw-grim-ramp',
            style: Styles.uri),
            hexInput);
        expect(decode(
            'yank-toys-bulb-skew-when-warm-free-fair-tent-swan-open-brag-mint-noon-jury-list-view-tiny-brew-note-body-data-webs-what-zinc-bald-join-runs-data-whiz-days-keys-user-diet-news-ruby-whiz-zone-menu-surf-flew-omit-trip-pose-runs-fund-part-even-crux-fern-math-visa-tied-loud-redo-silk-curl-jugs-hard-beta-next-cost-puma-drum-acid-junk-swan-free-very-mint-flap-warm-fact-math-flap-what-limp-free-jugs-yell-fish-epic-whiz-open-numb-math-city-belt-glow-wave-limp-fuel-grim-free-zone-open-love-diet-gyro-cats-fizz-holy-city-puff',
            style: Styles.uri),
            bufferInput.buffer.asUint8List().map((e) => e.toRadixString(16).padLeft(2, '0')).join());
      });

      test('Minimal', () {
        expect(decode(
            'taaddwoeadgdstaslplabghydrpfmkbggufgludprfgmaotpiecffltntddwgmrp',
            style: Styles.minimal),
            hexInput);
        expect(decode(
            'yktsbbswwnwmfefrttsnonbgmtnnjyltvwtybwnebydawswtzcbdjnrsdawzdsksurdtnsrywzzemusffwottppersfdptencxfnmhvatdldroskcljshdbantctpadmadjksnfevymtfpwmftmhfpwtlpfejsylfhecwzonnbmhcybtgwwelpflgmfezeonledtgocsfzhycypf',
            style: Styles.minimal),
            bufferInput.buffer.asUint8List().map((e) => e.toRadixString(16).padLeft(2, '0')).join());
      });

      test('Invalid checksums', () {
        expect(() => decode('able acid also lava zero jade need echo wolf', style: Styles.standard),
            throwsA(isA<AssertionError>()));

        expect(() => decode('able-acid-also-lava-zero-jade-need-echo-wolf', style: Styles.uri),
            throwsA(isA<AssertionError>()));

        expect(() => decode('aeadaolazojendeowf', style: Styles.minimal),
            throwsA(isA<AssertionError>()));
      });

      test('Too short', () {
        expect(() => decode('wolf'), throwsA(isA<AssertionError>()));
        expect(() => decode(''), throwsA(isA<AssertionError>()));
      });
    });
  });
}
