import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirePolicy extends StatefulWidget {
  const FirePolicy({Key? key}) : super(key: key);

  @override
  _FirePolicyState createState() => _FirePolicyState();
}

class _FirePolicyState extends State<FirePolicy> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers for form fields
  final TextEditingController dateTEC = TextEditingController();
  final TextEditingController bankNameTEC = TextEditingController();
  final TextEditingController policyholderTEC = TextEditingController();
  final TextEditingController addressTEC = TextEditingController();
  final TextEditingController stockInsuredTEC = TextEditingController();
  final TextEditingController sumInsuredTEC = TextEditingController();
  final TextEditingController interestInsuredTEC = TextEditingController();
  final TextEditingController coverageTEC = TextEditingController();
  final TextEditingController locationTEC = TextEditingController();
  final TextEditingController constructionTEC = TextEditingController();
  final TextEditingController ownerTEC = TextEditingController();
  final TextEditingController usedAsTEC = TextEditingController();
  final TextEditingController periodFromTEC = TextEditingController();
  final TextEditingController periodToTEC = TextEditingController();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    dateTEC.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller, {bool isPeriodFrom = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
        // Set periodToTEC to one year after periodFromTEC
        if (isPeriodFrom) {
          final DateTime periodToDate = DateTime(picked.year + 1, picked.month, picked.day);
          periodToTEC.text = DateFormat('dd-MM-yyyy').format(periodToDate);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Fire Policy Form"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Field
              TextFormField(
                controller: dateTEC,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Date",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, dateTEC),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the date' : null,
              ),
              const SizedBox(height: 10),
              // Bank Name Field
              TextFormField(
                controller: bankNameTEC,
                decoration: const InputDecoration(
                  labelText: "Bank Name",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.account_balance),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the bank name' : null,
              ),
              const SizedBox(height: 10),
              // Policyholder Field
              TextFormField(
                controller: policyholderTEC,
                decoration: const InputDecoration(
                  labelText: "Policyholder",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the policyholder' : null,
              ),
              const SizedBox(height: 10),
              // Address Field
              TextFormField(
                controller: addressTEC,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.home),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the address' : null,
              ),
              const SizedBox(height: 10),
              // Stock Insured Field
              TextFormField(
                controller: stockInsuredTEC,
                decoration: const InputDecoration(
                  labelText: "Stock Insured",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.inventory),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the stock insured' : null,
              ),
              const SizedBox(height: 10),
              // Sum Insured Field
              TextFormField(
                controller: sumInsuredTEC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Sum Insured",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.attach_money),
                ),
                validator: (value) => value == null || double.tryParse(value) == null ? 'Please enter a valid sum insured' : null,
              ),
              const SizedBox(height: 10),
              // Interest Insured Field
              TextFormField(
                controller: interestInsuredTEC,
                decoration: const InputDecoration(
                  labelText: "Interest Insured",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.percent),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the interest insured' : null,
              ),
              const SizedBox(height: 10),
              // Coverage Dropdown Field
              DropdownButtonFormField<String>(
                value: coverageTEC.text.isNotEmpty ? coverageTEC.text : null,
                decoration: const InputDecoration(
                  labelText: "Coverage",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.shield),
                ),
                items: ['Fire &/or Lightning', 'Earthquake', 'Flood'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    coverageTEC.text = newValue!;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Please select coverage' : null,
              ),
              const SizedBox(height: 10),
              // Location Field
              TextFormField(
                controller: locationTEC,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.location_on),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the location' : null,
              ),
              const SizedBox(height: 10),
              // Construction Field
              DropdownButtonFormField<String>(
                value: constructionTEC.text.isNotEmpty ? constructionTEC.text : null,
                decoration: const InputDecoration(
                  labelText: "Construction",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.construction),
                ),
                items: ['Wood', 'Brick', 'Concrete'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    constructionTEC.text = newValue!;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Please select construction type' : null,
              ),
              const SizedBox(height: 10),
              // Owner Field
              TextFormField(
                controller: ownerTEC,
                decoration: const InputDecoration(
                  labelText: "Owner",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.business),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the owner name' : null,
              ),
              const SizedBox(height: 10),
              // Used As Dropdown Field
              DropdownButtonFormField<String>(
                value: usedAsTEC.text.isNotEmpty ? usedAsTEC.text : null,
                decoration: const InputDecoration(
                  labelText: "Used As",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.work),
                ),
                items: ['Shop', 'Warehouse', 'Factory'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    usedAsTEC.text = newValue!;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Please select usage type' : null,
              ),
              const SizedBox(height: 10),
              // Period From Date Picker
              TextFormField(
                controller: periodFromTEC,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Period From",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, periodFromTEC, isPeriodFrom: true),
                validator: (value) => value == null || value.isEmpty ? 'Please select the start date' : null,
              ),
              const SizedBox(height: 10),
              // Period To Date Display
              TextFormField(
                controller: periodToTEC,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Period To",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.calendar_today),
                ),
                validator: (value) => value == null || value.isEmpty ? 'The end date will be set automatically' : null,
              ),
              const SizedBox(height: 10),
              // Submit Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Add submit logic here
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
