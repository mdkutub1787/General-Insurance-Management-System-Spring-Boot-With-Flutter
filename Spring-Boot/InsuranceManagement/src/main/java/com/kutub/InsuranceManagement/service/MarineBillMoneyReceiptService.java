package com.kutub.InsuranceManagement.service;

import com.kutub.InsuranceManagement.entity.MarineBillMoneyReceipt;
import com.kutub.InsuranceManagement.entity.MarineInsuranceBill;
import com.kutub.InsuranceManagement.repository.MarineBillMoneyReceiptRepo;
import com.kutub.InsuranceManagement.repository.MarineInsuranceBillRepo;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class MarineBillMoneyReceiptService {

    @Autowired
    private MarineBillMoneyReceiptRepo marineBillMoneyReceiptRepo;

    @Autowired
    private MarineInsuranceBillRepo marineInsuranceBillRepo; // Inject MarineInsuranceBillRepo to fetch the bill

    public MarineBillMoneyReceipt saveMarineBillMoneyReceipt(MarineBillMoneyReceipt receipt) {
        // Ensure that the marinebill (MarineInsuranceBill) is managed before saving the receipt
        MarineInsuranceBill managedMarineBill = marineInsuranceBillRepo.findById(receipt.getMarinebill().getId())
                .orElseThrow(() -> new EntityNotFoundException("MarineInsuranceBill not found with id: " + receipt.getMarinebill().getId()));

        // Attach the managed entity back to the receipt
        receipt.setMarinebill(managedMarineBill);

        // Now save the receipt
        return marineBillMoneyReceiptRepo.save(receipt);
    }

    // Retrieve all marine bill money receipts
    public List<MarineBillMoneyReceipt> getAllMarineBillMoneyReceipt() {
        return marineBillMoneyReceiptRepo.findAll();
    }

//    // Save a new marine bill money receipt
//    public MarineBillMoneyReceipt saveMarineBillMoneyReceipt(MarineBillMoneyReceipt receipt) {
//        return marineBillMoneyReceiptRepo.save(receipt); // Return the saved entity
//    }

    // Find a marine bill money receipt by ID
    public MarineBillMoneyReceipt findById(long id) {
        return marineBillMoneyReceiptRepo.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("MarineBillMoneyReceipt not found with id: " + id));
    }

    // Update an existing marine bill money receipt
    @Transactional
    public MarineBillMoneyReceipt updateMarineBillMoneyReceipt(MarineBillMoneyReceipt updatedReceipt, long id) {
        MarineBillMoneyReceipt existingReceipt = findById(id);  // Check if the entity exists
        existingReceipt.setIssuingOffice(updatedReceipt.getIssuingOffice());
        existingReceipt.setClassOfInsurance(updatedReceipt.getClassOfInsurance());
        existingReceipt.setDate(updatedReceipt.getDate());
        existingReceipt.setModeOfPayment(updatedReceipt.getModeOfPayment());
        existingReceipt.setIssuedAgainst(updatedReceipt.getIssuedAgainst());
        existingReceipt.setMarinebill(updatedReceipt.getMarinebill());

        return marineBillMoneyReceiptRepo.save(existingReceipt); // Return the updated entity
    }

    // Delete a marine bill money receipt by ID
    public void deleteMarineBillMoneyReceipt(long id) {
        if (!marineBillMoneyReceiptRepo.existsById(id)) {
            throw new EntityNotFoundException("MarineBillMoneyReceipt not found with id: " + id);
        }
        marineBillMoneyReceiptRepo.deleteById(id);
    }
}
