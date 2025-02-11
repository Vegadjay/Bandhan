import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Colors.yellow[100],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 200,
                ),
              ),
              SizedBox(height: 20),

              // Team Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meet Our Team',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      Divider(),
                      _infoRow('Developed by:', 'Jay Vegad (23010101294)'),
                      _infoRow('Mentored by:',
                          'Prof. Mehul Bhundiya (Computer Engineering Department), School of Computer Science'),
                      _infoRow('Explored by:',
                          'ASWDC, School Of Computer Science, School of Computer Science'),
                      _infoRow('Eulogized by:',
                          'Darshan University, Rajkot, Gujarat - INDIA'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // About Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('/darshanlogo.png', height: 40),
                          SizedBox(width: 10),
                          Text(
                            'Darshan University',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'ASWDC is an Application, Software and Website Development Center @ Darshan University, run by students and staff of the School of Computer Science.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(
              text: title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' $value'),
          ],
        ),
      ),
    );
  }
}
