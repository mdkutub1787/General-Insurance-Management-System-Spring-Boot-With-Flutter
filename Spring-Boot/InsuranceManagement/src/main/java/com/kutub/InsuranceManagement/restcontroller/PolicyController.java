package com.kutub.InsuranceManagement.restcontroller;

import com.kutub.InsuranceManagement.entity.Policy;
import com.kutub.InsuranceManagement.service.PolicyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/policy")
@CrossOrigin(origins = "http://localhost:4200/")
public class PolicyController {

    @Autowired
    private PolicyService policyService;

    // Get all policies
    @GetMapping("/")
    public ResponseEntity<List<Policy>> getAllPolicies() {
        List<Policy> policies = policyService.getAllPolicy();
        return ResponseEntity.ok(policies);
    }

    // Save a new policy
    @PostMapping("/save")
    public ResponseEntity<String> savePolicy(@RequestBody Policy policy) {
        policyService.savePolicy(policy);
        return ResponseEntity.status(HttpStatus.CREATED).body("Policy saved successfully.");
    }

    // Update an existing policy
    @PutMapping("/update/{id}")
    public ResponseEntity<String> updatePolicy(@RequestBody Policy policy, @PathVariable int id) {
        try {
            policyService.updatePolicy(policy, id);
            return ResponseEntity.ok("Policy updated successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    // Delete a policy by ID
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deletePolicyById(@PathVariable int id) {
        try {
            policyService.deletePolicy(id);
            return ResponseEntity.ok("Policy deleted successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    // Get a policy by ID
    @GetMapping("/{id}")
    public ResponseEntity<Policy> getPolicyById(@PathVariable int id) {
        try {
            Policy policy = policyService.findById(id);
            return ResponseEntity.ok(policy);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    // Search policy by policyholder
    @GetMapping("/searchpolicyholder")
    public ResponseEntity<List<Policy>> getPolicyByPolicyHolder(@RequestParam String policyholder) {
        List<Policy> policies = policyService.searchPolicyByPolicyHolder(policyholder);
        return ResponseEntity.ok(policies);
    }

    // Search policy by bank name
    @GetMapping("/searchbankname")
    public ResponseEntity<List<Policy>> getPolicyByBankName(@RequestParam String bankname) {
        List<Policy> policies = policyService.searchPolicyByBankName(bankname);
        return ResponseEntity.ok(policies);
    }
}
