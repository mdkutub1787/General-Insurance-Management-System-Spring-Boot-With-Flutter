package com.kutub.InsuranceManagement.service;

import com.kutub.InsuranceManagement.entity.MarineInsuranceBill;
import com.kutub.InsuranceManagement.repository.MarineInsuranceBillRepo;
import com.kutub.InsuranceManagement.repository.MarineInsuranceDetailsRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MarineInsuranceBillService {

    @Autowired
    private MarineInsuranceBillRepo marineInsuranceBillRepo;

    @Autowired
    private MarineInsuranceDetailsRepo marineInsuranceDetailsRepo;

    // Get all Marine Insurance Bills
    public List<MarineInsuranceBill> getAllMarineInsuranceBills() {
        return marineInsuranceBillRepo.findAll();
    }

    // Save a new Marine Insurance Bill with calculations
    public MarineInsuranceBill saveMarineInsuranceBill(MarineInsuranceBill bill) {
        // Perform calculations
        calculatePremiums(bill);
        return marineInsuranceBillRepo.save(bill);
    }

    // Update an existing Marine Insurance Bill with calculations
    public MarineInsuranceBill updateMarineInsuranceBill(MarineInsuranceBill updatedBill, long id) {
        MarineInsuranceBill existingBill = marineInsuranceBillRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Marine Insurance Bill not found with ID: " + id));

        // Update fields
        existingBill.setMarineRate(updatedBill.getMarineRate());
        existingBill.setWarSrccRate(updatedBill.getWarSrccRate());
        existingBill.setStampDuty(updatedBill.getStampDuty());

        // Recalculate net premium and gross premium
        calculatePremiums(existingBill);

        return marineInsuranceBillRepo.save(existingBill);
    }

    // Get Marine Insurance Bill by ID
    public MarineInsuranceBill getMarineInsuranceBillById(long id) {
        return marineInsuranceBillRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Marine Insurance Bill not found with ID: " + id));
    }

    // Delete Marine Insurance Bill by ID
    public void deleteMarineInsuranceBill(long id) {
        marineInsuranceBillRepo.deleteById(id);
    }

    // Calculation method for premiums
    private void calculatePremiums(MarineInsuranceBill bill) {
        double marineRate = bill.getMarineRate() / 100;
        double warSrccRate = bill.getWarSrccRate() / 100;
        double taxRate = 0.15; // Fixed tax rate of 15%

        // Get the sum insured from the related MarineInsuranceDetails
        double sumInsured = bill.getMarineDetails().getSumInsured();

        // Calculate net premium
        double netPremium = (sumInsured * marineRate) + (sumInsured * warSrccRate);
        bill.setNetPremium(roundToTwoDecimalPlaces(netPremium));

        // Calculate tax on net premium
        double tax = netPremium * taxRate;

        // Calculate gross premium
        double grossPremium = netPremium + tax + bill.getStampDuty();
        bill.setGrossPremium(roundToTwoDecimalPlaces(grossPremium));
    }

    // Method to round to two decimal places
    private double roundToTwoDecimalPlaces(double value) {
        return Math.round(value * 100.0) / 100.0;
    }
}
