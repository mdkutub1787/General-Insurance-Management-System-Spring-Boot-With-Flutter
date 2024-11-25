package com.kutub.InsuranceManagement.service;

import com.kutub.InsuranceManagement.entity.MarineInsuranceDetails;
import com.kutub.InsuranceManagement.entity.Policy;
import com.kutub.InsuranceManagement.repository.MarineInsuranceDetailsRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MarineInsuranceDetailsService {

    @Autowired
    private MarineInsuranceDetailsRepo marineInsuranceDetailsRepo;

    @Autowired
    private CurrencyService currencyService;

    @Autowired
    private MarineInsuranceBillService marineInsuranceBillService;

    // Get all Marine Insurance details
    public List<MarineInsuranceDetails> findAll() {
        return marineInsuranceDetailsRepo.findAll();
    }


    public void saveMarineInsuranceDetails(MarineInsuranceDetails marineInsuranceDetails) {
        double exchangeRate = currencyService.fetchExchangeRate().doubleValue();
        marineInsuranceDetails.convertSumInsuredUsd(exchangeRate);
        if (marineInsuranceDetails == null) {
            throw new IllegalArgumentException("Marine Insurance Details cannot be null.");
        }
        marineInsuranceDetailsRepo.save(marineInsuranceDetails);
    }

    // Update Marine Insurance details and trigger related updates
    public MarineInsuranceDetails updateMarineInsuranceDetails(MarineInsuranceDetails updatedDetails, long id) {
        // Fetch the existing policy
        MarineInsuranceDetails existingPolicy = marineInsuranceDetailsRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Marine Policy not found with ID: " + id));

        // Validate the updated details
        if (updatedDetails == null) {
            throw new IllegalArgumentException("Updated policy details cannot be null.");
        }

        // Update only changed fields
        boolean sumInsuredChanged = updatedDetails.getSumInsured() != existingPolicy.getSumInsured();

        if (sumInsuredChanged) {
            existingPolicy.setSumInsured(updatedDetails.getSumInsured());
        }

        if (updatedDetails.getSumInsuredUsd() != existingPolicy.getSumInsuredUsd()) {
            existingPolicy.setSumInsuredUsd(updatedDetails.getSumInsuredUsd());
        }

        if (!updatedDetails.getPolicyholder().equals(existingPolicy.getPolicyholder())) {
            existingPolicy.setPolicyholder(updatedDetails.getPolicyholder());
        }

        // Save the updated policy
        MarineInsuranceDetails savedPolicy = marineInsuranceDetailsRepo.save(existingPolicy);

        // Trigger related bill updates if sumInsured has changed
        if (sumInsuredChanged) {
            marineInsuranceBillService.updateBillsForMarinePolicy(savedPolicy);
        }

        return savedPolicy;
    }




    // Get Marine Insurance by ID
    public MarineInsuranceDetails findById(long id) {
        return marineInsuranceDetailsRepo.findById(id).orElse(null);
    }



    // Delete Marine Insurance by ID
    public void deleteMarineInsuranceDetails(long id) {
        if (marineInsuranceDetailsRepo.existsById(id)) {
            marineInsuranceDetailsRepo.deleteById(id);
        } else {
            throw new IllegalArgumentException("Marine Insurance Details with ID " + id + " does not exist");
        }
    }
}
