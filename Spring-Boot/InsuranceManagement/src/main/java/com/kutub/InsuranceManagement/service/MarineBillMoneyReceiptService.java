package com.kutub.InsuranceManagement.service;

import com.kutub.InsuranceManagement.entity.Bill;
import com.kutub.InsuranceManagement.entity.MarineBillMoneyReceipt;
import com.kutub.InsuranceManagement.entity.MarineInsuranceBill;
import com.kutub.InsuranceManagement.entity.MoneyReceipt;
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

    // Retrieve all marine bill money receipts
    public List<MarineBillMoneyReceipt> getAllMarineBillMoneyReceipt() {
        return marineBillMoneyReceiptRepo.findAll();
    }

    public MarineBillMoneyReceipt saveMarineBillMoneyReceipt(MarineBillMoneyReceipt receipt) {
        // Ensure that the marinebill (MarineInsuranceBill) is managed before saving the receipt
        MarineInsuranceBill managedMarineBill = marineInsuranceBillRepo.findById(receipt.getMarinebill().getId())
                .orElseThrow(() -> new EntityNotFoundException("MarineInsuranceBill not found with id: " + receipt.getMarinebill().getId()));

        // Attach the managed entity back to the receipt
        receipt.setMarinebill(managedMarineBill);

        // Now save the receipt
        return marineBillMoneyReceiptRepo.save(receipt);
    }

    // Find a marine bill money receipt by ID
    public MarineBillMoneyReceipt findById(long id) {
        return marineBillMoneyReceiptRepo.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("MarineBillMoneyReceipt not found with id: " + id));
    }


    // Update an existing marine bill money receipt
    public void updateMarineMoneyReceipt(MarineBillMoneyReceipt updateMarineMoneyReceipt, long id) {
        // Fetch the existing MoneyReceipt from the database
        MarineBillMoneyReceipt existingMoneyReceipt = marineBillMoneyReceiptRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("MoneyReceipt not found with ID: " + id));

        // Update the fields of the existing MoneyReceipt with values from the updated one
        existingMoneyReceipt.setIssuingOffice(updateMarineMoneyReceipt.getIssuingOffice());
        existingMoneyReceipt.setClassOfInsurance(updateMarineMoneyReceipt.getClassOfInsurance());

        // Only update the date if it's explicitly provided (null checks)
        if (updateMarineMoneyReceipt.getDate() != null) {
            existingMoneyReceipt.setDate(updateMarineMoneyReceipt.getDate());
        }

        existingMoneyReceipt.setModeOfPayment(updateMarineMoneyReceipt.getModeOfPayment());
        existingMoneyReceipt.setIssuedAgainst(updateMarineMoneyReceipt.getIssuedAgainst());

        // Check if Bill exists and set it, if necessary
        if (updateMarineMoneyReceipt.getMarinebill() != null && updateMarineMoneyReceipt.getMarinebill().getId() > 0) {
            MarineInsuranceBill marinebill = marineInsuranceBillRepo.findById(updateMarineMoneyReceipt.getMarinebill().getId())
                    .orElseThrow(() -> new RuntimeException("Bill not found with ID: " + updateMarineMoneyReceipt.getMarinebill().getId()));

            // Set the existing marine bill on the MoneyReceipt
            existingMoneyReceipt.setMarinebill(marinebill);
        }

        // Save the updated MoneyReceipt
        marineBillMoneyReceiptRepo.save(existingMoneyReceipt);
    }


    // Delete a marine bill money receipt by ID
    public void deleteMarineBillMoneyReceipt(long id) {
        if (!marineBillMoneyReceiptRepo.existsById(id)) {
            throw new EntityNotFoundException("MarineBillMoneyReceipt not found with id: " + id);
        }
        marineBillMoneyReceiptRepo.deleteById(id);
    }
}
