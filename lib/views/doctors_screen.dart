import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinai/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../appservices/dermatologist_service.dart';

class AllDoctorsScreen extends StatefulWidget {
  const AllDoctorsScreen({super.key});

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  final RefreshController _refreshController = RefreshController();

  Future<void> _onRefresh() async {
    await _getLocationAndFetchDoctors();
    _refreshController.refreshCompleted();
  }

  List<dynamic> _doctors = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _highlyRatedOnly = true;

  @override
  void initState() {
    super.initState();
    _getLocationAndFetchDoctors();
  }

  Future<void> _getLocationAndFetchDoctors() async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      double? latitude = sp.getDouble("lat");
      double? longitude = sp.getDouble("long");

      final doctors = await DermatologistService.getNearbyDermatologists(
        latitude: latitude!,
        longitude: longitude!,
        problemDetected: _highlyRatedOnly,
      );

      // Sort by rating in descending order
      doctors.sort((a, b) {
        final ratingA = double.tryParse(a['rating']?.toString() ?? '0') ?? 0;
        final ratingB = double.tryParse(b['rating']?.toString() ?? '0') ?? 0;
        return ratingB.compareTo(ratingA); // Descending
      });

      setState(() {
        _doctors = doctors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    final imageUrl = doctor['photos'] != null && doctor['photos'].isNotEmpty
        ? (doctor['photos'][0] is String
        ? doctor['photos'][0]
        : doctor['photos'][0]['url'] ?? '')
        : null;

    final isOpen = (doctor['status']?.toString().toLowerCase() ?? '') == 'open';

    var doctorStatus = doctor;
    debugPrint("Doctor Status: $doctorStatus");
    return InkWell(
      onTap: () => _launchDoctorLocation(doctor, context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl != null
                      ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.person),
                  )
                      : Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            // Right Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(

                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 16),
                          const SizedBox(width: 3),
                          Text(
                            '${doctor['rating'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),

                      const SizedBox(width: 10),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOpen ? Colors.green.shade100 : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isOpen ? 'Open Now' : 'Closed',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isOpen ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                    ],
                  ),
                  const SizedBox(height: 6),

                  Text(
                    doctor['address'] ?? 'No address provided',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: const Text(
          'Nearby Dermatologists',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black),
        ),
        actions: [
          Row(
            children: [
              const Text("Highly Rated", style: TextStyle(fontSize: 12)),
              Switch(
                activeColor: successColor,
                value: _highlyRatedOnly,
                onChanged: (value) {
                  setState(() {
                    _highlyRatedOnly = value;
                    _isLoading = true;
                  });
                  _getLocationAndFetchDoctors();
                },
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _isLoading
          ? const Center(child: SpinKitFadingCircle(
        color: successColor, // or any color you want
        size: 50.0,
      ),)
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : _doctors.isEmpty
          ? const Center(child: Text("No dermatologists found."))
          : SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        header: CustomHeader(
          builder: (context, mode) {
            return Center(
              child: SpinKitThreeBounce( // use any loader you like from flutter_spinkit
                color: successColor,
                size: 30.0,
              ),
            );
          },
        ),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: _doctors.length,
          itemBuilder: (context, index) => _buildDoctorCard(_doctors[index]),
        ),
      )

    );
  }
}

Future<void> _launchDoctorLocation(
    Map<String, dynamic> doctor, BuildContext context) async {
  final String name = doctor['name'] ?? '';
  final String address = doctor['address'] ?? '';
  final String query = Uri.encodeComponent('$name $address');
  final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query');

  print('Map URL: $url'); // Debug log

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Could not open Google Maps")),
    );
  }
}
