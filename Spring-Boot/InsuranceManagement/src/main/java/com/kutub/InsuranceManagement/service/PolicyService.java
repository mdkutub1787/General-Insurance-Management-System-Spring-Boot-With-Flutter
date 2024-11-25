package com.kutub.InsuranceManagement.service;

import com.kutub.InsuranceManagement.entity.Policy;
import com.kutub.InsuranceManagement.repository.PolicyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PolicyService {

    @Autowired
    private PolicyRepository policyRepository;

    @Autowired
    private BillService billService;

    // Fetch all policies
    public List<Policy> getAllPolicy() {
        return policyRepository.findAll();
    }

    // Save a new policy
    public void savePolicy(Policy policy) {
        if (policy == null) {
            throw new IllegalArgumentException("Policy cannot be null.");
        }
        policyRepository.save(policy);
    }

    // Find policy by ID
    public Policy findById(int id) {
        return policyRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Policy not found with ID: " + id));
    }

    // Update an existing policy and update related bills
    public Policy updatePolicy(Policy updatedPolicy, int id) {
        // Fetch the existing policy
        Policy existingPolicy = policyRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Policy not found with ID: " + id));

        // Update fields
        existingPolicy.setSumInsured(updatedPolicy.getSumInsured());
        existingPolicy.setPolicyholder(updatedPolicy.getPolicyholder());

        // Save the updated policy
        Policy savedPolicy = policyRepository.save(existingPolicy);

        // Trigger Bill updates if sumInsured is changed
        billService.updateBillsForPolicy(savedPolicy);

        return savedPolicy;
    }

    // Delete a policy by ID
    public void deletePolicy(int id) {
        if (!policyRepository.existsById(id)) {
            throw new RuntimeException("Policy not found with ID: " + id);
        }
        policyRepository.deleteById(id);
    }

    // Search policy by policyholder name
    public List<Policy> searchPolicyByPolicyHolder(String policyholder) {
        List<Policy> policies = policyRepository.findByPolicyHolder(policyholder);
        return policies.isEmpty() ? List.of() : policies;
    }

    // Search policies by bank name
    public List<Policy> searchPolicyByBankName(String bankName) {
        List<Policy> policies = policyRepository.findByBankName(bankName);
        return policies.isEmpty() ? List.of() : policies;
    }
}
