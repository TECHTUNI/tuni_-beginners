// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class OrderProgressBar extends StatelessWidget {
//   final int? currentIndex ;
//   final int? totalSteps;
//
//   const OrderProgressBar(
//       {super.key, this.currentIndex, this.totalSteps});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20.0),
//       child: Platform.isIOS
//           ? CupertinoScrollbar(
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: totalSteps,
//                 itemBuilder: (context, index) {
//                   final isActive = index <= currentIndex!;
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 30.0,
//                           height: 30.0,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: isActive
//                                 ? CupertinoColors.activeBlue
//                                 : CupertinoColors.systemGrey,
//                           ),
//                           child: Center(
//                             child: Text(
//                               (index + 1).toString(),
//                               style: TextStyle(
//                                 color: isActive
//                                     ? CupertinoColors.white
//                                     : CupertinoColors.systemGrey,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8.0),
//                         Text(
//                           'Step ${index + 1}',
//                           style: TextStyle(
//                             color: isActive
//                                 ? CupertinoColors.black
//                                 : CupertinoColors.systemGrey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             )
//           : Stepper(
//               currentStep: currentIndex!,
//               steps: List.generate(
//                 totalSteps!,
//                 (index) => Step(
//                   title: Text('Step ${index + 1}'),
//                   content: const SizedBox.shrink(),
//                   isActive: index <= currentIndex!,
//                 ),
//               ),
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';

List<Order> orders = [
  Order(id: '1', status: OrderStatus.processing),
  Order(id: '2', status: OrderStatus.delivered),
  Order(id: '3', status: OrderStatus.shipping),
  Order(id: '4', status: OrderStatus.cancelled),
];

enum OrderStatus { processing, shipping, delivered, cancelled }

class Order {
  final String id;
  final OrderStatus status;

  Order({required this.id, required this.status});
}

class OrderTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text('Order ID: ${order.id}'),
            subtitle: Text('Status: ${getStatusText(order.status)}'),
            trailing: Icon(getStatusIcon(order.status)),
          );
        },
      ),
    );
  }

  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipping:
        return 'Shipping';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  IconData getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Icons.pending;
      case OrderStatus.shipping:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }
}
