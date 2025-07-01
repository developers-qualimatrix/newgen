import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Privacy Policy'),
                  _buildSectionText(
                    'Newgen Insurance Broking Private Limited as mentioned in this privacy policy(‘Privacy Policy’) (hereinafter referred to as "Newgen”) is concerned about the privacy of the data and information of the users accessing and availing services on any of Newgen websites including without limitation ‘pos.insuranzee.com’, mobile sites,mobile applications or chrome extension or plugins thereof accessible through various internet enabled smart devices (individually and collectively referred to as"Platform") or otherwise doing business with Newgen. This Privacy Policy applies to Newgen and helps you understand how we collect, use, store, process, transfer, share and otherwise deal with and protect all your information when you visit any of our Platform and avail our services or even otherwise visit the Platform.THIS PRIVACY POLICY IS AN ELECTRONIC RECORD IN THE FORM OF ELECTRONIC CONTRACT IN TERMS OF INDIAN INFORMATION TECHNOLOGY ACT, 2000 AND RULES MADE THEREUNDER MENDED FROM TIME TO TIME) AND DOES NOT REQUIRE ANY PHYSICAL SIGNATURE OR SEAL.The term "We"/ "Us" / "Our" used in this document refer to Newgen and "You" / "Your" / "Yourself" refer to the users, who visit or access or use (collectively "usage") Platform.',
                  ),
                  const SizedBox(height: 24),
                  _buildRule('3.1'),
                  _buildRuleText(
                    'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable. If you are going to use a passage of Lorem Ipsum.',
                  ),
                  const SizedBox(height: 16),
                  _buildRule('3.2'),
                  _buildSectionTitle('Terms & Conditions'),
                  const Text(
                    "Acknowledgement",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  _buildRuleText(
                    "PLEASE READ THIS PRIVACY POLICY CAREFULLY. YOU INDICATE THAT YOU UNDERSTAND, AGREE AND CONSENT TO THIS PRIVACY POLICY. HENCE BY VISITING OUR PLATFORM OR BY AVAILING ANY OF OUR SERVICE, YOU HEREBY GIVE YOUR UNCONDITIONAL CONSENT OR AGREEMENT TO Newgen AS PROVIDED UNDER SECTION 43A AND SECTION 72A OF INDIAN INFORMATION TECHNOLOGY ACT, 2000 FOR COLLECTION, USE, STORAGE, PROCESSING, SHARINGAND TRANSFER AND DISCLOSURE OF YOUR INFORMATION. YOU ACKNOWLEDGE THAT YOU HAVE ALL LEGAL RIGHTS AND LAWFUL AUTHORITY TO SHARE THE INFORMATION WITH US AND FURTHER ACKNOWLEDGE THAT BY COLLECTING, SHARING, PROCESSING AND TRANSFERRING INFORMATION PROVIDED BY YOU, SHALL NOT CAUSE ANY LOSS OR WRONFUL GAIN TO YOU OR ANY OTHER PERSON. IF YOU DO NOT AGREE WITH THE TERMS OF THIS PRIVACY POLICY, PLEASE DO NOT ACCESS / USE OUR PLATFORM OR AVAIL ANY OF OUR SERVICE ON OUR PLATFORM.",
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Controller of Personal Information",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildRuleText(
                    'Newgen will be the controller of Your Personal Information provided by You or otherwise collected by Us. Your data controller is responsible for the collection, use, disclosure, retention, and protection of your Personal Information in accordance with its privacy standards as well as any applicable laws.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Information We Collect (Your Information):",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildSectionText(
                    'We collect your information during your usage of the Platform or when you avail any services, either as a registered user or otherwise. The information collected may consist of:',

                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '• Personal Information:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildSectionText(
                      '  - Full name, age, address, email ID, phone number, date of birth, gender.'),
                  _buildSectionText(
                      '  - Financial information, and any other sensitive personal data.'),
                  _buildSectionText(
                      '  - Collected when you create an account, fill out a form, or respond to a survey.'),
                  const SizedBox(height: 10),
                  const Text(
                    '• Non-Personal Information:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildSectionText(
                      '  - Usage: Content you view or engage with, features used, searches, browsing info, actions taken, time/frequency/duration of activities.'),
                  _buildSectionText(
                      '  - Device Information: Device type, IP address, OS, browser, device ID, network info, last URL visited, location (if permitted), etc.'),
                  _buildSectionText(
                      '  - Preferences: Your language, time zone, and geographic settings.'),
                  _buildSectionText(
                      '  - Social Media: Your social media user ID and public information (Facebook, Google, etc.) when you connect with the Platform.'),
                  _buildSectionText(
                      '  - Transaction Info: Policy coverage, claim data, premium/payment history.'),
                  _buildSectionText(
                      '  - Insurance Application Data: As required by insurers or provided in forms/questionnaires.'),
                  const SizedBox(height: 10),
                  const Text(
                    '• Cookies and Electronic Tools:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildSectionText(
                      '  - Use of cookies, pixel tags, web beacons, mobile device IDs, flash cookies, etc.'),
                  _buildSectionText(
                      '  - You can disable/block cookies through browser/device settings.'),
                  _buildSectionText(
                      '  - Disabling cookies may affect Platform functionality.'),
                  const SizedBox(height: 10),
                  const Text(
                    '• Browser Add-ons / Extensions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildSectionText(
                      '  - Add-ons can access your data on all websites you visit, tabs, and browser activity.'),
                  _buildSectionText(
                      '  - Extensions enhance experience and store data locally.'),
                  _buildSectionText(
                      '  - We may capture your email address and other details to notify and serve you better.'),
                  _buildSectionText(
                      '  - By adding our extension, you explicitly permit us and third parties (as applicable) to:'),
                  _buildSectionText('    • Display notifications'),
                  _buildSectionText(
                      '    • Read/change your browsing history, bookmarks, apps, extensions, and themes'),
                  _buildSectionText('    • Detect your physical location'),
                  _buildSectionText('    • Access all your data on visited websites'),
                  const SizedBox(height: 24),
                  const Text(
                    'For the complete list of Privacy Policy and Terms, please visit our website.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
        height: 1.5,
      ),
    );
  }

  Widget _buildRule(String ruleNumber) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        'Rule #$ruleNumber',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildRuleText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
        height: 1.5,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterLink('Terms of use'),
              Text(' • ', style: TextStyle(color: Colors.grey)),
              _buildFooterLink('Privacy Policy'),
              Text(' • ', style: TextStyle(color: Colors.grey)),
              _buildFooterLink('FAQ'),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'In case of any query, email us at',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Insuranzee@example.com',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
