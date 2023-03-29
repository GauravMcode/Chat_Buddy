  
  //For getting userslist through json  file 
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   dataAsIterable = {};
  //   getUserData();
  // }

  // Map<String, dynamic>? data;
  // dynamic dataAsIterable;
  // var texts;
  // var length;
  // List dataAsList = [];
  // List<String> users = [];

  // getUserData() async {
  //   var response = await http.get(Uri.parse(
  //       "https://interactive-talks-default-rtdb.firebaseio.com/usersData.json"));

  //   setState(() {
  //     data = json.decode(response.body);
  //     getDataAsList();
  //   });
  // }

  // getDataAsList() {
  //   if (data != null) {
  //     dataAsIterable = data!.values;

  //     to convert Iterable<dynamic> to List
  //     for (var element in dataAsIterable) {
  //       dataAsList.add(element);
  //     }
  //     length = dataAsList.length;
  //     if (length == 2 * dataAsIterable.length && dataAsIterable.length != 1) {
  //       dataAsList.removeRange((length / 2).toInt() - 1, length);
  //     } else if (length == 2 * dataAsIterable.length &&
  //         dataAsIterable.length == 1) {
  //       dataAsList.removeLast();
  //     }

  //     fill list of users
  //     for (var i = 0; i < length; i++) {
  //       users.add(dataAsList[i].keys.toString().replaceAllMapped(
  //           RegExp(r'[(\)]+'),
  //           (match) => "")); // toconvert into string and remove ()
  //     }
  //   }