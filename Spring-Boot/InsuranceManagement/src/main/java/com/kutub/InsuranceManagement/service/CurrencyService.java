package com.kutub.InsuranceManagement.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Service
public class CurrencyService {

    // API URL
    private static final String TARGET_CURRENCY = "BDT"; // Target currency (for Bangladeshi Taka)

    private static final String EXCHANGE_RATE_API_URL = "https://api.exchangerate-api.com/v4/latest/USD"; // URL

    public Double fetchExchangeRate() {
        RestTemplate restTemplate = new RestTemplate();
        try {
            Map<String, Object> response = restTemplate.getForObject(EXCHANGE_RATE_API_URL, Map.class);
            if (response != null && response.containsKey("rates")) {
                Map<String, Double> rates = (Map<String, Double>) response.get("rates");
                if (rates != null && rates.containsKey(TARGET_CURRENCY)) {
                    return rates.get(TARGET_CURRENCY);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 1.0; // Default fallback
    }
}
