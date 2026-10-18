import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // ✅ เพิ่มบรรทัดนี้
import 'screen/display.dart';
import 'screen/formscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ แก้ตรงนี้ให้ระบุ options ให้ตรงกับที่สร้างไว้
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'รายงานคะแนนสอบ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const MyHomePage(title: 'รายงานคะแนนสอบ'), // ✅ เปลี่ยนชื่อให้เข้ากับงาน
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title), // ✅ เพิ่มแถบชื่อด้านบน
          backgroundColor: const Color.fromARGB(255, 49, 224, 157),
        ),
        body: const TabBarView(
          children: [
            FormScreen(),    // แท็บ 1: บันทึกคะแนน
            DisplayScreen(), // แท็บ 2: แสดงรายการ
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 49, 224, 157),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(text: "บันทึกคะแนน"),
            Tab(text: "รายชื่อนักเรียน"),
          ],
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          labelColor: Color.fromARGB(255, 255, 255, 255), // ✅ แก้ 225 → 255
        ),
      ),
    );
  }
}