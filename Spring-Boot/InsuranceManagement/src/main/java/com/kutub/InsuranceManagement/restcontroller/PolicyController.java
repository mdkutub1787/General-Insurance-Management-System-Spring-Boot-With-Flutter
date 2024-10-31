package com.kutub.InsuranceManagement.restcontroller;

import com.kutub.InsuranceManagement.entity.Bill;
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


    @GetMapping("/")
    public List<Policy> getAllPolicies() {
        return policyService.getAllPolicy();
    }


    @PostMapping("/save")
    public void savePolicy(@RequestBody Policy p) {
        policyService.savePolicy(p);
    }


    @PutMapping("/update/{id}")
    public  void updatePolicy(@RequestBody Policy p){
        policyService.savePolicy(p);
    }


    @DeleteMapping("/delete/{id}")
    public void deletePolicyById(@PathVariable int id) {
        policyService.deletePolicy(id);
    }

    @GetMapping("/{id}")
    public Policy getPolicyById(@PathVariable ("id") int id){
        return   policyService.findById(id);
    }



    // Search policy by policyholder
    @GetMapping("/searchpolicyholder")
    public List<Policy> getPolicyByPolicyHolder(@RequestParam String policyholder) {
        return policyService.searchPolicyByPolicyHolder(policyholder);
    }

    // Search policy by bank name
    @GetMapping("/searchbankname")
    public List<Policy> getPolicyByBankName(@RequestParam String bankname) {
        return policyService.searchPolicyByBankName(bankname);
    }

}
