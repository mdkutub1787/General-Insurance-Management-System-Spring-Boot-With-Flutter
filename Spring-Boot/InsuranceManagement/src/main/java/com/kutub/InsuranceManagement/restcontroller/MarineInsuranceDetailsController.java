package com.kutub.InsuranceManagement.restcontroller;

import com.kutub.InsuranceManagement.entity.MarineInsuranceDetails;
import com.kutub.InsuranceManagement.entity.Policy;
import com.kutub.InsuranceManagement.service.MarineInsuranceDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/marinepolicy")
@CrossOrigin(origins = "http://localhost:4200/")
public class MarineInsuranceDetailsController {

    @Autowired
    private MarineInsuranceDetailsService marineInsuranceDetailsService;

    // Get all Marine Insurance details
    @GetMapping("/")
    public ResponseEntity<List<MarineInsuranceDetails>> getAllMarineInsuranceDetails() {
        List<MarineInsuranceDetails> marineInsuranceDetailsList = marineInsuranceDetailsService.findAll();
        return new ResponseEntity<>(marineInsuranceDetailsList, HttpStatus.OK);
    }

    // Save new Marine Insurance details
    @PostMapping("/save")
    public ResponseEntity<String> saveMarineInsuranceDetails(@RequestBody MarineInsuranceDetails marineInsuranceDetails) {
        marineInsuranceDetailsService.saveMarineInsuranceDetails(marineInsuranceDetails);
        return ResponseEntity.status(HttpStatus.CREATED).body("Marine Policy saved successfully.");
    }


    // Update an existing policy
    @PutMapping("/update/{id}")
    public ResponseEntity<String> updateMarineInsurance(
            @RequestBody MarineInsuranceDetails policy,
            @PathVariable long id) {
        try {
            MarineInsuranceDetails updatedPolicy = marineInsuranceDetailsService.updateMarineInsuranceDetails(policy, id);
            return ResponseEntity.ok("Marine Policy with ID " + id + " updated successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Error: " + e.getMessage());
        }
    }




    // Get Marine Insurance details by ID
    @GetMapping("/{id}")
    public ResponseEntity<MarineInsuranceDetails> getMarineInsuranceById(@PathVariable long id) {
        MarineInsuranceDetails marineInsuranceDetails = marineInsuranceDetailsService.findById(id);
        if (marineInsuranceDetails != null) {
            return new ResponseEntity<>(marineInsuranceDetails, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // Delete Marine Insurance details by ID
    // Delete Marine Insurance details by ID
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteMarineInsurance(@PathVariable long id) {
        try {
            marineInsuranceDetailsService.deleteMarineInsuranceDetails(id);
            return new ResponseEntity<>("Marine Insurance Details deleted successfully.", HttpStatus.OK);
        } catch (IllegalArgumentException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
        }
    }
}
