import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../model/student.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  Student myStudent = Student(fname: '', lname: '', email: '', score: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(child: Text("${snapshot.error}")),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final CollectionReference studentCollection =
              FirebaseFirestore.instance.collection('student');

          return Scaffold(
            appBar: AppBar(
              title: const Text("แบบฟอร์มบันทึกคะแนนสอบ"),
              backgroundColor: const Color.fromARGB(255, 49, 224, 157),
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("ชื่อ", style: TextStyle(fontSize: 20)),
                      TextFormField(
                        validator: RequiredValidator(errorText: "กรุณาป้อนชื่อด้วยครับ").call,
                        onSaved: (fname) {
                          myStudent.fname = fname!;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text("นามสกุล", style: TextStyle(fontSize: 20)),
                      TextFormField(
                        validator: RequiredValidator(errorText: "กรุณาป้อนนามสกุลด้วยครับ").call,
                        onSaved: (lname) {
                          myStudent.lname = lname!;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text("อีเมล์", style: TextStyle(fontSize: 20)),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: MultiValidator([
                          EmailValidator(errorText: "รูปแบบอีเมล์ไม่ถูกต้อง"),
                          RequiredValidator(errorText: "กรุณาป้อนอีเมล์ด้วยครับ"),
                        ]).call,
                        onSaved: (email) {
                          myStudent.email = email!;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text("คะแนน", style: TextStyle(fontSize: 20)),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        validator: MultiValidator([
                          RequiredValidator(errorText: "กรุณาป้อนคะแนนสอบด้วยครับ"),
                          PatternValidator(r'^[0-9]+$', errorText: "คะแนนต้องเป็นตัวเลขเท่านั้น"),
                        ]).call,
                        onSaved: (score) {
                          myStudent.score = score!;
                        },
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState?.save();
                              await studentCollection.add({
                                "fname": myStudent.fname,
                                "lname": myStudent.lname,
                                "email": myStudent.email,
                                "score": myStudent.score,
                              });
                              formKey.currentState?.reset();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("บันทึกข้อมูลสำเร็จ")),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "บันทึกข้อมูล",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
