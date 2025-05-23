import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: unused_import
import '../booking/booking_info_screen.dart';
import '/views/information/cat_list_screen.dart';
import '/viewmodels/auth/auth_view_model.dart';
import '/views/delivery/address_list_screen.dart';
import '/views/cart/order_history_screen.dart';

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
                  _buildIkwell(context,'assets/images/icon/info1.svg', 'Thông tin đơn hàng', OrderHistoryScreen()),
                  SizedBox(height: 16),
                  _buildIkwell(context,'assets/images/icon/info2.svg', 'Thông tin địa chỉ', AddressListScreen()),
                  SizedBox(height: 16),
                  _buildIkwell(context,'assets/images/icon/info3.svg', 'Thông tin thú cưng', CatListScreen()),
                  SizedBox(height: 16),
                  _buildIkwell(context, 'assets/images/icon/booking_info.svg', 'Thông tin đặt lịch', BookingInfoScreen()),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      onTap: () => authViewModel.signOut(context),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/icon/info4.svg',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Đăng xuất',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),         
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xff7FDDE5)
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 Widget _buildIkwell( BuildContext context, String svgPath, String title, Widget destination) {
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
            SvgPicture.asset(
              svgPath,
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
              color: Color(0xff7FDDE5),
            ),
          ],
        ),
      ),
    );
  }
