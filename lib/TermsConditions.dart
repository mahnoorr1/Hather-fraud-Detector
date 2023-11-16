import 'package:flutter/material.dart';
import 'package:flutter_application_2/SettingsPage.dart';


//page to show the terms and condition of our app ( No interactions )

class TermsConditions extends StatelessWidget {
  const TermsConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF262262),
        body: Stack(
          children: [
            Container(
              //page background 
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.45, 0.6, 0.8, 1.0],
                  colors: [
                    Color.fromRGBO(0, 167, 157, 0.99),
                    Color(0xFF262262),
                    Color(0xFF262262),
                    Color(0xFF262262),
                    Color(0xFF262262),
                  ],
                ),
              ),
            ), 
            //  page content 
            Column(
              children: [
                
                Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 120, horizontal: 25),
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      iconSize: 33,//
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 110),
                    Text(
                      ' الشروط و الأحكام ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, right: 50.0, left: 50.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: 'IBMPlexSansArabic',
                                      ),//
                                      children: [
                                        TextSpan(
                                          text: 'الاستخدام المسموح به:\n\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                        buildBulletPoint(
                                            'يجب عليك استخدام التطبيق وفقًا للقوانين واللوائح المعمول بها.\n'),
                                        buildBulletPoint(
                                            'لا يُسمح بإجراء أي نشاط غير قانوني أو ضار باستخدام التطبيق.'),
                                        TextSpan(
                                          text: '\n\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: ' المحتوى والحقوق:\n\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                        buildBulletPoint(
                                            'جميع حقوق الملكية الفكرية المتعلقة بالتطبيق ومحتواه تعود إلى شركة حذر الناشئة.\n'),
                                        buildBulletPoint(
                                            'يُمنع منعًا باتًا نسخ أو نشر أو توزيع أو استخدام أي جزء من التطبيق دون إذن مسبق منا. '),
                                        TextSpan(
                                          text: '\n\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              'تغييرات في السياسة والأحكام:\n\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                        buildBulletPoint(
                                            'نحتفظ بحق تعديل سياسة الخصوصية والأحكام والشروط في أي وقت. سنقوم بإعلامك بالتغييرات الجوهرية عن طريق تحديث تاريخ آخر تحديث.'),
                                        TextSpan(
                                          text: '\n\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextSpan buildBulletPoint(String text) {
    return TextSpan(
      text: '• $text\n',
    );
  }
}
