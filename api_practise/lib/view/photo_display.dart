import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api_practise/model/photo_model.dart'; // Adjust the import path as needed

class PhotoDisplay extends StatefulWidget {
  const PhotoDisplay({super.key});

  @override
  State<PhotoDisplay> createState() => _PhotoDisplayState();
}

class _PhotoDisplayState extends State<PhotoDisplay> {
  Future<PhotoModel>? _photoFuture;

  @override
  void initState() {
    super.initState();
    _photoFuture = getPhotoList();
  }

  Future<PhotoModel> getPhotoList() async {
    final response = await http.get(
        Uri.parse('https://webhook.site/cbd03deb-cdd6-4664-a81f-24b5d91cc742'));

    if (response.statusCode == 200) {
      var data1 = jsonDecode(response.body) as Map<String, dynamic>;
      return PhotoModel.fromJson(data1);
    } else {
      throw Exception('Failed to load photo list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Display'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<PhotoModel>(
          future: _photoFuture,
          builder: (BuildContext context, AsyncSnapshot<PhotoModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData ||
                snapshot.data?.data == null ||
                snapshot.data!.data!.isEmpty) {
              return const Center(child: Text('No photos available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.data!.length,
                itemBuilder: (context, index) {
                  final photo = snapshot.data!.data![index];
                  return ListTile(
                    title: Text(photo.title ?? 'No title'),
                    subtitle: Text(photo.subcat!.name ?? 'No description'),
                    leading: photo.images != null && photo.images!.isNotEmpty
                        ? Image.network(photo.images![index].url ?? '')
                        : null,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
