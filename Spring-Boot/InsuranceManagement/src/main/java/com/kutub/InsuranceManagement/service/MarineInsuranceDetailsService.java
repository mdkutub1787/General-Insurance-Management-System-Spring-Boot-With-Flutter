package com.kutub.InsuranceManagement.service;

import com.kutub.InsuranceManagement.entity.MarineInsuranceDetails;
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

    // Create or Update Marine Insurance
    public MarineInsuranceDetails createOrUpdateMarineInsurance(MarineInsuranceDetails marineInsuranceDetails) {
        double exchangeRate = currencyService.fetchExchangeRate().doubleValue();
        marineInsuranceDetails.convertSumInsuredUsd(exchangeRate);
        return marineInsuranceDetailsRepo.save(marineInsuranceDetails);
    }

    // Get Marine Insurance by ID
    public MarineInsuranceDetails findById(long id) {
        return marineInsuranceDetailsRepo.findById(id).orElse(null);
    }

    // Get all Marine Insurance details
    public List<MarineInsuranceDetails> findAll() {
        return marineInsuranceDetailsRepo.findAll();
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
