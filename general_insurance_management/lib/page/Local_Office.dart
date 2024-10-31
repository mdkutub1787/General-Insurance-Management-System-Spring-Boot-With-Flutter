import 'package:flutter/material.dart';

class LocalOffice extends StatelessWidget {
  final String officeName;
  final String address;
  final String contactNumber;
  final String workingHours;

  LocalOffice({
    required this.officeName,
    required this.address,
    required this.contactNumber,
    required this.workingHours,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$officeName Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Office Details
            Text(
              officeName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blueAccent),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Address: $address',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text(
                  'Contact: $contactNumber',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text(
                  'Working Hours: $workingHours',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Office Actions
            ElevatedButton.icon(
              onPressed: () {
                print('View Services clicked');
              },
              icon: Icon(Icons.business_center),
              label: Text('View Services'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {
                print('Manage Appointments clicked');
              },
              icon: Icon(Icons.calendar_today),
              label: Text('Manage Appointments'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {
                print('Edit Profile clicked');
              },
              icon: Icon(Icons.edit),
              label: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
