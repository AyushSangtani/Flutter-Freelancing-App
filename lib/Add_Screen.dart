import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freelancing_app/persistent.dart';
import 'package:freelancing_app/uihelper.dart';
import 'package:uuid/uuid.dart';

import 'bottom_nav_bar.dart';
import 'global_var.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _jobCategoryController = TextEditingController(text: 'Select job category');
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _deadlineDateController = TextEditingController(text: 'Job Deadline Date');
  final _formKey = GlobalKey<FormState>();

  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _jobCategoryController.dispose();
    _jobDescriptionController.dispose();
    _jobTitleController.dispose();
    _deadlineDateController.dispose();
  }

  Widget _textTitles({required String label})
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        label,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
  })
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty)
            {
              return 'Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: TextStyle(color: Colors.black),
          maxLines: valueKey == 'JobDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black),),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),),
              errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red),),
          ),
        ),
      ),
    );
  }

  //CategoryList Dialog
  _showTaskCategoriesDialog({required Size size})
  {
    showDialog(
        context: context,
        builder: (ctx)
        {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                "Job Category",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: ()
                    {
                      setState(()
                      {
                        _jobCategoryController.text = Persistent.jobCategoryList[index];
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: ()
                {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          );
        });
  }

  // Date Picker for deadline Date
  void _pickedDateDialog() async
  {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 0),),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _deadlineDateController.text = '${picked!.year}-${picked!.month}-${picked!.day}';
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch);
      });
    }
  }

  // Upload Jobs
  void _uploadTask() async
  {
    final jobId = Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();

    if (isValid)
    {
      if (_deadlineDateController.text == 'Choose job Deadline date' || _jobCategoryController.text == 'Choose job category')
      {
        UiHelper.CustomAlertBox(context, 'Please pick everything!');
        return;
      }
      setState(()
      {
        _isLoading = true;
      });
      try
      {
        await FirebaseFirestore.instance.collection('jobs').doc(jobId).set({
          'jobId': jobId,
          'uploadedBy': _uid,
          'email': user.email,
          'jobTitle': _jobTitleController.text,
          'jobDescription': _jobDescriptionController.text,
          'jobCategory': _jobCategoryController.text,
          'deadlineDate': _deadlineDateController.text,
          'deadlineDateTimeStamp': deadlineDateTimeStamp,
          'jobComments': [],
          'recruitment': true,
          'createdAt': Timestamp.now(),
          'name': name,
          'userImage': userImage,
          'location': location,
          'applicants': 0,
        });
        await Fluttertoast.showToast(
          msg: 'The task has been uploaded',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18.0,
        );
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(()
        {
          _jobCategoryController.text = 'Choose job category';
          _deadlineDateController.text = 'Choose job Deadline date';
        });
      }
      catch (error)
      {
        setState(()
        {
          _isLoading = false;
        });
        UiHelper.CustomAlertBox(context, error.toString());
      }
      finally
      {
        setState(() {
          _isLoading = false;
        });
      }
    }
    else
    {
      print('Its not valid!');
    }
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        bottomNavigationBar: BottomNavBar(currentIndex: 2),
        appBar: AppBar(
          title: Text("Add Job", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.black54,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Please fill all fields",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Job Category
                            _textTitles(label: "Job Category :"),
                            _textFormFields(
                                valueKey: 'JobCategory',
                                controller: _jobCategoryController,
                                enabled: false,
                                fct: () {
                                  _showTaskCategoriesDialog(size: size);
                                },
                                maxLength: 100),

                            //Job Title
                            _textTitles(label: 'Job Title :'),
                            _textFormFields(
                              valueKey: 'JobTitle',
                              controller: _jobTitleController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100,
                            ),

                            //Job Description
                            _textTitles(label: 'Job Description :'),
                            _textFormFields(
                              valueKey: 'JobDescription',
                              controller: _jobDescriptionController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100,
                            ),

                            //Job Deadline Date
                            _textTitles(label: 'Job Deadline Date :'),
                            _textFormFields(
                              valueKey: 'Deadline',
                              controller: _deadlineDateController,
                              enabled: false,
                              fct: () {
                                _pickedDateDialog();
                              },
                              maxLength: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : UiHelper.CustomButton(() {
                                  _uploadTask();
                                }, 'Post Now')),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
