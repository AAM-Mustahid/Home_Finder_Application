import 'package:flutter/material.dart';

class RentManagementPage extends StatelessWidget {
  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rent Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your rent payments and invoices. You can pay your rent from here.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text('Property From: Atikur Rahman'),
            Text('Location: Kazipara, Mirpur, Dhaka'),
            Text('Base Rent: 16000tk'),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  int year = 2024 - index;
                  return ExpansionTile(
                    title: Text(
                      '$year',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Month',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Method',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          year == 2024 ? 5 : 12,
                          (int index) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(monthNames[index])),
                              DataCell(Text(
                                  year == 2024 && index < 3 ? 'Paid' : 'Due')),
                              DataCell(Text(year == 2024 && index < 3
                                  ? 'Credit Card'
                                  : 'Pay')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
