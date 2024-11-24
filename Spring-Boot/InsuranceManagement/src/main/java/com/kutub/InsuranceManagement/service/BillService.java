package com.kutub.InsuranceManagement.service;

import com.kutub.InsuranceManagement.entity.Bill;
import com.kutub.InsuranceManagement.entity.Policy;
import com.kutub.InsuranceManagement.repository.BillRepository;
import com.kutub.InsuranceManagement.repository.PolicyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BillService {

    @Autowired
    private BillRepository billRepository;

    @Autowired
    private PolicyRepository policyRepository;

    // Get all Bills
    public List<Bill> getAllBill() {
        return billRepository.findAll();
    }

    // Save a new Bill with calculations
    public Bill saveBill(Bill bill) {
        // Validate and fetch the related policy
        Policy policy = policyRepository.findById(bill.getPolicy().getId())
                .orElseThrow(() -> new RuntimeException("Policy not found with ID: " + bill.getPolicy().getId()));

        // Associate the policy with the bill
        bill.setPolicy(policy);

        // Perform premium calculations
        calculatePremiums(bill);

        // Save and return the bill
        return billRepository.save(bill);
    }

    // Update an existing Bill by ID
    public Bill updateBill(Bill updatedBill, int id) {
        // Fetch the existing bill
        Bill existingBill = billRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bill not found with ID: " + id));

        // Update fields
        existingBill.setFire(updatedBill.getFire());
        existingBill.setRsd(updatedBill.getRsd());
        existingBill.setTax(updatedBill.getTax());

        // Recalculate premiums
        calculatePremiums(existingBill);

        // Save the updated bill
        return billRepository.save(existingBill);
    }

    // Delete a Bill by ID
    public void deleteBill(int id) {
        if (!billRepository.existsById(id)) {
            throw new RuntimeException("Bill not found with ID: " + id);
        }
        billRepository.deleteById(id);
    }

    // Get a Bill by its ID
    public Bill getBillById(int id) {
        return billRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bill not found with ID: " + id));
    }

    // Find bills by policyholder name
    public List<Bill> getBillsByPolicyholder(String policyholder) {
        return billRepository.findBillsByPolicyholder(policyholder);
    }

    // Find bills by the associated policy ID
    public List<Bill> findBillByPolicyId(int policyId) {
        return billRepository.findBillsByPolicyId(policyId);
    }

    // Calculation method for premiums
    private void calculatePremiums(Bill bill) {
        double fireRate = bill.getFire() / 100.0; // Fire rate as a fraction
        double rsdRate = bill.getRsd() / 100.0;   // RSD rate as a fraction
        double taxRate = bill.getTax() / 100.0;   // Tax rate as a fraction

        // Get the sum insured from the related policy
        double sumInsured = bill.getPolicy().getSumInsured();

        // Calculate net premium
        double netPremium = (sumInsured * fireRate) + (sumInsured * rsdRate);
        bill.setNetPremium(roundToTwoDecimalPlaces(netPremium));

        // Calculate tax
        double tax = netPremium * taxRate;
        bill.setTax(roundToTwoDecimalPlaces(tax));

        // Calculate gross premium
        double grossPremium = netPremium + tax;
        bill.setGrossPremium(roundToTwoDecimalPlaces(grossPremium));
    }

    // Round values to two decimal places
    private double roundToTwoDecimalPlaces(double value) {
        return Math.round(value * 100.0) / 100.0;
    }

    // Update all bills when policy sumInsured changes
    public void updateBillsForPolicy(Policy updatedPolicy) {
        // Fetch bills associated with the policy
        List<Bill> bills = billRepository.findBillsByPolicyId(updatedPolicy.getId());

        // Update each bill
        for (Bill bill : bills) {
            bill.setPolicy(updatedPolicy); // Update policy reference
            calculatePremiums(bill); // Recalculate premiums
            billRepository.save(bill); // Save the updated bill
        }
    }
}
