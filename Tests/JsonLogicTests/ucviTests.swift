//
//  File.swift
//  
//
//  Created by Alexandr Chernyy on 03.08.2021.
//

import XCTest
@testable import JsonLogic
import JSON

class ucviTests: XCTestCase {
  
  func testUVCI() {
      var rule =
      """
        { "extractFromUVCI": [  { "var": "" },  -1  ] }
      """
      XCTAssertNil(try applyRule(rule, to: nil))
      XCTAssertNil(try applyRule(rule, to: "{}"))
      var data = """
        { "data": "URN:UVCI:01:NL:187/37512422923" }
      """
      XCTAssertNil(try applyRule(rule, to: data))

    rule =
    """
        {
                "if": [
                    {
                        "var": "payload.v.0.ci"
                    },
                    {
                        "if": [
                            {
                                "in": [
                                    {
                                        "extractFromUVCI": [
                                            {
                                                "var": "payload.v.0.ci"
                                            },
                                            1
                                        ]
                                    },
                                    [
                                        "A51018098",
                                        "<LOCATIONID2>"
                                    ]
                                ]
                            },
                            false,
                            true
                        ]
                    },
                    true
                ]
            }
    """
    
    data =
    """
        {"external":{"exp":"2022-08-06T13:26:05.000","kid":"6EjzyhNlGDQ=","valueSets":{"covid-19-lab-test-manufacturer-and-name":["1884","2228","1267","1437","2079","2243","1243","2006","1747","2104","2350","1144","2074","1989","1739","1822","1173","1762","1097","1343","1468","1919","1065","1295","2103","1420","2116","1618","2130","1304","1375","1114","1844","1599","1833","1759","2109","2078","1357","1920","1244","1934","1360","770","1216","1490","2241","2101","1484","1495","1466","1162","344","1764","1236","768","2108","2128","1489","1365","2139","2200","1268","345","2147","1331","1957","1253","1223","1296","2090","1197","1501","1967","2017","1456","1606","1392","1775","1906","1333","1769","308","1232","1178","1485","2072","1457","1581","1870","1180","1341","1767","2317","2107","1190","2029","1266","1763","1215","1815","2010","2242","1271","1465","1242","2067","2247","1199","2183","1278","1225","1218","1855","1319","1286","1494","1324","1201","2290","2035","2031","1481","1768","2012","1257","1820","1610","2098","1574","1736","1443","1604","1363","1800","1773","1263","2052","1654","2013"],"covid-19-lab-test-type":["LP6464-4","LP217198-3"],"disease-agent-targeted":["840539006"],"vaccines-covid-19-auth-holders":["ORG-100001981","ORG-100013793","Vector-Institute","Sinovac-Biotech","ORG-100031184","ORG-100024420","ORG-100020693","ORG-100032020","ORG-100030215","ORG-100006270","ORG-100010771","ORG-100001699","Bharat-Biotech","Gamaleya-Research-Institute","ORG-100001417"],"covid-19-lab-result":["260373001","260415000"],"vaccines-covid-19-names":["Sputnik-V","Covishield","Covaxin","EpiVacCorona","EU/1/20/1507","BBIBP-CorV","Inactivated-SARS-CoV-2-Vero-Cell","EU/1/20/1525","CoronaVac","EU/1/20/1528","EU/1/21/1529","Convidecia","CVnCoV"],"country-2-codes":["GS","AG","HR","SY","SK","HK","TJ","AU","SX","DJ","TM","TH","ZM","GH","IR","ST","MC","IT","ZW","VA","DK","MG","CN","UM","RW","ME","IN","MS","TV","SD","BV","SI","BM","PF","GD","KW","EH","SS","MW","CW","NC","HN","GL","IL","YE","UZ","TG","EE","JM","LC","GU","MU","LU","IO","MZ","IE","SC","GB","VC","BA","FR","PG","MK","VN","NG","GF","SN","NL","KR","SM","GG","KP","GI","OM","TZ","KG","AQ","HM","ZA","VG","VI","MN","LT","HT","HU","ML","KZ","AZ","CU","RO","BB","WS","EG","CR","LS","MD","CC","UA","NZ","DM","ID","LB","NP","GN","CK","MY","BN","DE","FI","CO","MV","NE","AE","KH","TF","GQ","TT","PM","GP","LK","VU","CY","MM","SL","CF","BJ","AT","CL","PK","KI","BG","TN","SG","CV","KY","FK","AS","TW","ET","KM","LY","TR","MR","MX","CH","NI","LA","AO","PN","SA","AD","BQ","EC","SH","BO","MO","MQ","MP","IQ","MH","GE","TO","BL","BE","BW","SZ","PR","SR","AL","NF","SV","SE","GY","PT","FO","CA","TL","PE","PW","BT","ES","MA","AW","CG","BS","GA","BR","PH","LR","GR","AF","RS","BH","DZ","BI","US","NU","UY","WF","GW","CX","AM","TD","LV","JO","JP","KE","IM","CI","DO","QA","JE","SJ","AI","SO","BD","BY","NA","KN","SB","CZ","ER","PS","NR","GT","MT","BF","IS","BZ","PY","TC","FM","RU","FJ","CD","TK","RE","NO","YT","UG","PL","LI","MF","AX","PA","GM","CM","AR","VE"],"sct-vaccines-covid-19":["1119349007","1119305005","J07BX03"]},"issuerCountryCode":"DE","validationClock":"2021-08-10T08:56:30.810","iat":"2021-08-06T13:26:05.000"},"payload":{  "ver" : "1.3.0",  "v" : [    {      "tg" : "840539006",      "sd" : 2,      "ma" : "ORG-100001699",      "co" : "DE",      "mp" : "EU/1/20/1528",      "vp" : "1119305005",      "is" : "Robert Koch-Institut",      "ci" : "URN:UVCI:01DE/A51018097/50CUH2UMZUJW382VP58G2Q#F",      "dt" : "2021-04-14",      "dn" : 1    }  ],  "nam" : {    "fnt" : "MUSTERFRAU",    "gnt" : "ERIKA",    "fn" : "Musterfrau",    "gn" : "Erika"  },  "dob" : "1979-04-14"}}
    """
    
    XCTAssertEqual(true, try applyRule(rule, to: data))
    
    
      rule =
      """
        { "extractFromUVCI": [  { "var": "" },  0  ] }
      """
      XCTAssertNil(try applyRule(rule, to: nil))
      data = """
        { "data": "" }
      """
      XCTAssertEqual("", try applyRule(rule, to: data))
      data = """
        { "data": "URN:UVCI:01:NL:187/37512422923" }
      """
      XCTAssertEqual("01", try applyRule(rule, to: data))

      rule =
        """
          { "extractFromUVCI": [  { "var": "" },  1  ] }
      """
      XCTAssertNil(try applyRule(rule, to: nil))
      data = """
        { "data": "" }
      """
      XCTAssertNil(try applyRule(rule, to: data))
      data = """
        { "data": "URN:UVCI:01:NL:187/37512422923" }
      """
      XCTAssertEqual("NL", try applyRule(rule, to: data))
      data = """
        { "data": "01:NL:187/37512422923" }
      """
      XCTAssertEqual("NL", try applyRule(rule, to: data))
      data = """
        { "data": "URN:UVCI:01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
      """
      XCTAssertEqual("AT", try applyRule(rule, to: data))
      data = """
        { "data": "01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
      """
      XCTAssertEqual("AT", try applyRule(rule, to: data))

    rule =
      """
        { "extractFromUVCI": [  { "var": "" },  2  ] }
    """
    data = """
      { "data": "URN:UVCI:01:NL:187/37512422923" }
    """
    XCTAssertEqual("187", try applyRule(rule, to: data))
    data = """
      { "data": "URN:UVCI:01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
    """
    XCTAssertEqual("10807843F94AEE0EE5093FBC254BD813", try applyRule(rule, to: data))
    data = """
      { "data": "foo/bar::baz#999lizards" }
    """
    XCTAssertEqual("", try applyRule(rule, to: data))

    rule =
      """
        { "extractFromUVCI": [  { "var": "" },  3  ] }
    """
    data = """
      { "data": "URN:UVCI:01:NL:187/37512422923" }
    """
    XCTAssertEqual("37512422923", try applyRule(rule, to: data))
    data = """
      { "data": "01:NL:187/37512422923" }
    """
    XCTAssertEqual("37512422923", try applyRule(rule, to: data))
    data = """
      { "data": "URN:UVCI:01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
    """
    XCTAssertEqual("B", try applyRule(rule, to: data))
    data = """
      { "data": "01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
    """
    XCTAssertEqual("B", try applyRule(rule, to: data))
    data = """
      { "data": "foo/bar::baz#999lizards" }
    """
    XCTAssertEqual("baz", try applyRule(rule, to: data))
    data = """
      { "data": "a::c/#/f" }
    """
    XCTAssertEqual("", try applyRule(rule, to: data))

    rule =
      """
        { "extractFromUVCI": [  { "var": "" },  4  ] }
    """
    data = """
      { "data": "URN:UVCI:01:NL:187/37512422923" }
    """
    XCTAssertNil(try applyRule(rule, to: data))
    data = """
      { "data": "01:NL:187/37512422923" }
    """
    XCTAssertNil(try applyRule(rule, to: data))
    data = """
      { "data": "URN:UVCI:01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
    """
    XCTAssertNil(try applyRule(rule, to: data))
    data = """
      { "data": "01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
    """
    XCTAssertNil(try applyRule(rule, to: data))
    data = """
      { "data": "foo/bar::baz#999lizards" }
    """
    XCTAssertEqual("999lizards", try applyRule(rule, to: data))
    data = """
      { "data": "a::c/#/f" }
    """
    XCTAssertEqual("", try applyRule(rule, to: data))

    rule =
      """
        { "extractFromUVCI": [  { "var": "" },  5  ] }
    """
    data = """
      { "data": "foo/bar::baz#999lizards" }
    """
    XCTAssertNil(try applyRule(rule, to: data))
    data = """
      { "data": "a::c/#/f" }
    """
    XCTAssertEqual("f", try applyRule(rule, to: data))
    
  }
  
}
