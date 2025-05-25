import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDevelopersScreen extends StatelessWidget {
  final List<Developer> developers = [
    Developer(
      name: 'Md Mahmud Hossain Ferdous',
      id: '2122020003',
      githubUrl: 'https://github.com/MHFerdous',
      linkedinUrl: 'https://www.linkedin.com/in/ferdousmh/',
      imagePath: 'assets/images/ferdous.jpg',
    ),
    Developer(
      name: 'Muhammad Nadim',
      id: '2122020018',
      githubUrl: 'https://github.com/MNTDH-18',
      linkedinUrl: 'https://www.linkedin.com/in/muhammad-nadim-183b2921a/',
      imagePath: 'assets/images/nadim.jpg',
    ),
    Developer(
      name: 'Hasan Ahmad',
      id: '2122020030',
      githubUrl: 'https://github.com/HasanJuned',
      linkedinUrl: 'https://www.linkedin.com/in/hasan-ahmad-502391204/',
      imagePath: 'assets/images/hasan.jpg',
    ),
    Developer(
      name: 'Shah Sayem Ahmad',
      id: '2122020043',
      githubUrl: 'https://github.com/ShahSayem',
      linkedinUrl: 'https://www.linkedin.com/in/shah-sayem/',
      imagePath: 'assets/images/sayem.jpg',
    ),
  ];

  AboutDevelopersScreen({super.key});

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildDeveloperCard(Developer developer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(developer.imagePath),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    developer.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('ID: ${developer.id}'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () => _launchUrl(developer.linkedinUrl),
                        child: Text('LinkedIn'),
                      ),
                      TextButton(
                        onPressed: () => _launchUrl(developer.githubUrl),
                        child: Text('GitHub'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Developers')),
      body: ListView.builder(
        itemCount: developers.length,
        itemBuilder: (context, index) {
          return _buildDeveloperCard(developers[index]);
        },
      ),
    );
  }
}

class Developer {
  final String name;
  final String id;
  final String githubUrl;
  final String linkedinUrl;
  final String imagePath;

  Developer({
    required this.name,
    required this.id,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.imagePath,
  });
}
