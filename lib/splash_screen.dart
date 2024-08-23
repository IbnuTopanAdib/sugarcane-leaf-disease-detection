import 'package:flutter/material.dart';
import 'package:sugarcane_detection/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        Future.delayed(const Duration(milliseconds: 3000), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const HomeScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            // Wave di atas
            Opacity(
              opacity: 0.5,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  color: Colors.blue,
                  height: 200,
                ),
              ),
            ),
            // Wave di bawah (terbalik)
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: 0.5,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationX(3.14159) *
                      Matrix4.rotationY(3.14159), // Membalik secara vertikal
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      color: Color(0xFF34a203),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              ),
            ),
            // Logo di tengah
            Center(
              child: Image.asset('assets/image/logo.png', height: 100, width: 100,),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100); // Mulai dari kiri bawah
    var firstStart =
        Offset(size.width / 5, size.height); // Titik awal lengkungan pertama
    var firstEnd = Offset(size.width / 2.25,
        size.height - 50.0); // Titik akhir lengkungan pertama

    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24),
        size.height - 105); // Titik awal lengkungan kedua
    var secondEnd =
        Offset(size.width, size.height - 50); // Titik akhir lengkungan kedua

    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0); // Garis dari kanan ke atas
    path.close(); // Menutup path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // Tidak perlu meng-reclip kecuali jika ada perubahan properti
  }
}
