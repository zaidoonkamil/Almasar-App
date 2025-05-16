import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:delivery_app/core/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class ChangingOrdersDelivery extends StatelessWidget {
  const ChangingOrdersDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DeliveryCubit()..connectToSocket(),
      child: BlocConsumer<DeliveryCubit,DeliveryStates>(
        listener: (context,state){
          if (state is SocketGetOrderSuccessState) {
            print("✅ Orders data updated");
          }
        },
        builder: (context,state){
          var cubit=DeliveryCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F8),
              body: Column(
                children: [
                  const SizedBox(height: 40),
                 GestureDetector(onTap: (){
                   cubit.listenToOrders();
                 }, child: Icon(Icons.add_a_photo_outlined,size: 100,)),
                 ConditionalBuilder(
                     condition: cubit.orderChangeModel.isNotEmpty,
                     builder: (c){
                       return Expanded(
                         child: ListView.builder(
                           itemCount: cubit.orderChangeModel.length ?? 0,
                           itemBuilder: (context, index) {
                             var order = cubit.orderChangeModel[index];
                             return ListTile(
                               title: Text(order.phone),
                               subtitle: Text("الزبون: ${order.user.name}",style: TextStyle(color: Colors.black54,fontSize: 55),),
                               trailing: Text(order.status),
                             );},
                         ),
                       );
                     },
                     fallback: (c)=>Container()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
