package com.kutub.InsuranceManagement.service;

import com.kutub.InsuranceManagement.entity.MarineInsuranceBill;
import com.kutub.InsuranceManagement.entity.MarineInsuranceDetails;
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



    public MarineInsuranceBill saveMarineInsuranceBill(MarineInsuranceBill bill) {
        // Fetch the related policy to ensure it's valid
        MarineInsuranceDetails marinePolicy = marineInsuranceDetailsRepo.findById(bill.getMarineDetails().getId())
                .orElseThrow(() -> new RuntimeException("Policy not found with ID: " + bill.getMarineDetails().getId()));

        // Associate the policy with the bill
        bill.setMarineDetails(marinePolicy);

        // Perform premium calculations
        calculatePremiums(bill);

        // Save and return the bill
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





    // Update all bills when policy sumInsured changes
    public void updateBillsForMarinePolicy(MarineInsuranceDetails updatedPolicy) {
        // Fetch all bills linked to the given Marine Policy
        List<MarineInsuranceBill> bills = marineInsuranceBillRepo.findMarineBillsByMarinePolicyId(updatedPolicy.getId());

        if (bills.isEmpty()) {
            System.out.println("No bills found for Marine Policy ID: " + updatedPolicy.getId());
            return;
        }

        // Update each bill with the new policy details
        for (MarineInsuranceBill bill : bills) {
            bill.setMarineDetails(updatedPolicy); // Update reference

            // Recalculate premium and other dependent fields
            calculatePremiums(bill);

            // Save the updated bill
            marineInsuranceBillRepo.save(bill);
        }
    }
}
