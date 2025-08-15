double defaultPadding = 16;
bool kDebugMode = true;
// List<Calllog> listCallLog = [];

List<dynamic> listLoan = [
  {"nominal": 1000.00, "name": "1000.00"},
  {"nominal": 1500.00, "name": "1500.00"},
  {"nominal": 2000.00, "name": "2000.00"},
  {"nominal": 2500.00, "name": "2500.00"},
  {"nominal": 3000.00, "name": "3000.00"},
  {"nominal": 3500.00, "name": "3500.00"},
  {"nominal": 4000.00, "name": "4000.00"},
  {"nominal": 5000.00, "name": "5000.00"},
  {"nominal": 6000.00, "name": "6000.00"},
  {"nominal": 8000.00, "name": "7000.00 - 10000.00"},
  // {"nominal": 10000.00},
];
List<dynamic> listInterest = [
  {"nominal": '35%', "name": "7 days"},
  {"nominal": '40%', "name": "10 days"},
  {"nominal": '45%', "name": "14 days"},
  // {"nominal": 10000.00},
];

List<dynamic> listGender = [
  {"name": "Female", "index": 0},
  {"name": "Male", "index": 1},
];

List<String> list = [
  "Identity Verification",
  "3-minute Review",
  "3-minute Receival"
];

List<dynamic> listRelationship = [
  {"name": "child", "index": 0},
  {"name": "parent", "index": 1},
  {"name": "sibling", "index": 2},
];

List<dynamic> language = [
  {
    "name": "EN",
    "image": "assets/icons/ic_usa.png",
    'id': 'en',
  },
  {
    "name": "HK (繁體中文)",
    "image": "assets/icons/ic_tw.png",
    'id': 'zh-HK', // Traditional Chinese (General)
  },
  // {
  //   "name": "TW (繁體中文)",
  //   "image": "assets/icons/ic_tw.png",
  //   'id': 'zh-Hant', // Traditional Chinese (General)
  // },
  // {
  //   "name": "CN (简体中文)",
  //   "image": "assets/icons/ic_tw.png",
  //   'id': 'zh-Hans', // Simplified Chinese (China)
  // },
  // {
  //   "name": "TWN (繁體中文)",
  //   "image": "assets/icons/ic_taiwan.png",
  //   'id': 'zh-TW', // Taiwanese Mandarin (Traditional Chinese in Taiwan)
  // },
  // {
  //   "name": "MY",
  //   "image": "assets/icons/ic_ml.png",
  //   'id': 'ml',
  // },
  // {
  //   "name": "JP",
  //   "image": "assets/icons/ic_jp.png",
  //   'id': 'ja',
  // },
];
