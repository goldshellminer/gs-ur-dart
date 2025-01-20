import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gs_ur_dart/gs_ur_dart.dart';
import 'package:gs_ur_dart/src/utils/format.dart';

void main() {
  group('MultiAccount', () {
    test('MultiAccount parseHDKey', () {
      const cbor =
          "a6011a1f83c327028cd99d6fa702f4035821037fb66bad14245d08994f715480b276b73fd33e109f94f589021be6275984c861045820529aa275a0e19c9d3e0fc82381927f9b63f8dbcc8332d1c36250db6ede23aba405d99d71a20100020006d99d70a30186182cf500f500f5021a1f83c3270303081a8570c6f20a757b22636861696e223a5b22426974636f696e225d7dd99d6fa702f4035821033cdf0f1101dbf2e4a877b6b779aa59d345cb649c507cef76928e68c00789f83a04582030884b52c8ed7c80eb42d967c62a3e26e5f5ea8c071f2a0bb3c47c7f4604de2405d99d71a20100020006d99d70a301861856f500f500f5021a1f83c3270303081af8bf64b60a757b22636861696e223a5b22426974636f696e225d7dd99d6fa702f40358210377d99c1b2762804f04263aeb470f9a89ece15cbc44977249e5c8e4843126dd27045820b154fee3bf6210099ba1eab2c86fe525fc63abe1c8509abe88aa814574cc6e6005d99d71a201183c020006d99d70a30186182cf5183cf500f5021a1f83c3270303081addf87ca10a786d7b22636861696e223a5b22457468657265756d222c2022424e42222c2022506f6c79676f6e222c20227a6b53796e635f457261222c202242617365222c202246616e746f6d222c20224f7074696d69736d222c20224176616c616e636865222c2022417262697472756d225d7dd99d6fa702f4035821023be1fb528f2879dabfcb9ef3f8df09e134529986a3099819a56ba756b2cd7cf20458208434e058b5151ed764e00dd673e4d99fb4b6471194276f410f41b195ec0072b705d99d71a20103020006d99d70a30186182cf503f500f5021a1f83c3270303081a0e00be040a767b22636861696e223a5b22446f6765636f696e225d7dd99d6fa702f403582103998a17d8b56fe8a1cfadcc36caa22c8c14caea82199975da675e8ed74f515a4c0458205f7be7ab3ee3197db0a8564abf8f4e46c60319710a756375deb3eb844df34d2b05d99d71a20102020006d99d70a30186182cf502f500f5021a1f83c3270303081ac219b3410a767b22636861696e223a5b224c697465636f696e225d7dd99d6fa702f403582103adbd02ea6df0c33665a101c4446e53074306f1eac29690bc30e4dfc67b68466d0458209de39bd82c383e0c5684e5ceb1d110ddc1eda7a17db60bfbcfcccb3935518d6b05d99d71a2011891020006d99d70a30186182cf51891f500f5021a1f83c3270303081a2b3acdc10a781a7b22636861696e223a5b22426974636f696e5f43617368225d7dd99d6fa402f4035820d9aa0cde2dd59caa4e04fe703439abba02d81391adb78dd1e67130e93684951206d99d70a30188182cf51901f5f500f500f5021a1f83c32703040a747b22636861696e223a5b22536f6c616e61225d7dd99d6fa702f403582102e0a8cffd52c021cbeb230c40e8a0d1f27747cec2ed67b079ee8da95c3ba4ef80045820568e2e7c72a7f94e68ed5367975b9afd5c56bb252704dfe2ace880d53cb0dbeb05d99d71a2011876020006d99d70a30186182cf51876f500f5021a1f83c3270303081af767522a0a781f7b22636861696e223a5b22436f736d6f735f487562222c2022536569225d7dd99d6fa702f403582102aec43485ff0e6aa1a18e6c1940345a0c8cece82fd7a448c45f1f6c30ad66e4c80458206226bb712a1e7a2e4b15b39803f92656684f2328e6f40f08f94907f733638b9405d99d71a2011901cb020006d99d70a30186182cf51901cbf500f5021a1f83c3270303081a2df5d89b0a727b22636861696e223a5b224b617661225d7dd99d6fa702f403582103ce9a502273e3877e29f70a2e106b26b809e90035f511a0488c30579f7e523165045820d04e00a69f031565da91435de54a0d691b250cc598b1404eb48e2d8b80bfb37005d99d71a20118c3020006d99d70a30186182cf518c3f500f5021a1f83c3270303081aae7b97330a727b22636861696e223a5b2254726f6e225d7dd99d6fa702f403582103652c6304c6ae0970688a2205aae872f825872128b4b7ee4b87f583592ec6f8ac045820be07bb75cf6561acfc7e0434a8feb3cf97ffcf0ec0247f0ffe2024809bb7662c05d99d71a2011904d2020006d99d70a30186182cf51904d2f500f5021a1f83c3270303081aa2952c100a767b22636861696e223a5b22416c65706869756d225d7dd99d6fa702f403582102075aefa9ab67f17d9eb60854e2d6357859d4df67810315edc0573f61208063a9045820bcb27cad4ccda2b6d0a450d76c65a5c1f8f518b4b531482a7dc9f66474b0ab5b05d99d71a2011a0001b207020006d99d70a30186182cf51a0001b207f500f5021a1f83c3270303081ab3ebc5230a737b22636861696e223a5b224b61737061225d7d0368475357414c4c45540470485130314249343231374445323937330565302e302e37066462616279";
      UR ur = UR(fromHex(cbor), "crypto-multi-accounts");
      final account = parseMultiAccounts(ur);
      expect(account, {
        "device": "GSWALLET",
        "masterFingerprint": "27c3831f",
        "keys": [
          {
            "chain": "BTC",
            "path": "m/44'/0'/0'",
            "publicKey":
                "037fb66bad14245d08994f715480b276b73fd33e109f94f589021be6275984c861",
            "name": null,
            "xfp": "27c3831f",
            "chainCode":
                "529aa275a0e19c9d3e0fc82381927f9b63f8dbcc8332d1c36250db6ede23aba4",
            "extendedPublicKey":
                "xpub6CdezvjFXdc95pLVoAAfGEnS9MyVW1d763AMwDzDgr6aj6Fx67kzxmq3ugpSxYLHi6A8yNciYxTjg3sPy5UAJQptMwH2gBm4APtsrT3pd51",
            "note": "{\"chain\":[\"Bitcoin\"]}"
          },
          {
            "chain": "BTC",
            "path": "m/86'/0'/0'",
            "publicKey":
                "033cdf0f1101dbf2e4a877b6b779aa59d345cb649c507cef76928e68c00789f83a",
            "name": null,
            "xfp": "27c3831f",
            "chainCode":
                "30884b52c8ed7c80eb42d967c62a3e26e5f5ea8c071f2a0bb3c47c7f4604de24",
            "extendedPublicKey":
                "xpub6DUp5pGy2P3emgQgoes1Qqmf2SmVB4c6tXAqcgDuKfXmNMv7kdnXmmFFcrNmaTbZiN4bNDcrEd6rHxkUE24J3Ehj14CVuGtJQhQhoccgAyZ",
            "note": "{\"chain\":[\"Bitcoin\"]}"
          },
          {
            "chain": "ETH",
            "path": "m/44'/60'/0'",
            "publicKey":
                "0377d99c1b2762804f04263aeb470f9a89ece15cbc44977249e5c8e4843126dd27",
            "name": null,
            "xfp": "27c3831f",
            "chainCode":
                "b154fee3bf6210099ba1eab2c86fe525fc63abe1c8509abe88aa814574cc6e60",
            "extendedPublicKey":
                "xpub6DHPziqQ7we7dDW3MfEZN6GiTpj6mXM9SFdtu3gBvVUYm3D1LQHk6Cpf6DfBWojtwqPqHggXKqVqPacAV5R2MHqfJuECXZHFNxekjd4L31N",
            "note":
                "{\"chain\":[\"Ethereum\", \"BNB\", \"Polygon\", \"zkSync_Era\", \"Base\", \"Fantom\", \"Optimism\", \"Avalanche\", \"Arbitrum\"]}"
          },
          {
            "chain": "DOGE",
            "path": "m/44'/3'/0'",
            "publicKey":
                "023be1fb528f2879dabfcb9ef3f8df09e134529986a3099819a56ba756b2cd7cf2",
            "name": null,
            "xfp": "27c3831f",
            "chainCode":
                "8434e058b5151ed764e00dd673e4d99fb4b6471194276f410f41b195ec0072b7",
            "extendedPublicKey":
                "dgub8rGZN9qEr6ovMe7qqh9YYfJD5H5EfptJX5Zcwk8y3npTCecvPasmtbxJ1RAbx8UEVddC9bMQ6MuxQWXJaz5JBY9UEjgTRynmB2uj5F4miD5",
            "note": "{\"chain\":[\"Dogecoin\"]}"
          },
          {
            "chain": "LTC",
            "path": "m/44'/2'/0'",
            "publicKey":
                "03998a17d8b56fe8a1cfadcc36caa22c8c14caea82199975da675e8ed74f515a4c",
            "name": null,
            "xfp": "27c3831f",
            "chainCode":
                "5f7be7ab3ee3197db0a8564abf8f4e46c60319710a756375deb3eb844df34d2b",
            "extendedPublicKey":
                "Ltub2ZWdLPKENgxVfBQLoB1ajf8Z2qBGUJjGzHw9J5jqmGZXS5kwwb2A4UwVt1wPrdUNvPcA5pG6ttv5HagdL41rxecWa4JefLembpAm8mCZ6LQ",
            "note": "{\"chain\":[\"Litecoin\"]}"
          },
          {
            "chain": "BCH",
            "path": "m/44'/145'/0'",
            "publicKey":
                "03adbd02ea6df0c33665a101c4446e53074306f1eac29690bc30e4dfc67b68466d",
            "name": null,
            "xfp": "27c3831f",
            "chainCode":
                "9de39bd82c383e0c5684e5ceb1d110ddc1eda7a17db60bfbcfcccb3935518d6b",
            "extendedPublicKey":
                "xpub6ByCSoQ9oRau8AKFEhyNgSkLB1P2brxhsrWTf6wGAdLqrFrX2xm4pmSpqNjXwaXLzbUB8qKuyygmzEU9tTH9krEuAHa77uFk8VJhVip3sN9",
            "note": "{\"chain\":[\"Bitcoin_Cash\"]}"
          },
          {
            "chain": "SOL",
            "path": "m/44'/501'/0'/0'",
            "publicKey":
                "d9aa0cde2dd59caa4e04fe703439abba02d81391adb78dd1e67130e936849512",
            "name": null,
            "xfp": "27c3831f",
            "chainCode": null,
            "extendedPublicKey": null,
            "note": "{\"chain\":[\"Solana\"]}"
          },
          {
            "chain": "ATOM",
            "path": "m/44'/118'/0'",
            "publicKey":
                "02e0a8cffd52c021cbeb230c40e8a0d1f27747cec2ed67b079ee8da95c3ba4ef80",
            "name": null,
            "xfp": "27c3831f",
            "chainCode":
                "568e2e7c72a7f94e68ed5367975b9afd5c56bb252704dfe2ace880d53cb0dbeb",
            "extendedPublicKey":
                "xpub6DUErKuJGnTgYADVvvSFgHYtvXcLYMahy4BaaTZwXXfZtJ9K6nxkUpg5jv8seyMm1kzHJfYDc45zG9e3shtWJ85YXXsU3wg1wkXG7pcuUB3",
            "note": "{\"chain\":[\"Cosmos_Hub\", \"Sei\"]}"
          },
          {
            "chain": "KAVA",
            "path": "m/44'/459'/0'",
            "publicKey":
                "02aec43485ff0e6aa1a18e6c1940345a0c8cece82fd7a448c45f1f6c30ad66e4c8",
            "name": null,
            "xfp": "27c3831f",
            "chainCode":
                "6226bb712a1e7a2e4b15b39803f92656684f2328e6f40f08f94907f733638b94",
            "extendedPublicKey":
                "xpub6BzMxpucZLUSGwknkFXz1wVDjmj72DUs9R8TASPJknz2tDKxX4WBuFCd34JLtcuSM9ZgZxsQBXaxtBoMwd2RMwmbYCZxvfDSk4upXSkXVS7",
            "note": "{\"chain\":[\"Kava\"]}"
          },
          {
            "chain": "TRX",
            "path": "m/44'/195'/0'",
            "publicKey":
                "03ce9a502273e3877e29f70a2e106b26b809e90035f511a0488c30579f7e523165",
            "name": null,
            "xfp": "27c3831f",
            "chainCode":
                "d04e00a69f031565da91435de54a0d691b250cc598b1404eb48e2d8b80bfb370",
            "extendedPublicKey":
                "xpub6Cw9oxHtEF5FQL46jEmh2n7H2QUWvJuqihfHtRf9kjVbgargFYzCDuV4KMTk8eb3CzmNaURb4mZVxdhRFJmseM3jKqma3c6LxA6Vj95B818",
            "note": "{\"chain\":[\"Tron\"]}"
          },
          {
            "chain": "ALPH",
            "path": "m/44'/1234'/0'",
            "publicKey":
                "03652c6304c6ae0970688a2205aae872f825872128b4b7ee4b87f583592ec6f8ac",
            "name": null,
            "xfp": "27c3831f",
            "chainCode":
                "be07bb75cf6561acfc7e0434a8feb3cf97ffcf0ec0247f0ffe2024809bb7662c",
            "extendedPublicKey":
                "xpub6Cr5ZxZze4x42HDNZfjm7zZt5oVEtn4YqiUu7BY16V7vibP3hPK65DaVNVwrtpsByq1tZkkE1KkjLTcmcoboQMGTZkXQsFQZkpwjvXRjr72",
            "note": "{\"chain\":[\"Alephium\"]}"
          },
          {
            "chain": "KAS",
            "path": "m/44'/111111'/0'",
            "publicKey":
                "02075aefa9ab67f17d9eb60854e2d6357859d4df67810315edc0573f61208063a9",
            "name": null,
            "xfp": "27c3831f",
            "chainCode":
                "bcb27cad4ccda2b6d0a450d76c65a5c1f8f518b4b531482a7dc9f66474b0ab5b",
            "extendedPublicKey":
                "xpub6CyUGvaHsKmHKSgyTssHgZUcdymuNxwcVY431h6psm1J57mftsgyhioCErvohw5fRLj5jnbNuQ9J4m6JZ7GkRCmZhS24SrcgTVxK1hAvdFe",
            "note": "{\"chain\":[\"Kaspa\"]}"
          }
        ],
        "deviceId": "HQ01BI4217DE2973",
        "version": "0.0.7",
        "nickName": "baby"
      });
    });
  });
}
