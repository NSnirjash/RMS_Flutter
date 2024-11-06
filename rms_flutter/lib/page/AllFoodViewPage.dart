import 'package:flutter/material.dart';
import 'package:rms_flutter/service/food_service.dart';

import '../model/food.dart';


class AllFoodViewPage extends StatefulWidget {
  const AllFoodViewPage({super.key});

  @override
  State<AllFoodViewPage> createState() => _AllFoodViewPageState();
}

class _AllFoodViewPageState extends State<AllFoodViewPage> {

  late Future<List<Food>> futureFoods;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    futureFoods = FoodService().fetchFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Food>>(
        builder: (BuildContext context, AsyncSnapshot<List<Food>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No food available'));
          } else{
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    final food = snapshot.data![index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListTile(
                            leading: food.image != null
                            ? Image.network("http://localhost:8090/images/${food.image}") : Icon(Icons.fastfood),
                            title: Text(
                                food.name ?? 'Unnamed Food'),
                            subtitle: Text(
                                food.category ?? 'No category Available'),
                            trailing: Text('${food.price}'),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: (){
                                  print('Order this food item: ${food.name}');
                                },
                                child: Text(
                                    'Order Food')
                            ),
                          )
                        ],
                      ),
                    );
                  }
              );
          }
        },
        future: futureFoods,

      ),
    );
  }
}
