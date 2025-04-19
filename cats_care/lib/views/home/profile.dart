import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/viewmodels/auth/auth_view_model.dart';
import '/views/delivery/address_list_screen.dart';

class InfoAccount extends StatelessWidget {
  const InfoAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xffE5F8FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(authViewModel.user?.photoURL ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${authViewModel.user?.email ?? ''}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                
              ),
            ),
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 // _buildIkwell('assets/images/icon/info1.png', 'Thông tin cá nhân'),
                  SizedBox(height: 16),
                  _buildIkwell(context,'assets/images/icon/info2.png', 'Thông tin giao hàng', AddressListScreen()),
                  SizedBox(height: 16),
                 // _buildIkwell('assets/images/icon/info3.png', 'Thông tin thú cưng'),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () => authViewModel.signOut(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
 Widget _buildIkwell( BuildContext context, String imagePath, String title, Widget destination) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => destination,
            ),
          );
        },
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),         
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }